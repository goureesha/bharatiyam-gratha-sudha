import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/stotra_service.dart';
import '../services/bookmark_service.dart';
import '../services/scripture_service.dart';
import '../models/stotra.dart';
import 'category_screen.dart';
import 'extras_screen.dart';
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      const _HomeBody(),
      const _LibraryBody(),
      const _MantrasBody(),
      const _StotrasBody(),
      const BookmarksScreen(),
    ];
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'ಮುಖಪುಟ'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book_rounded), label: 'ಗ್ರಂಥಾಲಯ'),
          BottomNavigationBarItem(icon: Icon(Icons.self_improvement_rounded), label: 'ಮಂತ್ರಗಳು'),
          BottomNavigationBarItem(icon: Icon(Icons.music_note_rounded), label: 'ಸ್ತೋತ್ರಗಳು'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_rounded), label: 'ಉಳಿಸಿದವು'),
        ],
      ),
    );
  }
}

// ===================== TAB 1: HOME =====================
class _HomeBody extends StatelessWidget {
  const _HomeBody();

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
              Text('🕉️', style: const TextStyle(fontSize: 60)),
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
                      ? [Theme.of(context).colorScheme.surface, Theme.of(context).colorScheme.primary.withOpacity(0.2)]
                      : [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                ),
              ),
              child: const Center(
                child: Opacity(
                  opacity: 0.12,
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
            IconButton(
              icon: const Icon(Icons.settings_rounded),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen())),
            ),
          ],
        ),

        // Stats bar
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                _StatItem(
                    '${stotraService.mainCategories.length + stotraService.extrasCategories.length + scriptureService.books.length}',
                    'ವಿಭಾಗಗಳು'),
                _StatItem('${stotraService.totalStotras}', 'ಸ್ತೋತ್ರಗಳು'),
                _StatItem('${context.watch<BookmarkService>().count}', 'ಉಳಿಸಿದ'),
              ],
            ),
          ),
        ),

        // Section: Scriptures Header
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text('ಮಹಾ ಗ್ರಂಥಗಳು — Scriptures',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),

        // Scriptures Grid (3 columns)
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
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const VedaBrowserScreen())),
              ),
              _ScriptureGridCard(
                title: 'ಗೀತೆಗಳು',
                icon: '📖',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScripturesListScreen(categoryId: 'gita', categoryTitle: 'ಗೀತೆಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಉಪನಿಷತ್ತುಗಳು',
                icon: '🕉️',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScripturesListScreen(categoryId: 'upanishad', categoryTitle: 'ಉಪನಿಷತ್ತುಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಪುರಾಣಗಳು',
                icon: '🛕',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScripturesListScreen(categoryId: 'purana', categoryTitle: 'ಪುರಾಣಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಸ್ಮೃತಿಗಳು',
                icon: '📜',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScripturesListScreen(categoryId: 'smriti', categoryTitle: 'ಸ್ಮೃತಿಗಳು ಮತ್ತು ನೀತಿಗಳು'))),
              ),
              _ScriptureGridCard(
                title: 'ಚರಿತ್ರೆಗಳು',
                icon: '🔱',
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const ScripturesListScreen(categoryId: 'charitra', categoryTitle: 'ಚರಿತ್ರೆಗಳು ಮತ್ತು ಇತರ ಗ್ರಂಥಗಳು'))),
              ),
            ],
          ),
        ),

        // Section: Deities Header
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
            child: Text('ಸ್ತೋತ್ರಗಳು — Deity Stotras',
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

        const SliverToBoxAdapter(child: SizedBox(height: 30)),
      ],
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
                  color: isDark ? Colors.amber.shade300 : const Color(0xFF8B1A2B),
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

