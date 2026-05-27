import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/bookmark_service.dart';
import 'services/firebase_service.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  try {
    await Firebase.initializeApp();
    debugPrint('🔥 Firebase Core initialized');
  } catch (e) {
    debugPrint('⚠️ Firebase init error (app will use bundled data): $e');
  }

  // Initialize FirebaseService (Firestore content)
  final firebaseService = FirebaseService();
  await firebaseService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BookmarkService()..init()),
        ChangeNotifierProvider.value(value: firebaseService),
      ],
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
