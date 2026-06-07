import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import '../models/shloka.dart';
import '../data/content_data.dart';

/// Service for fetching content from Firestore with offline caching.
/// Falls back to bundled ContentData if Firestore is unavailable.
/// Caches all data in memory for synchronous access by UI.
class FirebaseService extends ChangeNotifier {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore? _db;
  bool _initialized = false;
  bool _useFirestore = false;
  bool _loading = false;

  // Cached data — UI reads from these
  List<Book> _books = [];
  Map<String, AppCategory> _categories = {};

  bool get isInitialized => _initialized;
  bool get useFirestore => _useFirestore;
  bool get isLoading => _loading;
  List<Book> get books => _books;
  Map<String, AppCategory> get categories => _categories;

  // ── Initialization ──────────────────────────────────────────

  Future<void> init() async {
    try {
      _db = FirebaseFirestore.instance;

      // Enable offline persistence
      _db!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      _initialized = true;
      debugPrint('🔥 Firebase Firestore initialized');

      // Load data from Firestore
      await refreshData();
    } catch (e) {
      debugPrint('⚠️ Firebase init failed, using bundled content: $e');
      _initialized = false;
      _useFirestore = false;
      _loadBundledData();
    }
  }

  /// Load bundled static data as fallback
  void _loadBundledData() {
    _categories = Map.from(ContentData.categories);
    _books = List.from(ContentData.books);
    _useFirestore = false;
    notifyListeners();
  }

  /// Refresh all data from Firestore
  Future<void> refreshData() async {
    if (_db == null) {
      _loadBundledData();
      return;
    }

    _loading = true;
    notifyListeners();

    try {
      // Force fetch from server, not cache
      const serverOpts = GetOptions(source: Source.server);
      final booksSnap = await _db!.collection('books').get(serverOpts);

      if (booksSnap.docs.isEmpty) {
        debugPrint('📦 Firestore empty, using bundled data');
        _loadBundledData();
        _loading = false;
        notifyListeners();
        return;
      }

      _useFirestore = true;
      debugPrint('🔥 Loading ${booksSnap.docs.length} books from Firestore');

      // Load all books with their chapters and shlokas
      final loadedBooks = <Book>[];
      for (final bookDoc in booksSnap.docs) {
        final bookData = bookDoc.data();
        bookData['id'] = bookDoc.id;

        // Fetch chapters for this book
        final chapSnap = await _db!.collection('chapters')
            .where('bookId', isEqualTo: bookDoc.id)
            .get(serverOpts);

        final chapters = <Chapter>[];
        final sortedChapDocs = chapSnap.docs.toList()
          ..sort((a, b) => (a.data()['number'] ?? 0).compareTo(b.data()['number'] ?? 0));

        for (final chapDoc in sortedChapDocs) {
          final chapData = chapDoc.data();
          chapData['id'] = chapDoc.id;

          // Fetch shlokas for this chapter
          final shlokaSnap = await _db!.collection('shlokas')
              .where('chapterId', isEqualTo: chapDoc.id)
              .get(serverOpts);

          final sortedShlokaDocs = shlokaSnap.docs.toList()
            ..sort((a, b) => (a.data()['order'] ?? 0).compareTo(b.data()['order'] ?? 0));

          final shlokas = sortedShlokaDocs.map((s) {
            final sData = s.data();
            sData['id'] = s.id;
            return Shloka.fromFirestore(sData);
          }).toList();

          chapters.add(Chapter.fromFirestore(chapData, shlokas: shlokas));
        }

        loadedBooks.add(Book.fromFirestore(bookData, chapters: chapters));
      }

      // Sort books by order
      loadedBooks.sort((a, b) => a.order.compareTo(b.order));
      _books = loadedBooks;

      // Load categories from Firestore or use bundled
      final catSnap = await _db!.collection('categories').get(serverOpts);
      if (catSnap.docs.isNotEmpty) {
        _categories = {};
        for (final doc in catSnap.docs) {
          final cat = AppCategory.fromFirestore(doc.data());
          _categories[cat.id] = cat;
        }
        // Override deity subcategory icons with local assets
        _overrideDeityIcons();
      } else {
        _categories = Map.from(ContentData.categories);
      }

      debugPrint('✅ Loaded ${_books.length} books, ${_categories.length} categories from Firestore');
    } catch (e) {
      debugPrint('⚠️ Firestore load error, using bundled: $e');
      _loadBundledData();
    }

    _loading = false;
    notifyListeners();
  }

  // ── Synchronous data access (for UI) ────────────────────────

  List<Book> getBooksByCategory(String categoryId) {
    return _books.where((b) => b.category == categoryId).toList();
  }

  List<Book> getBooksBySubcategory(String subcategoryId) {
    return _books.where((b) => b.subcategory == subcategoryId).toList();
  }

  List<Book> getBooksByGod(String godId) {
    return _books.where((b) => b.godRelated.contains(godId)).toList();
  }

  Book? getBookById(String bookId) {
    try {
      return _books.firstWhere((b) => b.id == bookId);
    } catch (_) {
      return null;
    }
  }

  List<Shloka> searchShlokas(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    final results = <Shloka>[];
    for (final book in _books) {
      for (final chapter in book.chapters) {
        for (final shloka in chapter.shlokas) {
          if (shloka.sanskrit.toLowerCase().contains(q) ||
              shloka.kannada.toLowerCase().contains(q) ||
              shloka.meaning.toLowerCase().contains(q) ||
              (shloka.explanation?.toLowerCase().contains(q) ?? false)) {
            results.add(shloka.copyWith(
              bookId: book.id, bookTitle: book.title,
              bookTitleEn: book.titleEn, chapterTitle: chapter.title,
              category: book.category, subcategory: book.subcategory,
            ));
          }
        }
      }
    }
    return results;
  }

  List<Shloka> getAllShlokas() {
    final all = <Shloka>[];
    for (final book in _books) {
      for (final chapter in book.chapters) {
        for (final shloka in chapter.shlokas) {
          all.add(shloka.copyWith(
            bookId: book.id, bookTitle: book.title,
            bookTitleEn: book.titleEn, chapterTitle: chapter.title,
          ));
        }
      }
    }
    return all;
  }

  /// Override subcategory icons with local asset paths for known deities
  static const _deityIcons = <String, String>{
    'shiva': 'images/shiva.png',
    'vishnu': 'images/vishnu.png',
    'devi': 'images/devi.png',
    'ganesha': 'images/ganesha.png',
    'hanuman': 'images/hanuman.png',
    'surya': 'images/surya.png',
    'krishna': 'images/krishna.png',
    'rama': 'images/rama.png',
  };

  void _overrideDeityIcons() {
    final updated = <String, AppCategory>{};
    for (final entry in _categories.entries) {
      final cat = entry.value;
      final fixedSubs = cat.subcategories.map((sub) {
        final localIcon = _deityIcons[sub.id];
        if (localIcon != null) {
          return SubCategory(
            id: sub.id,
            title: sub.title,
            titleEn: sub.titleEn,
            icon: localIcon,
          );
        }
        return sub;
      }).toList();
      updated[entry.key] = AppCategory(
        id: cat.id,
        title: cat.title,
        titleEn: cat.titleEn,
        icon: cat.icon,
        description: cat.description,
        subcategories: fixedSubs,
      );
    }
    _categories = updated;
  }
}
