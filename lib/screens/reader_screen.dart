import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';
import '../widgets/nudi_text.dart';

class ReaderScreen extends StatelessWidget {
  final Stotra stotra;
  const ReaderScreen({super.key, required this.stotra});

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isBookmarked = bookmarks.isBookmarked(stotra.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fontFamily = stotra.font == 'brhknde' ? 'Brhknde' : 'Brhknd';
    final isVedic = stotra.font == 'brhknde';

    return Scaffold(
      appBar: AppBar(
        // App bar title uses modern Noto Sans Kannada (via theme)
        title: NudiText(
          text: stotra.title,
          fontSize: 16,
          color: Colors.white,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          height: 1.3,
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
        color: isDark ? const Color(0xFF0F0A1A) : const Color(0xFFFFF8EE),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Vedic indicator badge
              if (isVedic)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF2D1B4E)
                        : const Color(0xFFE8722A).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFFE8722A).withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.auto_awesome, size: 16,
                          color: Color(0xFFE8722A)),
                      const SizedBox(width: 8),
                      Text(
                        'ವೇದ ಮಂತ್ರ · Vedic Mantra (with svaras)',
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 13,
                          color: const Color(0xFFE8722A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

              // Content card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A1130) : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: NudiText(
                  text: stotra.content,
                  fontFamily: fontFamily,
                  fontSize: bookmarks.fontSize,
                  height: isVedic ? 2.4 : 1.9,
                  letterSpacing: isVedic ? 0.5 : 0.3,
                  color: isDark
                      ? const Color(0xFFE8D5B5)
                      : const Color(0xFF2D1B00),
                ),
              ),

              const SizedBox(height: 24),

              // Source info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.05)
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
                        'ಮೂಲ: ${stotra.source}',
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
