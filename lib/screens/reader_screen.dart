import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';

class ReaderScreen extends StatelessWidget {
  final Stotra stotra;
  const ReaderScreen({super.key, required this.stotra});

  String _formatContent(String content) {
    var formatted = content;
    // Replace horizontal space before single/double bar with non-breaking space
    formatted = formatted.replaceAllMapped(
      RegExp(r'[ \t]+(\|\|?)'),
      (match) => '\u00A0${match.group(1)}',
    );
    // Remove numbers inside single/double bars (e.g. || 1 || or || ೧ || becomes ||)
    formatted = formatted.replaceAllMapped(
      RegExp(r'(\|\|?)\s*([0-9\u0ce6-\u0cef]+)\s*(\|\|?)'),
      (match) => '${match.group(1)}',
    );
    return formatted;
  }

  List<Widget> _buildContentBlocks(String content, double fontSize, bool isDark) {
    final blocks = content.split(RegExp(r'\n\s*\n'));
    final List<Widget> widgets = [];

    // Keywords that indicate meaning, word-by-word translation, or notes
    final leftAlignKeywords = [
      'ಅರ್ಥ:', 'ಭಾವಾರ್ಥ:', 'ಶಬ್ದಾರ್ಥ:', 'ಪ್ರತಿಪದಾರ್ಥ:', 'ವಿವರಣೆ:', 'ಟಿಪ್ಪಣಿ:',
      'ಅರ್ಥ', 'ಭಾವಾರ್ಥ', 'ಶಬ್ದಾರ್ಥ', 'ಪ್ರತಿಪದಾರ್ಥ', 'ವಿವರಣೆ', 'ಟಿಪ್ಪಣಿ',
      'meaning:', 'shabdartha:', 'translation:', 'explanation:', 'note:',
      'word-by-word:'
    ];

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i].trim();
      if (block.isEmpty) continue;

      final blockLower = block.toLowerCase();
      
      // Check if the block should be left-aligned
      bool alignLeft = false;
      for (final kw in leftAlignKeywords) {
        if (blockLower.startsWith(kw)) {
          alignLeft = true;
          break;
        }
      }

      // Also left-align if it looks like a list or bullet points
      if (!alignLeft) {
        final firstChar = block.isNotEmpty ? block[0] : '';
        if (firstChar == '-' || firstChar == '*' || firstChar == '•' || RegExp(r'^\d+\.').hasMatch(block)) {
          alignLeft = true;
        }
      }

      widgets.add(
        Padding(
          padding: EdgeInsets.only(bottom: i == blocks.length - 1 ? 0 : 16),
          child: Text(
            block,
            textAlign: alignLeft ? TextAlign.left : TextAlign.center,
            style: GoogleFonts.notoSansKannada(
              fontSize: fontSize,
              height: 1.9,
              letterSpacing: 0.3,
              color: isDark
                  ? (alignLeft ? const Color(0xFFDCD6CD) : const Color(0xFFE8D5B5))
                  : (alignLeft ? const Color(0xFF4A3C2A) : const Color(0xFF2D1B00)),
              fontWeight: alignLeft ? FontWeight.normal : FontWeight.w500,
            ),
          ),
        ),
      );
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isBookmarked = bookmarks.isBookmarked(stotra.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          stotra.title,
          style: GoogleFonts.notoSansKannada(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isBookmarked ? Colors.red : Colors.white,
            ),
            onPressed: () => bookmarks.toggle(stotra.id),
          ),
        ],
      ),
      body: Container(
        color: isDark ? const Color(0xFF0A0516) : const Color(0xFFFFF8EE),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Content card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF120C24) : const Color(0xFFFDFBF7),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.06)
                        : Theme.of(context).colorScheme.primary.withOpacity(0.15),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.35 : 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SelectionArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: _buildContentBlocks(
                      _formatContent(stotra.content),
                      bookmarks.fontSize,
                      isDark,
                    ),
                  ),
                ),
              ),
 
              const SizedBox(height: 24),
 
              // Source info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.04)
                      : Colors.black.withOpacity(0.03),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16,
                        color: Colors.grey.shade500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'ಮೂಲ: ${stotra.categoryTitle}',
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 12,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
 
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'zoomIn',
            onPressed: () => bookmarks.fontSize = bookmarks.fontSize + 2,
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton.small(
            heroTag: 'zoomOut',
            onPressed: () => bookmarks.fontSize = bookmarks.fontSize - 2,
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}
