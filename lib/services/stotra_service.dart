import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/stotra.dart';
import '../models/svara_mantra.dart';

class StotraService extends ChangeNotifier {
  List<StotraCategory> _mainCategories = [];
  List<StotraCategory> _extrasCategories = [];
  SvaraCatalog? _svaraCatalog;
  bool _isLoaded = false;

  List<StotraCategory> get mainCategories => _mainCategories;
  List<StotraCategory> get extrasCategories => _extrasCategories;
  List<StotraCategory> get allCategories =>
      [..._mainCategories, ..._extrasCategories];
  SvaraCatalog? get svaraCatalog => _svaraCatalog;
  bool get isLoaded => _isLoaded;

  int get totalStotras =>
      allCategories.fold(0, (sum, cat) => sum + cat.stotras.length);

  int get totalShlokas =>
      _mainCategories.fold(0, (sum, cat) => sum + cat.shlokas.length);

  int get totalMantras =>
      _mainCategories.fold(0, (sum, cat) => sum + cat.mantras.length);

  int get totalBhajanas =>
      _mainCategories.fold(0, (sum, cat) => sum + cat.bhajanas.length);

  int get totalSvaraMantras =>
      _svaraCatalog?.totalItems ?? allSvaraMantras.length;

  List<Stotra> get allSvaraMantras =>
      allCategories.expand((c) => c.stotras).where((s) => s.hasSvara).toList();

  List<StotraCategory> get categoriesWithShlokas =>
      _mainCategories.where((c) => c.shlokas.isNotEmpty).toList();

  List<StotraCategory> get categoriesWithMantras =>
      _mainCategories.where((c) => c.mantras.isNotEmpty).toList();

  List<StotraCategory> get categoriesWithBhajanas =>
      _mainCategories.where((c) => c.bhajanas.isNotEmpty).toList();

  Future<void> init() async {
    if (_isLoaded) return;

    // Load directly from Local Asset
    try {
      final jsonStr =
          await rootBundle.loadString('assets/data/stotra_index.json');
      final data = json.decode(jsonStr) as Map<String, dynamic>;

      _mainCategories = (data['mainCategories'] as List<dynamic>?)
              ?.map((c) => StotraCategory.fromJson(Map<String, dynamic>.from(c)))
              .toList() ??
          [];

      _extrasCategories = (data['extrasCategories'] as List<dynamic>?)
              ?.map((c) => StotraCategory.fromJson(Map<String, dynamic>.from(c)))
              .toList() ??
          [];

      try {
        final svaraStr =
            await rootBundle.loadString('assets/data/svara_mantras.json');
        final svaraData = json.decode(svaraStr) as Map<String, dynamic>;
        _svaraCatalog = SvaraCatalog.fromJson(svaraData);
      } catch (se) {
        debugPrint('⚠️ Warning loading svara mantras: $se');
      }

      _isLoaded = true;
      debugPrint(
          '📚 Loaded $totalStotras stotras in ${allCategories.length} categories ($totalSvaraMantras svara mantras) from local JSON');
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Error loading stotra data: $e');
    }
  }

  Future<String> loadStotraContent(String stotraId) async {
    try {
      return await rootBundle.loadString('assets/data/stotras/$stotraId.txt');
    } catch (e) {
      debugPrint('❌ Error loading stotra content ($stotraId): $e');
      return '';
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
