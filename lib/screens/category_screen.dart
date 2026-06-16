import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';
import '../widgets/nudi_text.dart';
import 'package:google_fonts/google_fonts.dart';
import 'reader_screen.dart';

class CategoryScreen extends StatefulWidget {
  final StotraCategory category;
  const CategoryScreen({super.key, required this.category});
  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String _filter = '';

  List<Stotra> get _filtered {
    if (_filter.isEmpty) return widget.category.stotras;
    final q = _filter.toLowerCase();
    return widget.category.stotras
        .where((s) => s.title.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final stotras = _filtered;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.category.icon} ${widget.category.title}',
                style: const TextStyle(fontSize: 18)),
            Text('${widget.category.stotras.length} ಸ್ತೋತ್ರಗಳು',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal)),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search/filter bar
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ಹುಡುಕಿ...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: isDark ? const Color(0xFF1A1130) : Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (v) => setState(() => _filter = v),
            ),
          ),

          // Stotra list
          Expanded(
            child: stotras.isEmpty
                ? const Center(child: Text('ಯಾವುದೇ ಫಲಿತಾಂಶ ಇಲ್ಲ'))
                : ListView.builder(
                    itemCount: stotras.length,
                    itemBuilder: (context, index) {
                      final stotra = stotras[index];
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
                  ),
          ),
        ],
      ),
    );
  }
}
