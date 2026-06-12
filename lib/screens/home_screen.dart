import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import '../models/stotra.dart';
import 'category_screen.dart';
import 'extras_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      const _HomeBody(),
      const BookmarksScreen(),
      const SettingsScreen(),
    ];
    return Scaffold(
      body: screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'ಮುಖಪುಟ'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'ಉಳಿಸಿದ'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'ಸೆಟ್ಟಿಂಗ್ಸ್'),
        ],
      ),
    );
  }
}

class _HomeBody extends StatelessWidget {
  const _HomeBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!stotraService.isLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('🕉️', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('ಸ್ತೋತ್ರಗಳನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('ಸ್ತೋತ್ರಮಾಲಾ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [const Color(0xFF1A1130), const Color(0xFF2D1B4E)]
                      : [const Color(0xFFE8722A), const Color(0xFFD4A843)],
                ),
              ),
              child: const Center(
                child: Opacity(
                  opacity: 0.15,
                  child: Text('ॐ', style: TextStyle(fontSize: 100, color: Colors.white)),
                ),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search_rounded),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SearchScreen())),
            ),
          ],
        ),

        // Stats bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1130) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem(
                    '${stotraService.mainCategories.length + stotraService.extrasCategories.length}',
                    'ವಿಭಾಗಗಳು'),
                _StatItem('${stotraService.totalStotras}', 'ಸ್ತೋತ್ರಗಳು'),
                _StatItem('${context.watch<BookmarkService>().count}', 'ಉಳಿಸಿದ'),
              ],
            ),
          ),
        ),

        // Section title
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('ದೇವತೆಗಳು',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),

        // Main deity grid
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = stotraService.mainCategories[index];
                return _DeityCard(category: cat);
              },
              childCount: stotraService.mainCategories.length,
            ),
          ),
        ),

        // Extras button
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const ExtrasScreen())),
              icon: const Icon(Icons.apps_rounded),
              label: const Text('ಇನ್ನಷ್ಟು ವಿಭಾಗಗಳು  →',
                  style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

class _DeityCard extends StatelessWidget {
  final StotraCategory category;
  const _DeityCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: isDark ? const Color(0xFF1A1130) : Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CategoryScreen(category: category)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? const Color(0xFFD4A843).withOpacity(0.2)
                  : const Color(0xFFE8722A).withOpacity(0.15),
            ),
          ),
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(category.icon, style: const TextStyle(fontSize: 28)),
              const SizedBox(height: 6),
              Text(
                category.title,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                '${category.stotras.length} ಸ್ತೋತ್ರ',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem(this.value, this.label);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}
