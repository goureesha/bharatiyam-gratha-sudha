import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const List<Map<String, Color>> themes = [
    // Theme 0: Saffron / Sandalwood (Default Spiritual)
    {
      'primary': Color(0xFFE8722A),
      'secondary': Color(0xFF8B1A2B),
      'background': Color(0xFFFFF8EE),
      'card': Colors.white,
      'darkBackground': Color(0xFF0A0516),
      'darkCard': Color(0xFF120C24),
      'darkPrimary': Color(0xFFE8722A),
      'darkSecondary': Color(0xFFF5B041),
    },
    // Theme 1: Devotional Maroon / Red
    {
      'primary': Color(0xFF8B1A2B),
      'secondary': Color(0xFFE8722A),
      'background': Color(0xFFFFF5F5),
      'card': Colors.white,
      'darkBackground': Color(0xFF150A0F),
      'darkCard': Color(0xFF221118),
      'darkPrimary': Color(0xFFE05263),
      'darkSecondary': Color(0xFFF5B041),
    },
    // Theme 2: Peacock Blue / Krishna Blue
    {
      'primary': Color(0xFF0A6E90),
      'secondary': Color(0xFFD4A843),
      'background': Color(0xFFF0F7FA),
      'card': Colors.white,
      'darkBackground': Color(0xFF050E17),
      'darkCard': Color(0xFF0D1B2A),
      'darkPrimary': Color(0xFF12A4D9),
      'darkSecondary': Color(0xFFF5B041),
    },
    // Theme 3: Forest Green / Tulsi Green
    {
      'primary': Color(0xFF1E5C3F),
      'secondary': Color(0xFFD4A843),
      'background': Color(0xFFF3FAF6),
      'card': Colors.white,
      'darkBackground': Color(0xFF05120B),
      'darkCard': Color(0xFF0E2217),
      'darkPrimary': Color(0xFF2EA268),
      'darkSecondary': Color(0xFFF5B041),
    },
  ];

  static TextTheme _kannadaTextTheme(TextTheme base) {
    return GoogleFonts.notoSansKannadaTextTheme(base);
  }

  static ThemeData lightTheme(int themeIndex) {
    final idx = themeIndex.clamp(0, themes.length - 1);
    final themeColors = themes[idx];

    final primary = themeColors['primary']!;
    final secondary = themeColors['secondary']!;
    final background = themeColors['background']!;
    final cardColor = themeColors['card']!;

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );

    return base.copyWith(
      textTheme: _kannadaTextTheme(base.textTheme),
      colorScheme: ColorScheme.light(
        primary: primary,
        secondary: secondary,
        surface: background,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: background,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: primary,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 11),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(int themeIndex) {
    final idx = themeIndex.clamp(0, themes.length - 1);
    final themeColors = themes[idx];

    final primary = themeColors['darkPrimary']!;
    final secondary = themeColors['darkSecondary']!;
    final background = themeColors['darkBackground']!;
    final cardColor = themeColors['darkCard']!;

    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );

    return base.copyWith(
      textTheme: _kannadaTextTheme(base.textTheme),
      colorScheme: ColorScheme.dark(
        primary: primary,
        secondary: secondary,
        surface: background,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: background,
      cardColor: cardColor,
      appBarTheme: AppBarTheme(
        backgroundColor: Color.alphaBlend(Colors.black.withOpacity(0.2), cardColor),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: cardColor,
        selectedItemColor: secondary,
        unselectedItemColor: Colors.grey.shade500,
        selectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.bold),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 11),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: secondary,
        foregroundColor: Colors.black,
      ),
    );
  }
}
