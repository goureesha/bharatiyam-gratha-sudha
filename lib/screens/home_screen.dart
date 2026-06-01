import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../data/content_data.dart';
import '../models/shloka.dart';
import '../services/bookmark_service.dart';
import '../services/firebase_service.dart';
import '../theme/app_theme.dart';
import '../widgets/shloka_card.dart';
import '../widgets/category_card.dart';
import '../widgets/book_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ContentData.appName),
        actions: [
          IconButton(
            icon: context.watch<FirebaseService>().isLoading
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.refresh),
            tooltip: 'Refresh from server',
            onPressed: () => context.read<FirebaseService>().refreshData(),
          ),
          IconButton(
            icon: Icon(context.watch<BookmarkService>().isDarkMode
                ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => context.read<BookmarkService>().toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _navigateToSettings(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTab(),
          _SectionTab(sectionId: 'library'),
          _SectionTab(sectionId: 'gods'),
          _SectionTab(sectionId: 'stotras'),
          _SavedTab(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'ಮುಖಪುಟ'),
          const BottomNavigationBarItem(icon: Icon(Icons.library_books), label: 'ಗ್ರಂಥಾಲಯ'),
          const BottomNavigationBarItem(icon: Icon(Icons.temple_hindu), label: 'ಮಂತ್ರಗಳು'),
          const BottomNavigationBarItem(icon: Icon(Icons.auto_stories), label: 'ಸ್ತೋತ್ರಗಳು'),
          BottomNavigationBarItem(
            icon: Badge(
              isLabelVisible: context.watch<BookmarkService>().count > 0,
              label: Text('${context.watch<BookmarkService>().count}'),
              child: const Icon(Icons.favorite),
            ),
            label: 'ಉಳಿಸಿದವು',
          ),
        ],
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => const SettingsPage(),
    ));
  }
}

