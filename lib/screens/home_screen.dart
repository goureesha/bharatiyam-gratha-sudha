import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import '../services/scripture_service.dart';
import '../models/stotra.dart';
import 'category_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';
import 'search_screen.dart';
import 'veda_browser_screen.dart';
import 'scriptures_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _switchTab(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final screens = [
      _HomeBody(onSwitchTab: _switchTab),
      const _LibraryBody(),
      const _StotrasBody(),
      const _MantrasBody(),
      const _BhajanasBody(),
      const BookmarksScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _switchTab,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 11,
        unselectedFontSize: 10,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded), label: 'ಮುಖಪುಟ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book_rounded), label: 'ಗ್ರಂಥಾಲಯ'),
          BottomNavigationBarItem(
              icon: Icon(Icons.auto_stories_rounded), label: 'ಶ್ಲೋಕಗಳು'),
          BottomNavigationBarItem(
              icon: Icon(Icons.self_improvement_rounded), label: 'ಮಂತ್ರಗಳು'),
          BottomNavigationBarItem(
              icon: Icon(Icons.music_note_rounded), label: 'ಭಜನೆಗಳು'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite_rounded), label: 'ಉಳಿಸಿದವು'),
        ],
      ),
    );
  }
}

// ===================== TAB 1: HOME =====================
class _HomeBody extends StatelessWidget {
  final ValueChanged<int> onSwitchTab;
  const _HomeBody({required this.onSwitchTab});

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final scriptureService = context.watch<ScriptureService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!stotraService.isLoaded || !scriptureService.isLoaded) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🕉️', style: TextStyle(fontSize: 60)),
              const SizedBox(height: 20),
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text('ಗ್ರಂಥಾಲಯವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗುತ್ತಿದೆ...',
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
    }

    final bhajanaCategories = stotraService.categoriesWithBhajanas;
    final mantraCategories = stotraService.categoriesWithMantras;

    return CustomScrollView(
      slivers: [
        // AppBar
        SliverAppBar(
          expandedHeight: 140,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text('ಭಾರತೀಯಂ ಗ್ರಂಥ ಸುಧಾ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            background: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: isDark
                      ? [
                          Theme.of(context).colorScheme.surface,
                          Theme.of(context).colorScheme.primary.withOpacity(0.2)
                        ]
                      : [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.secondary
                        ],
                ),
              ),
              child: const Center(
                child: Opacity(
                  opacity: 0.12,
                  child: Text('ॐ',
                      style: TextStyle(fontSize: 100, color: Colors.white)),
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
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
        ),

        // Stats bar (Shlokas, Mantras, Bhajanas, Bookmarks)
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF120C24) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _StatItem('${stotraService.totalShlokas}', 'ಶ್ಲೋಕಗಳು'),
                _StatItem('${stotraService.totalMantras}', 'ಮಂತ್ರಗಳು'),
                _StatItem('${stotraService.totalBhajanas}', 'ಭಜನೆಗಳು'),
                _StatItem(
                    '${context.watch<BookmarkService>().count}', 'ಉಳಿಸಿದ'),
              ],
            ),
          ),
        ),

        // Section 1: Scriptures Header (UNTOUCHED)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('ಮಹಾ ಗ್ರಂಥಗಳು — Scriptures',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),

        // Scriptures Grid (3 columns — UNTOUCHED)
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverGrid.count(
            crossAxisCount: 3,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 1.05,
            children: [
              _ScriptureGridCard(
                title: 'ವೇದಗಳು',
                icon: '🕉️',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const VedaBrowserScreen())),
              ),
              _ScriptureGridCard(
                title: 'ಗೀತೆಗಳು',
                icon: '📖',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScripturesListScreen(
                            categoryId: 'gita', categoryTitle: 'ಗೀತೆಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಉಪನಿಷತ್ತುಗಳು',
                icon: '🕉️',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScripturesListScreen(
                            categoryId: 'upanishad',
                            categoryTitle: 'ಉಪನಿಷತ್ತುಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಪುರಾಣಗಳು',
                icon: '🛕',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScripturesListScreen(
                            categoryId: 'purana', categoryTitle: 'ಪುರಾಣಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಸ್ಮೃತಿಗಳು',
                icon: '📜',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScripturesListScreen(
                            categoryId: 'smriti',
                            categoryTitle: 'ಸ್ಮೃತಿಗಳು ಮತ್ತು ನೀತಿಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಗ್ರಂಥಗಳು',
                icon: '📚',
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ScripturesListScreen(
                            categoryId: 'grantha',
                            categoryTitle: 'ಗ್ರಂಥಗಳು — Granthas'))),
              ),
            ],
          ),
        ),

        // Section 2: NEW BHAJANA SECTION ON HOME PAGE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'ಭಜನೆಗಳು — Bhajanas (ದೇವತಾನುಸಾರ)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => onSwitchTab(4),
                  icon: const Icon(Icons.music_note_rounded, size: 16),
                  label: const Text('ಎಲ್ಲಾ ನೋಡಿ'),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 118,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: bhajanaCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cat = bhajanaCategories[index];
                return _QuickDeityTypeCard(
                  category: cat,
                  count: cat.bhajanas.length,
                  unitLabel: 'ಭಜನೆಗಳು',
                  tabIndex: 2,
                  accentColor: const Color(0xFFD84315),
                );
              },
            ),
          ),
        ),

        // Section 3: MANTRAS SECTION ON HOME PAGE
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Text(
                    'ಮಂತ್ರಗಳು ಮತ್ತು ಪೂಜೆ — Mantras',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => onSwitchTab(3),
                  icon: const Icon(Icons.self_improvement_rounded, size: 16),
                  label: const Text('ಎಲ್ಲಾ ನೋಡಿ'),
                ),
              ],
            ),
          ),
        ),

        SliverToBoxAdapter(
          child: SizedBox(
            height: 118,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: mantraCategories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final cat = mantraCategories[index];
                return _QuickDeityTypeCard(
                  category: cat,
                  count: cat.mantras.length,
                  unitLabel: 'ಮಂತ್ರಗಳು',
                  tabIndex: 1,
                  accentColor: const Color(0xFF6A1B9A),
                );
              },
            ),
          ),
        ),

        // Section 4: Deities Header (Shlokas, Mantras & Bhajanas)
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text(
              'ದೇವತಾ ವಿಭಾಗಗಳು — ಶ್ಲೋಕ · ಮಂತ್ರ · ಭಜನೆ',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
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
              childAspectRatio: 1.42,
            ),
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final cat = stotraService.mainCategories[index];
                return _DeityCard(
                  category: cat,
                  initialTabIndex: 0,
                );
              },
              childCount: stotraService.mainCategories.length,
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
    );
  }
}

