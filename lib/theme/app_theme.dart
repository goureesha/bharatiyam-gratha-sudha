import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Spiritual premium theme for Bharatiyam Gratha Sudha
class AppTheme {
  // ── Colors ──────────────────────────────────────────────────
  static const saffron = Color(0xFFE8722A);
  static const saffronLight = Color(0xFFF09A50);
  static const saffronDeep = Color(0xFFCC5500);
  static const gold = Color(0xFFD4A843);
  static const goldLight = Color(0xFFF0D080);
  static const maroon = Color(0xFF8B1A2B);
  static const sacredRed = Color(0xFFC41E3A);
  static const lotusPink = Color(0xFFE91E63);
  static const templeGreen = Color(0xFF2E7D32);
  static const skyBlue = Color(0xFF1976D2);

  // Light theme text colors
  static const textSanskritLight = Color(0xFF8B1A2B);
  static const textKannadaLight = Color(0xFF1A237E);
  static const textMeaningLight = Color(0xFF33691E);

  // Dark theme text colors
  static const textSanskritDark = Color(0xFFFFB74D);
  static const textKannadaDark = Color(0xFF90CAF9);
  static const textMeaningDark = Color(0xFFA5D6A7);

  // ── Light Theme ─────────────────────────────────────────────
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFFFF8EE),
      colorScheme: const ColorScheme.light(
        primary: saffron,
        secondary: gold,
        tertiary: maroon,
        surface: Color(0xFFFFFFFF),
        onPrimary: Colors.white,
        onSecondary: Color(0xFF2C1810),
        onSurface: Color(0xFF2C1810),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: gold.withOpacity(0.2)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFFFFF8EE).withOpacity(0.95),
        foregroundColor: const Color(0xFF2C1810),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C1810),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFFFFF8EE).withOpacity(0.95),
        selectedItemColor: saffron,
        unselectedItemColor: const Color(0xFF8D6E63),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.notoSansKannada(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 10),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.notoSansKannada(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C1810),
        ),
        headlineMedium: GoogleFonts.notoSansKannada(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFF2C1810),
        ),
        titleLarge: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF2C1810),
        ),
        bodyLarge: GoogleFonts.notoSansKannada(
          fontSize: 16,
          color: const Color(0xFF2C1810),
        ),
        bodyMedium: GoogleFonts.notoSansKannada(
          fontSize: 14,
          color: const Color(0xFF5D4037),
        ),
        bodySmall: GoogleFonts.notoSansKannada(
          fontSize: 12,
          color: const Color(0xFF8D6E63),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: gold.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
      ),
    );
  }

  // ── Dark Theme ──────────────────────────────────────────────
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0F0A1A),
      colorScheme: const ColorScheme.dark(
        primary: saffron,
        secondary: gold,
        tertiary: maroon,
        surface: Color(0xFF1E1530),
        onPrimary: Colors.white,
        onSecondary: Color(0xFFF5E6D3),
        onSurface: Color(0xFFF5E6D3),
      ),
      cardTheme: CardTheme(
        color: const Color(0xFF1E1530),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: gold.withOpacity(0.15)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF0F0A1A).withOpacity(0.95),
        foregroundColor: const Color(0xFFF5E6D3),
        elevation: 0,
        scrolledUnderElevation: 1,
        titleTextStyle: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF5E6D3),
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: const Color(0xFF0F0A1A).withOpacity(0.95),
        selectedItemColor: saffron,
        unselectedItemColor: const Color(0xFF9B8A78),
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.notoSansKannada(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.notoSansKannada(fontSize: 10),
      ),
      textTheme: TextTheme(
        headlineLarge: GoogleFonts.notoSansKannada(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF5E6D3),
        ),
        headlineMedium: GoogleFonts.notoSansKannada(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: const Color(0xFFF5E6D3),
        ),
        titleLarge: GoogleFonts.notoSansKannada(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: const Color(0xFFF5E6D3),
        ),
        bodyLarge: GoogleFonts.notoSansKannada(
          fontSize: 16,
          color: const Color(0xFFF5E6D3),
        ),
        bodyMedium: GoogleFonts.notoSansKannada(
          fontSize: 14,
          color: const Color(0xFFC9B8A8),
        ),
        bodySmall: GoogleFonts.notoSansKannada(
          fontSize: 12,
          color: const Color(0xFF9B8A78),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E1530),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide(color: gold.withOpacity(0.15)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: gold, width: 2),
        ),
      ),
    );
  }

  // ── Helper: Get Sanskrit text style ─────────────────────────
  static TextStyle sanskritStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.notoSansDevanagari(
      fontSize: 20,
      fontWeight: FontWeight.w500,
      color: isDark ? textSanskritDark : textSanskritLight,
      height: 2.0,
    );
  }

  // ── Helper: Get Kannada text style ──────────────────────────
  static TextStyle kannadaStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.notoSansKannada(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: isDark ? textKannadaDark : textKannadaLight,
      height: 2.0,
    );
  }

  // ── Helper: Get Meaning text style ──────────────────────────
  static TextStyle meaningStyle(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.notoSansKannada(
      fontSize: 15,
      color: isDark ? textMeaningDark : textMeaningLight,
      height: 1.8,
    );
  }

  // ── Hero gradient ───────────────────────────────────────────
  static LinearGradient heroGradient(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? const LinearGradient(
            colors: [Color(0xFF1A0A2E), Color(0xFF2D1B4E), Color(0xFF1A1028)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          )
        : const LinearGradient(
            colors: [maroon, saffronDeep, gold],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
  }
}