// ── Home Tab ────────────────────────────────────────────────────
class _HomeTab extends StatefulWidget {
  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Hero Section
        _buildHero(context),
        const SizedBox(height: 16),
        // Search
        _SearchBar(
          hint: 'ಶ್ಲೋಕ, ಪುಸ್ತಕ ಹುಡುಕಿ... Search books, shlokas...',
          onChanged: (q) => setState(() => _searchQuery = q),
        ),
        const SizedBox(height: 16),
        // Search results
        if (_searchQuery.isNotEmpty) ...[
          _buildSearchResults(context),
        ] else ...[
          // Library
          _sectionHeader(context, '📚', 'ಗ್ರಂಥಾಲಯ', 'Library'),
          _categoryGrid(context, 'library'),
          const SizedBox(height: 24),
          // Gods
          _sectionHeader(context, '🙏', 'ಮಂತ್ರಗಳು', 'Mantras'),
          _categoryGrid(context, 'gods'),
          const SizedBox(height: 24),
          // Stotras
          _sectionHeader(context, '📿', 'ಸ್ತೋತ್ರಗಳು', 'Stotras'),
          _categoryGrid(context, 'stotras'),
        ],
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildSearchResults(BuildContext context) {
    final fs = context.read<FirebaseService>();
    final results = fs.searchShlokas(_searchQuery);
    final bookResults = fs.books.where((b) {
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
             b.titleSanskrit.toLowerCase().contains(q) ||
             b.titleEn.toLowerCase().contains(q) ||
             b.description.toLowerCase().contains(q);
    }).toList();

    if (results.isEmpty && bookResults.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(children: [
          const Text('🔍', style: TextStyle(fontSize: 48)),
          const SizedBox(height: 12),
          Text('ಏನೂ ಸಿಗಲಿಲ್ಲ', style: Theme.of(context).textTheme.titleMedium),
          Text('No results found', style: Theme.of(context).textTheme.bodySmall),
        ]),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (bookResults.isNotEmpty) ...[
          Text('📚 ಪುಸ್ತಕಗಳು (${bookResults.length})',
            style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...bookResults.map((b) => BookCard(book: b, onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => BookDetailPage(book: b),
            ));
          })),
          const SizedBox(height: 16),
        ],
        if (results.isNotEmpty) ...[
          Text('📿 ಶ್ಲೋಕಗಳು (${results.length})',
            style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          ...results.take(20).map((s) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: ShlokaCard(shloka: s, showSource: true),
          )),
        ],
      ],
    );
  }

  Widget _buildHero(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppTheme.heroGradient(context),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(
          color: AppTheme.maroon.withOpacity(0.3),
          blurRadius: 20, offset: const Offset(0, 8),
        )],
      ),
      child: Stack(
        children: [
          Positioned(right: -20, top: -20, child: Text('ॐ',
            style: GoogleFonts.notoSansDevanagari(
              fontSize: 120, color: Colors.white.withOpacity(0.06),
            ),
          )),
          Column(
            children: [
              Text(ContentData.appName,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 28, fontWeight: FontWeight.w700,
                  color: AppTheme.goldLight,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text('भारतीयं ग्रन्थ सुधा',
                style: GoogleFonts.notoSansDevanagari(
                  fontSize: 16, color: Colors.white70,
                ),
              ),
              const SizedBox(height: 8),
              Text(ContentData.appTagline,
                style: GoogleFonts.notoSansKannada(
                  fontSize: 12, color: Colors.white54,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(BuildContext ctx, String icon, String title, String en) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(children: [
        Text(icon, style: const TextStyle(fontSize: 20)),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(ctx).textTheme.titleLarge),
        const SizedBox(width: 8),
        Text(en, style: Theme.of(ctx).textTheme.bodySmall),
      ]),
    );
  }

  Widget _categoryGrid(BuildContext context, String sectionId) {
    final fs = context.read<FirebaseService>();
    final section = fs.categories[sectionId] ?? ContentData.categories[sectionId]!;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, childAspectRatio: 0.9,
        crossAxisSpacing: 10, mainAxisSpacing: 10,
      ),
      itemCount: section.subcategories.length,
      itemBuilder: (ctx, i) {
        final sub = section.subcategories[i];
        return CategoryCard(
          subcategory: sub,
          onTap: () => _openSubcategory(context, sectionId, sub),
        );
      },
    );
  }

  void _openSubcategory(BuildContext ctx, String sectionId, SubCategory sub) {
    List<Book> books;
    if (sectionId == 'gods') {
      books = context.read<FirebaseService>().getBooksByGod(sub.id);
    } else {
      books = context.read<FirebaseService>().getBooksBySubcategory(sub.id);
    }
    Navigator.push(ctx, MaterialPageRoute(
      builder: (_) => BookListPage(
        title: sub.title, titleEn: sub.titleEn,
        icon: sub.icon, books: books, sectionId: sectionId,
      ),
    ));
  }
}

// ── Section Tab ─────────────────────────────────────────────────
class _SectionTab extends StatefulWidget {
  final String sectionId;
  const _SectionTab({required this.sectionId});
  @override
  State<_SectionTab> createState() => _SectionTabState();
}

class _SectionTabState extends State<_SectionTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final fs = context.watch<FirebaseService>();
    final section = fs.categories[widget.sectionId] ?? ContentData.categories[widget.sectionId]!;
    final allBooks = fs.getBooksByCategory(widget.sectionId);
    final books = _searchQuery.isEmpty ? allBooks : allBooks.where((b) {
      final q = _searchQuery.toLowerCase();
      return b.title.toLowerCase().contains(q) ||
             b.titleSanskrit.toLowerCase().contains(q) ||
             b.titleEn.toLowerCase().contains(q) ||
             b.description.toLowerCase().contains(q);
    }).toList();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Search
        _SearchBar(
          hint: '${section.title} ಹುಡುಕಿ... Search ${section.titleEn}...',
          onChanged: (q) => setState(() => _searchQuery = q),
        ),
        const SizedBox(height: 16),
        // Subcategories grid
        if (_searchQuery.isEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, childAspectRatio: 0.9,
              crossAxisSpacing: 10, mainAxisSpacing: 10,
            ),
            itemCount: section.subcategories.length,
            itemBuilder: (ctx, i) {
              final sub = section.subcategories[i];
              return CategoryCard(
                subcategory: sub,
                onTap: () {
                  List<Book> subBooks;
                  if (widget.sectionId == 'gods') {
                    subBooks = context.read<FirebaseService>().getBooksByGod(sub.id);
                  } else {
                    subBooks = context.read<FirebaseService>().getBooksBySubcategory(sub.id);
                  }
                  Navigator.push(ctx, MaterialPageRoute(
                    builder: (_) => BookListPage(
                      title: sub.title, titleEn: sub.titleEn,
                      icon: sub.icon, books: subBooks, sectionId: widget.sectionId,
                    ),
                  ));
                },
              );
            },
          ),
        if (books.isNotEmpty) ...[
          const SizedBox(height: 24),
          Text(_searchQuery.isEmpty ? 'ಎಲ್ಲಾ ಪುಸ್ತಕಗಳು' : '${books.length} ಫಲಿತಾಂಶ',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...books.map((b) => BookCard(book: b, onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (_) => BookDetailPage(book: b),
            ));
          })),
        ],
        if (_searchQuery.isNotEmpty && books.isEmpty)
          Padding(
            padding: const EdgeInsets.all(32),
            child: Column(children: [
              const Text('🔍', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 12),
              Text('ಏನೂ ಸಿಗಲಿಲ್ಲ', style: Theme.of(context).textTheme.titleMedium),
            ]),
          ),
        const SizedBox(height: 80),
      ],
    );
  }
}

