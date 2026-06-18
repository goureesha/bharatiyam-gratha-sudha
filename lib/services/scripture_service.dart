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
    
    // Load directly from Local Asset
    try {
      final jsonStr = await rootBundle.loadString('assets/data/scriptures_index.json');
      final List<dynamic> decoded = json.decode(jsonStr);
      _books = decoded.map((item) => ScriptureBook.fromJson(Map<String, dynamic>.from(item))).toList();
      _isLoaded = true;
      debugPrint('📚 ScriptureService: Loaded ${_books.length} scriptural books from local JSON');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ ScriptureService: Error loading scriptures JSON: $e');
    }
  }

  Future<String> loadChapterContent(String chapterId) async {
    try {
      return await rootBundle.loadString('assets/data/chapters/$chapterId.txt');
    } catch (e) {
      debugPrint('❌ ScriptureService: Error loading chapter content ($chapterId): $e');
      return '';
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
