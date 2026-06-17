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

    // Load directly from Local Asset
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
