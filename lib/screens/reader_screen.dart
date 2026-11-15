import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/stotra.dart';
import '../services/bookmark_service.dart';
import '../services/stotra_service.dart';
import '../services/scripture_service.dart';

class ReaderScreen extends StatefulWidget {
  final Stotra stotra;
  const ReaderScreen({super.key, required this.stotra});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  String? _loadedContent;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.stotra.content.isNotEmpty) {
      _loadedContent = widget.stotra.content;
    } else {
      _loadContent();
    }
  }

  Future<void> _loadContent() async {
    if (!mounted) return;
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final String content;
      if (widget.stotra.id.contains('_ch_') ||
          widget.stotra.id.contains('_taranga_') ||
          widget.stotra.id.startsWith('grantha_')) {
        // It's a scripture chapter
        final scriptureService = context.read<ScriptureService>();
        content = await scriptureService.loadChapterContent(widget.stotra.id);
      } else {
        // It's a regular stotra
        final stotraService = context.read<StotraService>();
        content = await stotraService.loadStotraContent(widget.stotra.id);
      }

      if (mounted) {
        setState(() {
          _loadedContent = content;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'ಲೋಡ್ ಮಾಡಲು ಸಾಧ್ಯವಾಗಲಿಲ್ಲ: $e';
          _isLoading = false;
        });
      }
    }
  }

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

  bool _hasMeanings(String content) {
    return content.contains('ಶಬ್ದಾರ್ಥ') ||
        content.contains('ಭಾವಾರ್ಥ') ||
        content.contains('ವ್ಯಾಖ್ಯಾನ') ||
        content.contains('ವಿಶೇಷ ವಿವರಣೆ') ||
        content.contains('ವಿವರಣೆ:') ||
        content.contains('ಅರ್ಥ:') ||
        content.contains('ಪ್ರತಿಪದಾರ್ಥ:') ||
        content.contains('\n•');
  }

  String _normalizeBlocks(String content) {
    var normalized = content.replaceAll('\r\n', '\n');
    // Convert horizontal rule separators (---...) into standard block boundaries
    normalized = normalized.replaceAll(
      RegExp(r'\n?[ \t]*-{3,}[ \t]*\n?'),
      '\n\n',
    );
    // Keep Shabdartha, Bhavartha, and Vyakhyana attached to their preceding Shloka/Sutra
    normalized = normalized.replaceAllMapped(
      RegExp(
        r'\n\s*\n(?=[ \t]*(?:ಶಬ್ದಾರ್ಥ|ಭಾವಾರ್ಥ|ಅರ್ಥ\s*\(ಭಾವಾರ್ಥ\)|ಅರ್ಥ:|ಪ್ರತಿಪದಾರ್ಥ:|ತಾತ್ಪರ್ಯ:|ವಿಶೇಷ ವಿವರಣೆ|ವ್ಯಾಖ್ಯಾನ|ವಿವರಣೆ:|ನೌಕಾ ವ್ಯಾಖ್ಯಾನ|ಮಹೀಧರರ|•))',
      ),
      (_) => '\n',
    );
    return normalized;
  }

  List<Widget> _buildContentBlocks(
    String content,
    double fontSize,
    bool isDark,
    bool shlokaOnly,
  ) {
    final normalizedContent = _normalizeBlocks(content);
    final blocks = normalizedContent.split(RegExp(r'\n\s*\n'));
    final List<Widget> widgets = [];

    final primaryAccent = isDark ? const Color(0xFFE5A93C) : const Color(0xFFB85D14);
    final shlokaColor = isDark ? const Color(0xFFF2E6D4) : const Color(0xFF231604);
    final textColor = isDark ? const Color(0xFFE2DDD5) : const Color(0xFF332616);

    for (int i = 0; i < blocks.length; i++) {
      final block = blocks[i].trim();
      if (block.isEmpty) continue;

      final hasShabdartha = block.contains('ಶಬ್ದಾರ್ಥ:') || block.contains('•');
      final hasBhavartha = block.contains('ಭಾವಾರ್ಥ:') ||
          block.contains('ಅರ್ಥ (ಭಾವಾರ್ಥ):') ||
          block.contains('ಅರ್ಥ:') ||
          block.contains('ತಾತ್ಪರ್ಯ:');
      final hasVyakhyana = block.contains('ವ್ಯಾಖ್ಯಾನ') ||
          block.contains('ವಿಶೇಷ ವಿವರಣೆ') ||
          block.contains('ವಿವರಣೆ:');

      if (hasShabdartha || hasBhavartha || hasVyakhyana) {
        // Structured Puranic / Sutra Shloka Block
        final lines = block.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
        final List<String> shlokaLines = [];
        final List<String> shabdarthaLines = [];
        final List<String> bhavarthaLines = [];
        final List<String> vyakhyanaLines = [];
        String vyakhyanaHeader = 'ವ್ಯಾಖ್ಯಾನ:';

        String state = 'SHLOKA';
        for (final l in lines) {
          if (l.startsWith('ಶಬ್ದಾರ್ಥ:')) {
            state = 'SHABDARTHA';
            final clean = l.replaceFirst('ಶಬ್ದಾರ್ಥ:', '').trim();
            if (clean.isNotEmpty) {
              if (clean.contains(';')) {
                for (final part in clean.split(';')) {
                  final p = part.trim();
                  if (p.isNotEmpty) {
                    shabdarthaLines.add(p.startsWith('•') ? p : '• $p');
                  }
                }
              } else {
                shabdarthaLines.add(clean.startsWith('•') ? clean : '• $clean');
              }
            }
          } else if (l.startsWith('ಭಾವಾರ್ಥ:') ||
                     l.startsWith('ಅರ್ಥ (ಭಾವಾರ್ಥ):') ||
                     l.startsWith('ಅರ್ಥ:') ||
                     l.startsWith('ತಾತ್ಪರ್ಯ:')) {
            state = 'BHAVARTHA';
            final colonIdx = l.indexOf(':');
            final clean = colonIdx != -1 ? l.substring(colonIdx + 1).trim() : '';
            if (clean.isNotEmpty) bhavarthaLines.add(clean);
          } else if (l.startsWith('ವ್ಯಾಖ್ಯಾನ') ||
                     l.startsWith('ವಿಶೇಷ ವಿವರಣೆ') ||
                     l.startsWith('ವಿವರಣೆ:') ||
                     l.startsWith('ನೌಕಾ ವ್ಯಾಖ್ಯಾನ:') ||
                     l.startsWith('ಮಹೀಧರರ')) {
            state = 'VYAKHYANA';
            final colonIdx = l.indexOf(':');
            if (colonIdx != -1) {
              vyakhyanaHeader = l.substring(0, colonIdx + 1).trim();
              final clean = l.substring(colonIdx + 1).trim();
              if (clean.isNotEmpty) vyakhyanaLines.add(clean);
            } else {
              vyakhyanaHeader = l.trim();
            }
          } else if (state == 'SHABDARTHA' || (state != 'BHAVARTHA' && state != 'VYAKHYANA' && l.startsWith('•'))) {
            state = 'SHABDARTHA';
            if (l != 'ಶಬ್ದಾರ್ಥ:') shabdarthaLines.add(l);
          } else if (state == 'BHAVARTHA') {
            bhavarthaLines.add(l);
          } else if (state == 'VYAKHYANA') {
            vyakhyanaLines.add(l);
          } else {
            shlokaLines.add(l);
          }
        }

        if (shlokaOnly && shlokaLines.isEmpty) {
          continue;
        }

        final List<Widget> blockChildren = [];

        // 1. Shloka Text (Centered)
        if (shlokaLines.isNotEmpty) {
          blockChildren.add(
            Text(
              shlokaLines.join('\n'),
              textAlign: TextAlign.center,
              style: GoogleFonts.notoSansKannada(
                fontSize: fontSize,
                height: 1.85,
                letterSpacing: 0.3,
                color: shlokaColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          );
        }

        // 2. Shabdartha Box (Left Aligned) - Hidden in Shloka Only Mode
        if (!shlokaOnly && shabdarthaLines.isNotEmpty) {
          blockChildren.add(const SizedBox(height: 12));
          blockChildren.add(
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.025),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryAccent.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ಶಬ್ದಾರ್ಥ:',
                    style: GoogleFonts.notoSansKannada(
                      fontSize: fontSize * 0.88,
                      fontWeight: FontWeight.bold,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  ...shabdarthaLines.map((line) {
                    final cleanLine = line.trim();
                    String? sep;
                    if (cleanLine.contains(' - ')) {
                      sep = ' - ';
                    } else if (cleanLine.contains(' = ')) {
                      sep = ' = ';
                    }
                    if (sep != null) {
                      final parts = cleanLine.split(sep);
                      final left = parts[0].trim();
                      final right = parts.sublist(1).join(sep).trim();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.5),
                        child: RichText(
                          textAlign: TextAlign.left,
                          text: TextSpan(
                            style: GoogleFonts.notoSansKannada(
                              fontSize: fontSize * 0.88,
                              height: 1.7,
                              color: textColor,
                            ),
                            children: [
                              TextSpan(
                                text: left.startsWith('•') ? '$left ' : '• $left ',
                                style: const TextStyle(fontWeight: FontWeight.w600),
                              ),
                              const TextSpan(text: '- '),
                              TextSpan(text: right),
                            ],
                          ),
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: Text(
                        line.startsWith('•') ? line : '• $line',
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansKannada(
                          fontSize: fontSize * 0.88,
                          height: 1.7,
                          color: textColor,
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          );
        }

        // 3. Bhavartha Section (Left Aligned) - Hidden in Shloka Only Mode
        if (!shlokaOnly && bhavarthaLines.isNotEmpty) {
          blockChildren.add(const SizedBox(height: 10));
          final bhavProse = bhavarthaLines.join(' ').trim();
          blockChildren.add(
            Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                textAlign: TextAlign.left,
                text: TextSpan(
                  style: GoogleFonts.notoSansKannada(
                    fontSize: fontSize * 0.92,
                    height: 1.8,
                    letterSpacing: 0.2,
                    color: textColor,
                  ),
                  children: [
                    TextSpan(
                      text: 'ಭಾವಾರ್ಥ: ',
                      style: GoogleFonts.notoSansKannada(
                        fontWeight: FontWeight.bold,
                        color: primaryAccent,
                      ),
                    ),
                    TextSpan(text: bhavProse),
                  ],
                ),
              ),
            ),
          );
        }

        // 4. Vyakhya / Nauka Section (Left Aligned) - Hidden in Shloka Only Mode
        if (!shlokaOnly && vyakhyanaLines.isNotEmpty) {
          blockChildren.add(const SizedBox(height: 12));
          blockChildren.add(
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1730) : const Color(0xFFFAF5EE),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: primaryAccent.withOpacity(0.35),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    vyakhyanaHeader,
                    style: GoogleFonts.notoSansKannada(
                      fontSize: fontSize * 0.88,
                      fontWeight: FontWeight.bold,
                      color: primaryAccent,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vyakhyanaLines.join('\n'),
                    style: GoogleFonts.notoSansKannada(
                      fontSize: fontSize * 0.88,
                      height: 1.7,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        widgets.add(
          Padding(
            padding: EdgeInsets.only(bottom: i == blocks.length - 1 ? 0 : 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: blockChildren,
            ),
          ),
        );
      } else {
        // Regular Text / Non-scripture Block
        final blockLower = block.toLowerCase();
        bool isMeaningNote = false;
        final leftAlignKeywords = [
          'ಅರ್ಥ:',
          'ಭಾವಾರ್ಥ:',
          'ಶಬ್ದಾರ್ಥ:',
          'ಪ್ರತಿಪದಾರ್ಥ:',
          'ವಿವರಣೆ:',
          'ವಿಶೇಷ ವಿವರಣೆ',
          'ವ್ಯಾಖ್ಯಾನ',
          'ತಾತ್ಪರ್ಯ:',
          'ಟಿಪ್ಪಣಿ:',
        ];
        for (final kw in leftAlignKeywords) {
          if (blockLower.startsWith(kw)) {
            isMeaningNote = true;
            break;
          }
        }
        bool alignLeft = isMeaningNote;
        if (!alignLeft) {
          final firstChar = block.isNotEmpty ? block[0] : '';
          if (firstChar == '-' || firstChar == '*' || firstChar == '•' || RegExp(r'^\d+\.').hasMatch(block)) {
            alignLeft = true;
            if (firstChar == '•') isMeaningNote = true;
          }
        }

        if (shlokaOnly && isMeaningNote) {
          continue;
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
    }

    return widgets;
  }

  Widget _buildViewModeControls(BookmarkService bookmarks, bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1E1635) : Colors.amber.shade50,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'ವೀಕ್ಷಣೆ: ',
            style: GoogleFonts.notoSansKannada(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SegmentedButton<bool>(
              segments: <ButtonSegment<bool>>[
                ButtonSegment<bool>(
                  value: false,
                  icon: const Icon(Icons.menu_book_rounded, size: 16),
                  label: Text(
                    'ಶಬ್ದಾರ್ಥ & ಭಾವಾರ್ಥ',
                    style: GoogleFonts.notoSansKannada(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                ButtonSegment<bool>(
                  value: true,
                  icon: const Icon(Icons.auto_stories_outlined, size: 16),
                  label: Text(
                    'ಕೇವಲ ಶ್ಲೋಕ',
                    style: GoogleFonts.notoSansKannada(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              selected: <bool>{bookmarks.isShlokaOnlyMode},
              onSelectionChanged: (Set<bool> newSelection) {
                bookmarks.isShlokaOnlyMode = newSelection.first;
              },
              style: const ButtonStyle(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void shloka_lines_add(String l, List<String> list) {
    list.add(l);
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isBookmarked = bookmarks.isBookmarked(widget.stotra.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final rawContent = _loadedContent ?? '';
    final hasMeanings = !_isLoading && _error == null && _hasMeanings(rawContent);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.stotra.title,
          style: GoogleFonts.notoSansKannada(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (hasMeanings)
            IconButton(
              icon: Icon(
                bookmarks.isShlokaOnlyMode
                    ? Icons.auto_stories_rounded
                    : Icons.menu_book_rounded,
                color: bookmarks.isShlokaOnlyMode
                    ? const Color(0xFFFFD54F)
                    : Colors.white,
              ),
              tooltip: bookmarks.isShlokaOnlyMode
                  ? 'ಶಬ್ದಾರ್ಥ & ಭಾವಾರ್ಥ ತೋರಿಸಿ'
                  : 'ಕೇವಲ ಶ್ಲೋಕ ಮಾತ್ರ ತೋರಿಸಿ',
              onPressed: () {
                bookmarks.isShlokaOnlyMode = !bookmarks.isShlokaOnlyMode;
              },
            ),
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isBookmarked ? Colors.red : Colors.white,
            ),
            onPressed: () => bookmarks.toggle(widget.stotra.id),
          ),
        ],
      ),
      body: Container(
        color: isDark ? const Color(0xFF0A0516) : const Color(0xFFFFF8EE),
        child: Column(
          children: [
            if (hasMeanings) _buildViewModeControls(bookmarks, isDark),
            Expanded(
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
                      child: _isLoading
                          ? const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 40),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          : _error != null
                              ? Center(
                                  child: Column(
                                    children: [
                                      Text(
                                        _error!,
                                        style: TextStyle(
                                          color: isDark ? Colors.white70 : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      ElevatedButton.icon(
                                        onPressed: _loadContent,
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ'),
                                      ),
                                    ],
                                  ),
                                )
                              : SelectionArea(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: _buildContentBlocks(
                                      _formatContent(rawContent),
                                      bookmarks.fontSize,
                                      isDark,
                                      bookmarks.isShlokaOnlyMode,
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
                              'ಮೂಲ: ${widget.stotra.categoryTitle}',
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
          ],
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
