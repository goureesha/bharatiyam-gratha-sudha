import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/shloka.dart';
import '../data/content_data.dart';

/// Service for fetching content from Firestore with offline caching.
/// Falls back to bundled ContentData if Firestore is unavailable.
class FirebaseService extends ChangeNotifier {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  FirebaseFirestore? _db;
  bool _initialized = false;
  bool _useFirestore = false;
  int _contentVersion = 0;

  bool get isInitialized => _initialized;
  bool get useFirestore => _useFirestore;
  int get contentVersion => _contentVersion;

  // ── Initialization ──────────────────────────────────────────

  /// Initialize Firebase. Call once in main().
  Future<void> init() async {
    try {
      await Firebase.initializeApp();
      _db = FirebaseFirestore.instance;

      // Enable offline persistence
      _db!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Check if Firestore has content
      final configDoc = await _db!.collection('config').doc('app').get();
      if (configDoc.exists) {
        _contentVersion = configDoc.data()?['contentVersion'] ?? 0;
        _useFirestore = _contentVersion > 0;
      }

      _initialized = true;
      debugPrint('🔥 Firebase initialized. Firestore content: $_useFirestore (v$_contentVersion)');
    } catch (e) {
      debugPrint('⚠️ Firebase init failed, using bundled content: $e');
      _initialized = false;
      _useFirestore = false;
    }
  }

  // ── Categories ──────────────────────────────────────────────

  /// Fetch categories from Firestore, fallback to bundled data.
  Future<List<AppCategory>> getCategories() async {
    if (!_useFirestore) return ContentData.categories.values.toList();
    try {
      final snap = await _db!.collection('categories').get();
      return snap.docs.map((d) => AppCategory.fromFirestore(d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore categories error: $e');
      return ContentData.categories.values.toList();
    }
  }

  // ── Books ───────────────────────────────────────────────────

  /// Fetch all books (metadata only, no chapters/shlokas loaded).
  Future<List<Book>> getAllBooks() async {
    if (!_useFirestore) return ContentData.books;
    try {
      final snap = await _db!.collection('books').orderBy('order').get();
      return snap.docs.map((d) => Book.fromFirestore(d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore books error: $e');
      return ContentData.books;
    }
  }

  /// Get books by category.
  Future<List<Book>> getBooksByCategory(String categoryId) async {
    if (!_useFirestore) return ContentData.getBooksByCategory(categoryId);
    try {
      final snap = await _db!.collection('books')
          .where('category', isEqualTo: categoryId)
          .orderBy('order')
          .get();
      return snap.docs.map((d) => Book.fromFirestore(d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore error: $e');
      return ContentData.getBooksByCategory(categoryId);
    }
  }

  /// Get books by subcategory.
  Future<List<Book>> getBooksBySubcategory(String subcategoryId) async {
    if (!_useFirestore) return ContentData.getBooksBySubcategory(subcategoryId);
    try {
      final snap = await _db!.collection('books')
          .where('subcategory', isEqualTo: subcategoryId)
          .orderBy('order')
          .get();
      return snap.docs.map((d) => Book.fromFirestore(d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore error: $e');
      return ContentData.getBooksBySubcategory(subcategoryId);
    }
  }

  /// Get books by god.
  Future<List<Book>> getBooksByGod(String godId) async {
    if (!_useFirestore) return ContentData.getBooksByGod(godId);
    try {
      final snap = await _db!.collection('books')
          .where('godRelated', arrayContains: godId)
          .get();
      return snap.docs.map((d) => Book.fromFirestore(d.data())).toList();
    } catch (e) {
      debugPrint('⚠️ Firestore error: $e');
      return ContentData.getBooksByGod(godId);
    }
  }

  /// Get a single book by ID with its chapters and shlokas.
  Future<Book?> getBookWithContent(String bookId) async {
    if (!_useFirestore) return ContentData.getBookById(bookId);
    try {
      final bookDoc = await _db!.collection('books').doc(bookId).get();
      if (!bookDoc.exists) return ContentData.getBookById(bookId);

      // Fetch chapters for this book
      final chaptersSnap = await _db!.collection('chapters')
          .where('bookId', isEqualTo: bookId)
          .orderBy('order')
          .get();

      final chapters = <Chapter>[];
      for (final chDoc in chaptersSnap.docs) {
        // Fetch shlokas for each chapter
        final shlokasSnap = await _db!.collection('shlokas')
            .where('chapterId', isEqualTo: chDoc.id)
            .orderBy('order')
            .get();
        final shlokas = shlokasSnap.docs
            .map((s) => Shloka.fromFirestore(s.data()))
            .toList();
        chapters.add(Chapter.fromFirestore(chDoc.data(), shlokas: shlokas));
      }

      return Book.fromFirestore(bookDoc.data()!, chapters: chapters);
    } catch (e) {
      debugPrint('⚠️ Firestore book content error: $e');
      return ContentData.getBookById(bookId);
    }
  }

  // ── Search ──────────────────────────────────────────────────

  /// Search across all content. Firestore doesn't support full-text search natively,
  /// so we search locally from cached/bundled data.
  Future<List<Shloka>> searchShlokas(String query) async {
    // For now, use bundled search (works offline too)
    // TODO: Implement Algolia/Typesense for server-side search
    return ContentData.searchShlokas(query);
  }

  // ── Content Version Check ───────────────────────────────────

  /// Check if new content is available on the server.
  Future<bool> hasNewContent() async {
    if (_db == null) return false;
    try {
      final prefs = await SharedPreferences.getInstance();
      final localVersion = prefs.getInt('content_version') ?? 0;
      final configDoc = await _db!.collection('config').doc('app').get();
      if (configDoc.exists) {
        final serverVersion = configDoc.data()?['contentVersion'] ?? 0;
        return serverVersion > localVersion;
      }
    } catch (_) {}
    return false;
  }

  /// Mark current content version as synced.
  Future<void> markContentSynced() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('content_version', _contentVersion);
  }
}
