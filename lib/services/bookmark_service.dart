import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookmarkService extends ChangeNotifier {
  static const _kBookmarks = 'bookmarked_ids';
  static const _kDarkMode = 'dark_mode';
  static const _kFontSize = 'font_size';

  SharedPreferences? _prefs;
  Set<String> _bookmarkedIds = {};
  bool _isDarkMode = false;
  double _fontSize = 20.0;

  Set<String> get bookmarkedIds => _bookmarkedIds;
  bool get isDarkMode => _isDarkMode;
  double get fontSize => _fontSize;
  int get count => _bookmarkedIds.length;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    final saved = _prefs?.getString(_kBookmarks);
    if (saved != null) {
      _bookmarkedIds = Set<String>.from(json.decode(saved));
    }
    _isDarkMode = _prefs?.getBool(_kDarkMode) ?? false;
    _fontSize = _prefs?.getDouble(_kFontSize) ?? 20.0;
    notifyListeners();
  }

  void toggle(String stotraId) {
    if (_bookmarkedIds.contains(stotraId)) {
      _bookmarkedIds.remove(stotraId);
    } else {
      _bookmarkedIds.add(stotraId);
    }
    _save();
    notifyListeners();
  }

  bool isBookmarked(String stotraId) => _bookmarkedIds.contains(stotraId);

  set isDarkMode(bool value) {
    _isDarkMode = value;
    _prefs?.setBool(_kDarkMode, value);
    notifyListeners();
  }

  set fontSize(double value) {
    _fontSize = value.clamp(14.0, 36.0);
    _prefs?.setDouble(_kFontSize, _fontSize);
    notifyListeners();
  }

  void clearAll() {
    _bookmarkedIds.clear();
    _save();
    notifyListeners();
  }

  void _save() {
    _prefs?.setString(_kBookmarks, json.encode(_bookmarkedIds.toList()));
  }
}
