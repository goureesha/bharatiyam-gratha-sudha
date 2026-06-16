import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/stotra_service.dart';
import 'services/bookmark_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final stotraService = StotraService();
  final bookmarkService = BookmarkService();

  await bookmarkService.init();
  stotraService.init(); // Load async, show loading state

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stotraService),
        ChangeNotifierProvider.value(value: bookmarkService),
      ],
      child: const BharatiyamGranthaSudhaApp(),
    ),
  );
}

class BharatiyamGranthaSudhaApp extends StatelessWidget {
  const BharatiyamGranthaSudhaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BookmarkService>(
      builder: (context, bookmarks, _) {
        return MaterialApp(
          title: 'ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme(bookmarks.themeColorIndex),
          darkTheme: AppTheme.darkTheme(bookmarks.themeColorIndex),
          themeMode: bookmarks.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const HomeScreen(),
        );
      },
    );
  }
}
