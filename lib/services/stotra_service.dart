import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/stotra.dart';

class StotraService extends ChangeNotifier {
  List<StotraCategory> _mainCategories = [];
  List<StotraCategory> _extrasCategories = [];
  bool _isLoaded = false;

  List<StotraCategory> get mainCategories => _mainCategories;
  List<StotraCategory> get extrasCategories => _extrasCategories;
  List<StotraCategory> get allCategories => [..._mainCategories, ..._extrasCategories];
  bool get isLoaded => _isLoaded;

  int get totalStotras =>
      allCategories.fold(0, (sum, cat) => sum + cat.stotras.length);

  Future<void> init() async {
    if (_isLoaded) return;

    // 1. Try loading from Firestore
    try {
      final firestore = FirebaseFirestore.instance;
      final booksSnap = await firestore.collection('books').get();
      final chaptersSnap = await firestore.collection('chapters').get();

      // Group chunked stotra parts by base ID
      final Map<String, Map<int, String>> stotraParts = {}; // baseId -> { partIndex -> content }
      final Map<String, Map<String, dynamic>> stotraMetadata = {}; // baseId -> data

      for (final doc in chaptersSnap.docs) {
        final data = doc.data();
        final id = doc.id;
        
        String baseId = id;
        int partIndex = 0;
        
        if (id.contains('_part_')) {
          final parts = id.split('_part_');
          baseId = parts[0];
          partIndex = int.tryParse(parts[1]) ?? 0;
        }
        
        stotraParts.putIfAbsent(baseId, () => {})[partIndex] = data['content'] as String? ?? '';
        
        stotraMetadata.putIfAbsent(baseId, () => {
          'bookId': data['bookId'] as String? ?? '',
          'title': data['title'] as String? ?? '',
          'font': data['font'] as String? ?? 'brhknd',
          'isUnicode': data['isUnicode'] == true,
        });
      }

      final Map<String, List<Stotra>> stotrasByBook = {};
      for (final baseId in stotraParts.keys) {
        final partsMap = stotraParts[baseId]!;
        final metadata = stotraMetadata[baseId]!;
        final bookId = metadata['bookId'] as String;
        
        final sortedPartIndices = partsMap.keys.toList()..sort();
        final fullContent = sortedPartIndices.map((idx) => partsMap[idx]!).join('');
        
        final stotra = Stotra(
          id: baseId,
          title: metadata['title'] as String? ?? '',
          content: fullContent,
          font: metadata['font'] as String? ?? 'brhknd',
          isUnicode: metadata['isUnicode'] == true,
          categoryId: bookId,
          categoryTitle: '', // populated below
        );
        stotrasByBook.putIfAbsent(bookId, () => []).add(stotra);
      }

      final List<StotraCategory> loadedMain = [];
      final List<StotraCategory> loadedExtras = [];

      for (final doc in booksSnap.docs) {
        final data = doc.data();
        final id = doc.id;
        final category = data['category'] as String? ?? '';
        
        if (category == 'stotra_main' || category == 'stotra_extras') {
          final list = stotrasByBook[id] ?? [];
          final categoryTitle = data['title'] as String? ?? '';
          
          // Re-map category titles for each stotra in this category
          final mappedList = list.map((s) => Stotra(
            id: s.id,
            title: s.title,
            content: s.content,
            font: s.font,
            isUnicode: s.isUnicode,
            categoryId: s.categoryId,
            categoryTitle: categoryTitle,
          )).toList();
          
          mappedList.sort((a, b) => a.id.compareTo(b.id));
          
          final stotraCategory = StotraCategory(
            id: id,
            title: categoryTitle,
            titleEn: data['titleEn'] as String? ?? '',
            icon: data['icon'] as String? ?? '',
            count: mappedList.length,
            stotras: mappedList,
          );
          
          if (category == 'stotra_main') {
            loadedMain.add(stotraCategory);
          } else {
            loadedExtras.add(stotraCategory);
          }
        }
      }

      if (loadedMain.isNotEmpty || loadedExtras.isNotEmpty) {
        loadedMain.sort((a, b) => a.titleEn.compareTo(b.titleEn));
        loadedExtras.sort((a, b) => a.titleEn.compareTo(b.titleEn));
        _mainCategories = loadedMain;
        _extrasCategories = loadedExtras;
        _isLoaded = true;
        debugPrint('📚 Loaded ${totalStotras} stotras in ${allCategories.length} categories from Firestore');
        notifyListeners();
        return;
      }
    } catch (e) {
      debugPrint('⚠️ StotraService: Firestore load failed, falling back to local JSON: $e');
    }

    // 2. Fallback to Local Asset
    try {
      final jsonStr = await rootBundle.loadString('assets/data/stotra_data.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      _mainCategories = (data['mainCategories'] as List<dynamic>?)
          ?.map((c) => StotraCategory.fromJson(Map<String, dynamic>.from(c)))
          .toList() ?? [];

      _extrasCategories = (data['extrasCategories'] as List<dynamic>?)
          ?.map((c) => StotraCategory.fromJson(Map<String, dynamic>.from(c)))
          .toList() ?? [];

      _isLoaded = true;
      debugPrint('📚 Loaded ${totalStotras} stotras in ${allCategories.length} categories from local JSON');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading stotra data: $e');
    }
  }

  StotraCategory? getCategory(String id) {
    for (final cat in allCategories) {
      if (cat.id == id) return cat;
    }
    return null;
  }

  Stotra? getStotra(String id) {
    for (final cat in allCategories) {
      for (final stotra in cat.stotras) {
        if (stotra.id == id) return stotra;
      }
    }
    return null;
  }

  List<Stotra> search(String query) {
    if (query.isEmpty) return [];
    final q = query.toLowerCase();
    final results = <Stotra>[];
    for (final cat in allCategories) {
      for (final stotra in cat.stotras) {
        if (stotra.title.toLowerCase().contains(q) ||
            cat.title.toLowerCase().contains(q) ||
            cat.titleEn.toLowerCase().contains(q)) {
          results.add(stotra);
        }
      }
    }
    return results;
  }
}
