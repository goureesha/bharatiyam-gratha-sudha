import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/bookmark_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => BookmarkService()..init(),
      child: const BharatiyamApp(),
    ),
  );
}

class BharatiyamApp extends StatelessWidget {
  const BharatiyamApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkService>(
      builder: (context, bookmarkService, _) {
        return MaterialApp(
          title: 'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: bookmarkService.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
