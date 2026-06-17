import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/stotra_service.dart';
import 'services/bookmark_service.dart';
import 'services/veda_service.dart';
import 'services/scripture_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC-Xqs_9z5hWQObGqPVUvo0jmWzQjUuo0k",
        authDomain: "bharatiyam-grantha-sudha.firebaseapp.com",
        projectId: "bharatiyam-grantha-sudha",
        storageBucket: "bharatiyam-grantha-sudha.firebasestorage.app",
        messagingSenderId: "396596689592",
        appId: "1:396596689592:web:e24a32f238b6546432924d",
        measurementId: "G-LS7BG9X2P6",
      ),
    );
    debugPrint('🔥 Firebase initialized successfully');
  } catch (e) {
    debugPrint('⚠️ Firebase initialization failed: $e');
  }

  final stotraService = StotraService();
  final bookmarkService = BookmarkService();
  final vedaService = VedaService();
  final scriptureService = ScriptureService();

  await bookmarkService.init();
  stotraService.init(); // Load async, show loading state
  scriptureService.init(); // Load async

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: stotraService),
        ChangeNotifierProvider.value(value: bookmarkService),
        ChangeNotifierProvider.value(value: vedaService),
        ChangeNotifierProvider.value(value: scriptureService),
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
