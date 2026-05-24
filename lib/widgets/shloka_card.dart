import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/shloka.dart';
import '../services/bookmark_service.dart';
import '../theme/app_theme.dart';

/// Displays a single shloka with Sanskrit, Kannada, meaning, and explanation
class ShlokaCard extends StatefulWidget {
  final Shloka shloka;
  final bool showSource;

  const ShlokaCard({super.key, required this.shloka, this.showSource = false});

  @override
  State<ShlokaCard> createState() => _ShlokaCardState();
}

class _ShlokaCardState extends State<ShlokaCard> {
  bool _explanationExpanded = true;

  @override
  Widget build(BuildContext context) {
    final service = context.watch<BookmarkService>();
    final isBookmarked = service.isBookmarked(widget.shloka.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final scale = service.fontScale;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: isDark ? const Color(0xFF1A1028) : const Color(0xFFFFF3E0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.saffron.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('श्लोक ${widget.shloka.number}',
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 12, fontWeight: FontWeight.w600,
                      color: AppTheme.saffron,
                    ),
                  ),
                ),
                if (widget.showSource && widget.shloka.bookTitle != null) ...[
                  const SizedBox(width: 8),
                  Expanded(child: Text(
                    '${widget.shloka.bookTitle ?? ""} ${widget.shloka.chapterTitle != null ? "• ${widget.shloka.chapterTitle}" : ""}',
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  )),
                ] else
                  const Spacer(),
                IconButton(
                  icon: Icon(
                    isBookmarked ? Icons.favorite : Icons.favorite_border,
                    color: isBookmarked ? AppTheme.lotusPink : null,
                  ),
                  onPressed: () {
                    service.toggle(widget.shloka.id, widget.shloka);
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(isBookmarked
                          ? '💔 ಶ್ಲೋಕ ತೆಗೆದುಹಾಕಲಾಗಿದೆ'
                          : '❤️ ಶ್ಲೋಕ ಉಳಿಸಲಾಗಿದೆ'),
                      duration: const Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    ));
                  },
                ),
              ],
            ),
          ),

          // ── Sanskrit ────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('📜 ', style: TextStyle(fontSize: 12)),
                  Text('ಸಂಸ್ಕೃತ · Sanskrit',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.textSanskritDark : AppTheme.textSanskritLight,
                      letterSpacing: 1,
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.textSanskritDark : AppTheme.textSanskritLight)
                        .withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? AppTheme.textSanskritDark : AppTheme.textSanskritLight)
                          .withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    widget.shloka.sanskrit,
                    style: GoogleFonts.notoSansDevanagari(
                      fontSize: 20 * scale,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppTheme.textSanskritDark : AppTheme.textSanskritLight,
                      height: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Kannada ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('📝 ', style: TextStyle(fontSize: 12)),
                  Text('ಕನ್ನಡ · Kannada',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.textKannadaDark : AppTheme.textKannadaLight,
                      letterSpacing: 1,
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.textKannadaDark : AppTheme.textKannadaLight)
                        .withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? AppTheme.textKannadaDark : AppTheme.textKannadaLight)
                          .withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    widget.shloka.kannada,
                    style: GoogleFonts.notoSansKannada(
                      fontSize: 18 * scale,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppTheme.textKannadaDark : AppTheme.textKannadaLight,
                      height: 2.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ── Meaning ─────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  const Text('💡 ', style: TextStyle(fontSize: 12)),
                  Text('ಅರ್ಥ · Meaning',
                    style: TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w600,
                      color: isDark ? AppTheme.textMeaningDark : AppTheme.textMeaningLight,
                      letterSpacing: 1,
                    ),
                  ),
                ]),
                const SizedBox(height: 8),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.textMeaningDark : AppTheme.textMeaningLight)
                        .withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: (isDark ? AppTheme.textMeaningDark : AppTheme.textMeaningLight)
                          .withOpacity(0.1),
                    ),
                  ),
                  child: Text(
                    widget.shloka.meaning,
                    style: GoogleFonts.notoSansKannada(
                      fontSize: 15 * scale,
                      color: isDark ? AppTheme.textMeaningDark : AppTheme.textMeaningLight,
                      height: 1.8,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Explanation ─────────────────────────────────────
          if (widget.shloka.explanation != null) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () => setState(() => _explanationExpanded = !_explanationExpanded),
                    child: Row(children: [
                      const Text('📖 ', style: TextStyle(fontSize: 12)),
                      Text('ವಿವರಣೆ · Explanation ${_explanationExpanded ? "▴" : "▾"}',
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: AppTheme.saffron, letterSpacing: 1,
                        ),
                      ),
                    ]),
                  ),
                  if (_explanationExpanded) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border(left: BorderSide(color: AppTheme.saffron, width: 3)),
                      ),
                      child: Text(
                        widget.shloka.explanation!,
                        style: GoogleFonts.notoSansKannada(
                          fontSize: 13 * scale,
                          color: Theme.of(context).textTheme.bodyMedium?.color,
                          height: 1.8,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