class _QuickDeityTypeCard extends StatelessWidget {
  final StotraCategory category;
  final int count;
  final String unitLabel;
  final int tabIndex;
  final Color accentColor;

  const _QuickDeityTypeCard({
    required this.category,
    required this.count,
    required this.unitLabel,
    required this.tabIndex,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: isDark ? const Color(0xFF1A1130) : Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(isDark ? 0.35 : 0.06),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(
              category: category,
              initialTabIndex: tabIndex,
            ),
          ),
        ),
        child: Container(
          width: 126,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.08)
                  : accentColor.withOpacity(0.18),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor.withOpacity(0.12),
                ),
                child:
                    Text(category.icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 6),
              Text(
                category.title,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 3),
              Text(
                '$count $unitLabel',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? const Color(0xFFF5B041) : accentColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ScriptureGridCard extends StatelessWidget {
  final String title;
  final String icon;
  final VoidCallback onTap;

  const _ScriptureGridCard({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: isDark ? const Color(0xFF1E1035) : const Color(0xFFFFF3EC),
      elevation: 2,
      shadowColor: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : const Color(0xFFE8722A).withOpacity(0.12),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(icon, style: const TextStyle(fontSize: 26)),
              const SizedBox(height: 8),
              Text(
                title,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color:
                      isDark ? Colors.amber.shade300 : const Color(0xFF8B1A2B),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===================== TAB 2: LIBRARY (Vedas, Upanishads, Puranas, Smritis, Gitas — UNTOUCHED) =====================
class _LibraryBody extends StatelessWidget {
  const _LibraryBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {'id': 'veda', 'title': 'ವೇದಗಳು', 'titleEn': 'Vedas', 'icon': '🕉️'},
      {'id': 'gita', 'title': 'ಗೀತೆಗಳು', 'titleEn': 'Gitas', 'icon': '📖'},
      {
        'id': 'upanishad',
        'title': 'ಉಪನಿಷತ್ತುಗಳು',
        'titleEn': 'Upanishads',
        'icon': '🕉️'
      },
      {'id': 'purana', 'title': 'ಪುರಾಣಗಳು', 'titleEn': 'Puranas', 'icon': '🛕'},
      {
        'id': 'smriti',
        'title': 'ಸ್ಮೃತಿಗಳು ಮತ್ತು ನೀತಿಗಳು',
        'titleEn': 'Smritis & Nitis',
        'icon': '📜'
      },
      {
        'id': 'grantha',
        'title': 'ಗ್ರಂಥಗಳು',
        'titleEn': 'Granthas',
        'icon': '📚'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('ಗ್ರಂಥಾಲಯ — Library')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF120C24) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.06)
                    : Colors.grey.withOpacity(0.12),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color:
                      Theme.of(context).colorScheme.primary.withOpacity(0.08),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  cat['icon']!,
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              title: Text(
                cat['title']!,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                cat['titleEn']!,
                style: TextStyle(
                  fontSize: 12,
                  color: isDark ? Colors.white60 : Colors.grey.shade600,
                ),
              ),
              trailing: Icon(
                Icons.chevron_right_rounded,
                color: Theme.of(context).colorScheme.primary,
              ),
              onTap: () {
                if (cat['id'] == 'veda') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const VedaBrowserScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ScripturesListScreen(
                        categoryId: cat['id']!,
                        categoryTitle: cat['title']!,
                      ),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}

// ===================== TAB 3: SHLOKAS (Deity Grid -> Tab 0) =====================
class _StotrasBody extends StatelessWidget {
  const _StotrasBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    if (!stotraService.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = stotraService.categoriesWithShlokas;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ದೇವತಾ ಶ್ಲೋಕಗಳು — Shlokas & Stotras',
                style: TextStyle(fontSize: 18)),
            Text('ಒಟ್ಟು ${stotraService.totalShlokas} ಶ್ಲೋಕಗಳು',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.38,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _DeityCard(
            category: cat,
            initialTabIndex: 0,
            subtitleOverride: '${cat.shlokas.length} ಶ್ಲೋಕಗಳು',
          );
        },
      ),
    );
  }
}

// ===================== TAB 4: MANTRAS (Deity Grid -> Tab 1) =====================
class _MantrasBody extends StatelessWidget {
  const _MantrasBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    if (!stotraService.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = stotraService.categoriesWithMantras;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ದೇವತಾ ಮಂತ್ರಗಳು ಮತ್ತು ಪೂಜೆ — Mantras',
                style: TextStyle(fontSize: 18)),
            Text('ಒಟ್ಟು ${stotraService.totalMantras} ಮಂತ್ರಗಳು ಮತ್ತು ವ್ರತಗಳು',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.38,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _DeityCard(
            category: cat,
            initialTabIndex: 1,
            subtitleOverride: '${cat.mantras.length} ಮಂತ್ರಗಳು',
          );
        },
      ),
    );
  }
}

