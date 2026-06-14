import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const saffron = Color(0xFFE8722A);
  static const gold = Color(0xFFD4A843);
  static const maroon = Color(0xFF8B1A2B);
  static const cream = Color(0xFFFFF8EE);
  static const deepIndigo = Color(0xFF0F0A1A);
  static const darkCard = Color(0xFF1A1130);

  /// Modern Kannada text theme using Noto Sans Kannada
  static TextTheme _kannadaTextTheme(TextTheme base) {
    return GoogleFonts.notoSansKannadaTextTheme(base);
  }

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
    );
    return base.copyWith(
      textTheme: _kannadaTextTheme(base.textTheme),
      colorScheme: ColorScheme.light(
        primary: saffron,
        secondary: maroon,
        surface: cream,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1A1A2E),
      ),
      scaffoldBackgroundColor: cream,
      cardColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: saffron,
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: saffron,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 11),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: saffron,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData get darkTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    return base.copyWith(
      textTheme: _kannadaTextTheme(base.textTheme),
      colorScheme: ColorScheme.dark(
        primary: saffron,
        secondary: gold,
        surface: deepIndigo,
        onPrimary: Colors.white,
        onSecondary: Colors.black,
        onSurface: Colors.white,
      ),
      scaffoldBackgroundColor: deepIndigo,
      cardColor: darkCard,
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF150F28),
        foregroundColor: Colors.white,
        elevation: 0,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF150F28),
        selectedItemColor: gold,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 12, fontWeight: FontWeight.w500),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 11),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: gold,
        foregroundColor: Colors.black,
      ),
    );
  }
}
