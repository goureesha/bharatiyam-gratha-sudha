import 'package:flutter/material.dart';

class AppTheme {
  static const saffron = Color(0xFFE8722A);
  static const gold = Color(0xFFD4A843);
  static const maroon = Color(0xFF8B1A2B);
  static const cream = Color(0xFFFFF8EE);
  static const deepIndigo = Color(0xFF0F0A1A);
  static const darkCard = Color(0xFF1A1130);

  static ThemeData get lightTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
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
    appBarTheme: const AppBarTheme(
      backgroundColor: saffron,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: saffron,
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: saffron,
      foregroundColor: Colors.white,
    ),
  );

  static ThemeData get darkTheme => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
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
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF150F28),
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF150F28),
      selectedItemColor: gold,
      unselectedItemColor: Colors.grey,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: gold,
      foregroundColor: Colors.black,
    ),
  );
}