// ===================== TAB 5: BHAJANAS (Deity Grid -> Tab 2) =====================
class _BhajanasBody extends StatelessWidget {
  const _BhajanasBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    if (!stotraService.isLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    final categories = stotraService.categoriesWithBhajanas;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ದೇವತಾ ಭಜನೆಗಳು — Bhajanas & Kirtanas',
                style: TextStyle(fontSize: 18)),
            Text('ಒಟ್ಟು ${stotraService.totalBhajanas} ಭಜನೆಗಳು ಮತ್ತು ದೇವರನಾಮಗಳು',
                style: const TextStyle(
                    fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.38,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cat = categories[index];
          return _DeityCard(
            category: cat,
            initialTabIndex: 2,
            subtitleOverride: '${cat.bhajanas.length} ಭಜನೆಗಳು',
          );
        },
      ),
    );
  }
}

// ===================== WIDGETS =====================
class _DeityCard extends StatelessWidget {
  final StotraCategory category;
  final int initialTabIndex;
  final String? subtitleOverride;

  const _DeityCard({
    required this.category,
    this.initialTabIndex = 0,
    this.subtitleOverride,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String imagePath;
    switch (category.id) {
      case 'shiva':
        imagePath = 'assets/images/shiva.png';
        break;
      case 'vishnu':
        imagePath = 'assets/images/vishnu.png';
        break;
      case 'devi':
        imagePath = 'assets/images/devi.png';
        break;
      case 'ganapati':
        imagePath = 'assets/images/ganesha.png';
        break;
      case 'hanumanta':
        imagePath = 'assets/images/hanuman.png';
        break;
      case 'krishna':
        imagePath = 'assets/images/krishna.png';
        break;
      case 'rama':
        imagePath = 'assets/images/rama.png';
        break;
      case 'surya':
        imagePath = 'assets/images/surya.png';
        break;
      case 'narasimha':
        imagePath = 'assets/images/narasimha.png';
        break;
      default:
        imagePath = '';
    }

    final subtitleText = subtitleOverride ??
        'ಶ್ಲೋಕ ${category.shlokas.length} · ಮಂತ್ರ ${category.mantras.length} · ಭಜನೆ ${category.bhajanas.length}';

    return Material(
      borderRadius: BorderRadius.circular(16),
      color: isDark ? const Color(0xFF120C24) : Colors.white,
      elevation: 3,
      shadowColor: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryScreen(
              category: category,
              initialTabIndex: initialTabIndex,
            ),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.grey.withOpacity(0.12),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Stack(
              children: [
                // Illustration or fallback background gradient
                if (imagePath.isNotEmpty)
                  Positioned.fill(
                    child: Opacity(
                      opacity: isDark ? 0.75 : 0.95,
                      child: Image.asset(
                        imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                else
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: isDark
                              ? [
                                  const Color(0xFF281545),
                                  const Color(0xFF120C24)
                                ]
                              : [
                                  const Color(0xFF5D1926),
                                  const Color(0xFF8B2635)
                                ],
                        ),
                      ),
                    ),
                  ),

                // Dark overlay at the bottom for text readability
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.0),
                          Colors.black.withOpacity(0.25),
                          Colors.black.withOpacity(0.78),
                        ],
                        stops: const [0.0, 0.38, 1.0],
                      ),
                    ),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Circular emoji icon
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.3),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: Text(
                          category.icon,
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        category.title,
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: const [
                            Shadow(
                              blurRadius: 4,
                              color: Colors.black,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitleText,
                        style: const TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFF5B041),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
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
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary)),
        Text(label, style: const TextStyle(fontSize: 11.5)),
      ],
    );
  }
}
