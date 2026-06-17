import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/scripture.dart';

class ScriptureService extends ChangeNotifier {
  List<ScriptureBook> _books = [];
  bool _isLoaded = false;

  List<ScriptureBook> get books => _books;
  bool get isLoaded => _isLoaded;

  Future<void> init() async {
    if (_isLoaded) return;
    
    // 1. Try loading from Firestore
    try {
      final firestore = FirebaseFirestore.instance;
      final booksSnap = await firestore.collection('books').get();
      final chaptersSnap = await firestore.collection('chapters').get();

      final Map<String, List<ScriptureChapter>> chaptersByBook = {};
      for (final doc in chaptersSnap.docs) {
        final data = doc.data();
        final bookId = data['bookId'] as String? ?? '';
        final chapter = ScriptureChapter(
          id: doc.id,
          title: data['title'] as String? ?? '',
          content: data['content'] as String? ?? '',
        );
        chaptersByBook.putIfAbsent(bookId, () => []).add(chapter);
      }

      final List<ScriptureBook> loadedBooks = [];
      for (final doc in booksSnap.docs) {
        final data = doc.data();
        final id = doc.id;
        final category = data['category'] as String? ?? '';
        
        if (['gita', 'upanishad', 'purana', 'smriti'].contains(category)) {
          final bookChapters = chaptersByBook[id] ?? [];
          // Sort chapters by ID or order if we want, default is their insertion order
          bookChapters.sort((a, b) {
            // Try sorting by numeric suffix in ID if present (e.g. book_ch_1 vs book_ch_2)
            final aNum = int.tryParse(a.id.split('_').last) ?? 0;
            final bNum = int.tryParse(b.id.split('_').last) ?? 0;
            if (aNum != 0 && bNum != 0) {
              return aNum.compareTo(bNum);
            }
            return a.id.compareTo(b.id);
          });
          
          loadedBooks.add(ScriptureBook(
            id: id,
            title: data['title'] as String? ?? '',
            titleEn: data['titleEn'] as String? ?? '',
            category: category,
            icon: data['icon'] as String? ?? '🕉️',
            chapters: bookChapters,
          ));
        }
      }

      if (loadedBooks.isNotEmpty) {
        // Sort books by titleEn or order if we wish
        loadedBooks.sort((a, b) => a.titleEn.compareTo(b.titleEn));
        _books = loadedBooks;
        _isLoaded = true;
        debugPrint('📚 ScriptureService: Loaded ${_books.length} scriptural books from Firestore');
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('⚠️ ScriptureService: Firestore load failed, falling back to local JSON: $e');
    }

    // 2. Fallback to Local Asset
    try {
      final jsonStr = await rootBundle.loadString('assets/data/scriptures_data.json');
      final List<dynamic> decoded = json.decode(jsonStr);
      _books = decoded.map((item) => ScriptureBook.fromJson(Map<String, dynamic>.from(item))).toList();
      _isLoaded = true;
      debugPrint('📚 ScriptureService: Loaded ${_books.length} scriptural books from local JSON');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ ScriptureService: Error loading scriptures JSON: $e');
    }
  }

  List<ScriptureBook> getByCategory(String category) {
    return _books.where((b) => b.category == category).toList();
  }

  ScriptureBook? getBook(String id) {
    for (final book in _books) {
      if (book.id == id) return book;
    }
    return null;
  }
}
