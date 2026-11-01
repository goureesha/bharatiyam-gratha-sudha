import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';
import '../widgets/nudi_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reader_screen.dart';

class CategoryScreen extends StatefulWidget {
  final StotraCategory category;
  final int initialTabIndex; // 0 = ಶ್ಲೋಕಗಳು, 1 = ಮಂತ್ರಗಳು, 2 = ಭಜನೆಗಳು

  const CategoryScreen({
    super.key,
    required this.category,
    this.initialTabIndex = 0,
  });

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _filter = '';

  List<Stotra> _filterList(List<Stotra> source) {
    if (_filter.isEmpty) return source;
    final q = _filter.toLowerCase();
    return source.where((s) => s.title.toLowerCase().contains(q)).toList();
  }

  Widget _buildStotraList(
    BuildContext context,
    List<Stotra> items,
    BookmarkService bookmarks,
    bool isDark,
    String emptyLabel,
  ) {
    final filtered = _filterList(items);
    if (filtered.isEmpty) {
      return Center(
        child: Text(
          _filter.isEmpty ? emptyLabel : 'ಯಾವುದೇ ಫಲಿತಾಂಶ ಇಲ್ಲ',
          style: GoogleFonts.notoSansKannada(fontSize: 15, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final stotra = filtered[index];
        final isBookmarked = bookmarks.isBookmarked(stotra.id);
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF120C24) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark
                  ? Colors.white.withOpacity(0.06)
                  : Colors.grey.withOpacity(0.12),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(isDark ? 0.2 : 0.02),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReaderScreen(stotra: stotra),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: [
                    // Left accent bar
                    Container(
                      width: 4,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 12),
                    // Circular index
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.08),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: stotra.isUnicode
                            ? Text(
                                stotra.title,
                                style: GoogleFonts.notoSansKannada(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              )
                            : NudiText(
                                text: stotra.title,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                height: 1.3,
                              ),
                      ),
                    ),
                    // Bookmark
                    IconButton(
                      icon: Icon(
                        isBookmarked
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: isBookmarked ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                      onPressed: () => bookmarks.toggle(stotra.id),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'ಹುಡುಕಿ (ಶ್ಲೋಕ / ಮಂತ್ರ / ಭಜನೆ)...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: isDark ? const Color(0xFF1A1130) : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (v) => setState(() => _filter = v),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cat = widget.category;

    // For Scripture books (like Narayaneeyam, Uddhava Gita, etc.) show single list
    if (!cat.hasSubTypes) {
      return Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${cat.icon} ${cat.title}',
                  style: const TextStyle(fontSize: 18)),
              Text('${cat.stotras.length} ಅಧ್ಯಾಯಗಳು / ಕೃತಿಗಳು',
                  style: const TextStyle(
                      fontSize: 12, fontWeight: FontWeight.normal)),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(isDark),
            Expanded(
              child: _buildStotraList(
                context,
                cat.stotras,
                bookmarks,
                isDark,
                'ಯಾವುದೇ ಕೃತಿಗಳಿಲ್ಲ',
              ),
            ),
          ],
        ),
      );
    }

    final shlokas = cat.shlokas;
    final mantras = cat.mantras;
    final bhajanas = cat.bhajanas;

    return DefaultTabController(
      length: 3,
      initialIndex: widget.initialTabIndex.clamp(0, 2),
      child: Scaffold(
        appBar: AppBar(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${cat.icon} ${cat.title}',
                  style: const TextStyle(fontSize: 18)),
              Text(
                'ಒಟ್ಟು ${cat.stotras.length} ಕೃತಿಗಳು (ಶ್ಲೋಕ ${shlokas.length} · ಮಂತ್ರ ${mantras.length} · ಭಜನೆ ${bhajanas.length})',
                style: const TextStyle(
                    fontSize: 11, fontWeight: FontWeight.normal),
              ),
            ],
          ),
          bottom: TabBar(
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: const Color(0xFFF5B041),
            indicatorWeight: 3,
            labelStyle: GoogleFonts.notoSansKannada(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            unselectedLabelStyle: GoogleFonts.notoSansKannada(
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            tabs: [
              Tab(text: 'ಶ್ಲೋಕಗಳು (${shlokas.length})'),
              Tab(text: 'ಮಂತ್ರಗಳು (${mantras.length})'),
              Tab(text: 'ಭಜನೆಗಳು (${bhajanas.length})'),
            ],
          ),
        ),
        body: Column(
          children: [
            _buildSearchBar(isDark),
            Expanded(
              child: TabBarView(
                children: [
                  _buildStotraList(
                    context,
                    shlokas,
                    bookmarks,
                    isDark,
                    'ಯಾವುದೇ ಶ್ಲೋಕಗಳಿಲ್ಲ',
                  ),
                  _buildStotraList(
                    context,
                    mantras,
                    bookmarks,
                    isDark,
                    'ಯಾವುದೇ ಮಂತ್ರಗಳಿಲ್ಲ',
                  ),
                  _buildStotraList(
                    context,
                    bhajanas,
                    bookmarks,
                    isDark,
                    'ಯಾವುದೇ ಭಜನೆಗಳಿಲ್ಲ',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