// ===================== TAB 2: LIBRARY (Vedas, Upanishads, Puranas, Smritis, Gitas) =====================
class _LibraryBody extends StatelessWidget {
  const _LibraryBody();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final categories = [
      {'id': 'veda', 'title': 'ವೇದಗಳು', 'titleEn': 'Vedas', 'icon': '🕉️'},
      {'id': 'gita', 'title': 'ಗೀತೆಗಳು', 'titleEn': 'Gitas', 'icon': '📖'},
      {'id': 'upanishad', 'title': 'ಉಪನಿಷತ್ತುಗಳು', 'titleEn': 'Upanishads', 'icon': '🕉️'},
      {'id': 'purana', 'title': 'ಪುರಾಣಗಳು', 'titleEn': 'Puranas', 'icon': '🛕'},
      {'id': 'smriti', 'title': 'ಸ್ಮೃತಿಗಳು ಮತ್ತು ನೀತಿಗಳು', 'titleEn': 'Smritis & Nitis', 'icon': '📜'},
      {'id': 'charitra', 'title': 'ಚರಿತ್ರೆಗಳು ಮತ್ತು ಇತರ ಗ್ರಂಥಗಳು', 'titleEn': 'Charitras & Others', 'icon': '🔱'},
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
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.08),
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
                    MaterialPageRoute(builder: (_) => const VedaBrowserScreen()),
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

// ===================== TAB 3: MANTRAS (Extra categories) =====================
class _MantrasBody extends StatelessWidget {
  const _MantrasBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    if (!stotraService.isLoaded) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('ಮಂತ್ರಗಳು — Mantras')),
      body: ListView.builder(
        itemCount: stotraService.extrasCategories.length,
        itemBuilder: (context, index) {
          final cat = stotraService.extrasCategories[index];
          return ListTile(
            leading: Text(cat.icon, style: const TextStyle(fontSize: 28)),
            title: Text(cat.title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${cat.titleEn} · ${cat.stotras.length} ಸ್ತೋತ್ರಗಳು'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => CategoryScreen(category: cat))),
          );
        },
      ),
    );
  }
}

// ===================== TAB 4: STOTRAS (Deity Grid) =====================
class _StotrasBody extends StatelessWidget {
  const _StotrasBody();

  @override
  Widget build(BuildContext context) {
    final stotraService = context.watch<StotraService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (!stotraService.isLoaded) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      appBar: AppBar(title: const Text('ಸ್ತೋತ್ರಗಳು — Deity Stotras')),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.35,
        ),
        itemCount: stotraService.mainCategories.length,
        itemBuilder: (context, index) {
          final cat = stotraService.mainCategories[index];
          return _DeityCard(category: cat);
        },
      ),
    );
  }
}

// ===================== WIDGETS =====================
class _DeityCard extends StatelessWidget {
  final StotraCategory category;
  const _DeityCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Map category id to asset filename
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
              builder: (_) => CategoryScreen(category: category)),
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
                              ? [const Color(0xFF1E1035), const Color(0xFF120C24)]
                              : [const Color(0xFFFFF8EE), Colors.white],
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
                          Colors.black.withOpacity(0.2),
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.0, 0.4, 1.0],
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          shadows: [
                            const Shadow(
                              blurRadius: 4,
                              color: Colors.black,
                              offset: Offset(0, 1.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${category.stotras.length} ಕೃತಿಗಳು',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFFF5B041),
                        ),
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

class _ExtraCard extends StatelessWidget {
  final StotraCategory category;
  const _ExtraCard({required this.category});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primary = Theme.of(context).colorScheme.primary;

    return Material(
      borderRadius: BorderRadius.circular(14),
      color: isDark ? const Color(0xFF120C24) : Colors.white,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(isDark ? 0.35 : 0.05),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => CategoryScreen(category: category)),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.grey.withOpacity(0.12),
            ),
          ),
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Emoji badge with glowing container
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primary.withOpacity(0.08),
                  border: Border.all(
                    color: primary.withOpacity(0.15),
                  ),
                ),
                child: Text(category.icon, style: const TextStyle(fontSize: 20)),
              ),
              const SizedBox(height: 8),
              Text(
                category.title,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                '${category.stotras.length}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primary,
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