// ── Saved Tab ───────────────────────────────────────────────────
class _SavedTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saved = context.watch<BookmarkService>().getSavedShlokas();
    if (saved.isEmpty) {
      return Center(child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('💖', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text('ಇನ್ನೂ ಯಾವ ಶ್ಲೋಕವನ್ನೂ ಉಳಿಸಿಲ್ಲ',
            style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text('🤍 ಬಟನ್ ಒತ್ತಿ ಉಳಿಸಿ',
            style: Theme.of(context).textTheme.bodySmall),
        ],
      ));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: saved.length,
      itemBuilder: (ctx, i) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: ShlokaCard(shloka: saved[i], showSource: true),
      ),
    );
  }
}

// ── Book List Page ──────────────────────────────────────────────
class BookListPage extends StatelessWidget {
  final String title, titleEn, icon, sectionId;
  final List<Book> books;
  const BookListPage({super.key, required this.title, required this.titleEn,
    required this.icon, required this.books, required this.sectionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$icon $title')),
      body: books.isEmpty
          ? Center(child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(icon, style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 16),
                Text('ಶೀಘ್ರದಲ್ಲಿ ಬರುತ್ತಿದೆ', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Coming soon!', style: Theme.of(context).textTheme.bodySmall),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: books.length,
              itemBuilder: (ctx, i) => BookCard(
                book: books[i],
                onTap: () => Navigator.push(ctx, MaterialPageRoute(
                  builder: (_) => BookDetailPage(book: books[i]),
                )),
              ),
            ),
    );
  }
}

// ── Book Detail Page ────────────────────────────────────────────
class BookDetailPage extends StatelessWidget {
  final Book book;
  const BookDetailPage({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Book header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppTheme.heroGradient(context),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(book.title, style: GoogleFonts.notoSansKannada(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppTheme.goldLight,
              )),
              Text(book.titleSanskrit, style: GoogleFonts.notoSansDevanagari(
                fontSize: 14, color: Colors.white70,
              )),
              const SizedBox(height: 8),
              Text(book.description, style: GoogleFonts.notoSansKannada(
                fontSize: 12, color: Colors.white54,
              )),
            ]),
          ),
          const SizedBox(height: 24),
          Text('ಅಧ್ಯಾಯಗಳು', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          ...book.chapters.map((ch) => Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: AppTheme.saffron,
                child: Text('${ch.number}', style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.w700,
                )),
              ),
              title: Text(ch.title),
              subtitle: Text('${ch.titleEn} · ${ch.shlokas.length} ಶ್ಲೋಕಗಳು'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.push(context, MaterialPageRoute(
                builder: (_) => ReaderPage(book: book, chapter: ch),
              )),
            ),
          )),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

// ── Reader Page ─────────────────────────────────────────────────
class ReaderPage extends StatefulWidget {
  final Book book;
  final Chapter chapter;
  const ReaderPage({super.key, required this.book, required this.chapter});

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  // 0 = Both, 1 = Sanskrit only, 2 = Kannada only
  int _languageFilter = 0;
  bool _showMeaning = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chapter.title),
        actions: [
          // Meaning toggle
          IconButton(
            icon: Icon(_showMeaning ? Icons.visibility : Icons.visibility_off),
            tooltip: _showMeaning ? 'ಅರ್ಥ ಮರೆಮಾಡಿ' : 'ಅರ್ಥ ತೋರಿಸಿ',
            onPressed: () => setState(() => _showMeaning = !_showMeaning),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Language Filter Bar ──
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1A1028) : const Color(0xFFFFF8EE),
              border: Border(bottom: BorderSide(
                color: isDark ? Colors.white12 : Colors.black12,
              )),
            ),
            child: Row(
              children: [
                const Text('📖 ', style: TextStyle(fontSize: 14)),
                const SizedBox(width: 4),
                Text('ಭಾಷೆ: ', style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                )),
                const SizedBox(width: 8),
                _buildFilterChip('ಎರಡೂ', 0, isDark),
                const SizedBox(width: 6),
                _buildFilterChip('ಸಂಸ್ಕೃತ', 1, isDark),
                const SizedBox(width: 6),
                _buildFilterChip('ಕನ್ನಡ', 2, isDark),
                const Spacer(),
                // Meaning toggle chip
                GestureDetector(
                  onTap: () => setState(() => _showMeaning = !_showMeaning),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: _showMeaning
                          ? AppTheme.textMeaningLight.withOpacity(0.15)
                          : Colors.grey.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _showMeaning
                            ? AppTheme.textMeaningLight.withOpacity(0.5)
                            : Colors.grey.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          _showMeaning ? Icons.visibility : Icons.visibility_off,
                          size: 14,
                          color: _showMeaning ? AppTheme.textMeaningLight : Colors.grey,
                        ),
                        const SizedBox(width: 4),
                        Text('ಅರ್ಥ', style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _showMeaning ? AppTheme.textMeaningLight : Colors.grey,
                        )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Shloka List ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: widget.chapter.shlokas.length,
              itemBuilder: (ctx, i) {
                final shloka = widget.chapter.shlokas[i].copyWith(
                  bookId: widget.book.id, bookTitle: widget.book.title,
                  bookTitleEn: widget.book.titleEn, chapterTitle: widget.chapter.title,
                  category: widget.book.category, subcategory: widget.book.subcategory,
                );
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: ShlokaCard(
                    shloka: shloka,
                    showSanskrit: _languageFilter == 0 || _languageFilter == 1,
                    showKannada: _languageFilter == 0 || _languageFilter == 2,
                    showMeaning: _showMeaning,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, int value, bool isDark) {
    final isSelected = _languageFilter == value;
    return GestureDetector(
      onTap: () => setState(() => _languageFilter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.saffron.withOpacity(0.2)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppTheme.saffron
                : (isDark ? Colors.white24 : Colors.black26),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(label, style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          color: isSelected
              ? AppTheme.saffron
              : Theme.of(context).textTheme.bodyMedium?.color,
        )),
      ),
    );
  }
}

