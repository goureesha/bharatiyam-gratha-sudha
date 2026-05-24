import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shloka.dart';

/// Manages bookmark persistence using SharedPreferences
class BookmarkService extends ChangeNotifier {
  static const _storageKey = 'bharatiyam_bookmarks';
  static const _themeKey = 'bharatiyam_theme';
  static const _fontSizeKey = 'bharatiyam_font_size';

  Map<String, Map<String, dynamic>> _bookmarks = {};
  bool _isDarkMode = false;
  double _fontScale = 1.0; // 0.85 = small, 1.0 = medium, 1.15 = large

  Map<String, Map<String, dynamic>> get bookmarks => _bookmarks;
  bool get isDarkMode => _isDarkMode;
  double get fontScale => _fontScale;
  int get count => _bookmarks.length;

  /// Initialize: load saved data
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    // Load bookmarks
    final data = prefs.getString(_storageKey);
    if (data != null) {
      try {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        _bookmarks = decoded.map(
          (key, value) => MapEntry(key, Map<String, dynamic>.from(value)),
        );
      } catch (e) {
        _bookmarks = {};
      }
    }

    // Load theme
    _isDarkMode = prefs.getBool(_themeKey) ?? false;

    // Load font size
    _fontScale = prefs.getDouble(_fontSizeKey) ?? 1.0;

    notifyListeners();
  }

  // ── Bookmark Operations ─────────────────────────────────────

  bool isBookmarked(String shlokaId) => _bookmarks.containsKey(shlokaId);

  Future<bool> toggle(String shlokaId, Shloka shloka) async {
    if (_bookmarks.containsKey(shlokaId)) {
      _bookmarks.remove(shlokaId);
    } else {
      _bookmarks[shlokaId] = {
        ...shloka.toJson(),
        'savedAt': DateTime.now().toIso8601String(),
      };
    }
    await _save();
    notifyListeners();
    return _bookmarks.containsKey(shlokaId);
  }

  List<Shloka> getSavedShlokas() {
    final entries = _bookmarks.entries.toList()
      ..sort((a, b) {
        final aTime = a.value['savedAt'] ?? '';
        final bTime = b.value['savedAt'] ?? '';
        return bTime.compareTo(aTime);
      });
    return entries.map((e) => Shloka.fromJson(e.value)).toList();
  }

  Future<void> clearAll() async {
    _bookmarks.clear();
    await _save();
    notifyListeners();
  }

  String exportAsJson() => const JsonEncoder.withIndent('  ').convert(_bookmarks);

  // ── Theme ───────────────────────────────────────────────────

  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, _isDarkMode);
    notifyListeners();
  }

  // ── Font Size ───────────────────────────────────────────────

  Future<void> setFontScale(double scale) async {
    _fontScale = scale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_fontSizeKey, _fontScale);
    notifyListeners();
  }

  // ── Private ─────────────────────────────────────────────────

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_bookmarks));
  }
}
