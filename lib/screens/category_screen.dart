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
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 3),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 18,
                            backgroundColor: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            child: Text(
                              '${index + 1}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                          title: stotra.isUnicode
                              ? Text(
                                  stotra.title,
                                  style: GoogleFonts.notoSansKannada(
                                    fontSize: 16,
                                    height: 1.3,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                )
                              : NudiText(
                                  text: stotra.title,
                                  fontSize: 16,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  height: 1.3,
                                ),
                          trailing: IconButton(
                            icon: Icon(
                              isBookmarked
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              color: isBookmarked ? Colors.red : Colors.grey,
                              size: 22,
                            ),
                            onPressed: () => bookmarks.toggle(stotra.id),
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ReaderScreen(stotra: stotra),
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