// ── Settings Page ───────────────────────────────────────────────
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = context.watch<BookmarkService>();
    return Scaffold(
      appBar: AppBar(title: const Text('⚙️ ಸೆಟ್ಟಿಂಗ್ಸ್')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance
          Card(child: Column(children: [
            ListTile(
              title: Text('🎨 ನೋಟ', style: Theme.of(context).textTheme.titleLarge),
            ),
            SwitchListTile(
              title: const Text('ಡಾರ್ಕ್ ಮೋಡ್'),
              subtitle: const Text('Dark Mode'),
              value: service.isDarkMode,
              onChanged: (_) => service.toggleTheme(),
              activeColor: AppTheme.saffron,
            ),
            ListTile(
              title: const Text('ಅಕ್ಷರ ಗಾತ್ರ'),
              subtitle: const Text('Font Size'),
              trailing: SegmentedButton<double>(
                segments: const [
                  ButtonSegment(value: 0.85, label: Text('ಸಣ್ಣ')),
                  ButtonSegment(value: 1.0, label: Text('ಮಧ್ಯಮ')),
                  ButtonSegment(value: 1.15, label: Text('ದೊಡ್ಡ')),
                ],
                selected: {service.fontScale},
                onSelectionChanged: (v) => service.setFontScale(v.first),
              ),
            ),
          ])),
          const SizedBox(height: 16),
          // Data
          Card(child: Column(children: [
            ListTile(
              title: Text('💾 ದತ್ತಾಂಶ', style: Theme.of(context).textTheme.titleLarge),
            ),
            ListTile(
              title: const Text('ಉಳಿಸಿದ ಶ್ಲೋಕಗಳು'),
              subtitle: Text('${service.count} shlokas saved'),
            ),
            ListTile(
              title: const Text('ಎಲ್ಲಾ ಬುಕ್‌ಮಾರ್ಕ್ ಅಳಿಸಿ'),
              trailing: const Icon(Icons.delete_outline, color: AppTheme.sacredRed),
              onTap: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('ಖಚಿತವಾಗಿ ಅಳಿಸಬೇಕೆ?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('ಬೇಡ')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('ಹೌದು')),
                    ],
                  ),
                );
                if (confirm == true) service.clearAll();
              },
            ),
          ])),
          const SizedBox(height: 16),
          // About
          Card(child: Column(children: [
            ListTile(
              title: Text('ℹ️ ಕುರಿತು', style: Theme.of(context).textTheme.titleLarge),
            ),
            ListTile(
              title: Text(ContentData.appName),
              subtitle: const Text('Version 1.0.0'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text('सर्वे भवन्तु सुखिनः सर्वे सन्तु निरामयाः',
                style: GoogleFonts.notoSansDevanagari(
                  color: AppTheme.gold, fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ])),
        ],
      ),
    );
  }
}

// ── Reusable Search Bar ─────────────────────────────────────────
class _SearchBar extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.hint, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1028) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.saffron.withOpacity(0.3),
        ),
        boxShadow: [BoxShadow(
          color: AppTheme.saffron.withOpacity(0.08),
          blurRadius: 8, offset: const Offset(0, 2),
        )],
      ),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontSize: 14,
            color: isDark ? Colors.white38 : Colors.black38,
          ),
          prefixIcon: Icon(Icons.search,
            color: AppTheme.saffron.withOpacity(0.7),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14,
          ),
        ),
      ),
    );
  }
}
