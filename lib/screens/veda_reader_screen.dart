import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/veda.dart';
import '../services/bookmark_service.dart';

class VedaReaderScreen extends StatefulWidget {
  final String title;
  final RigSukta? sukta;
  final RigVarga? varga;
  final VedaChapter? chapter;

  const VedaReaderScreen({
    super.key,
    required this.title,
    this.sukta,
    this.varga,
    this.chapter,
  });

  @override
  State<VedaReaderScreen> createState() => _VedaReaderScreenState();
}

class _VedaReaderScreenState extends State<VedaReaderScreen> {
  // Rigveda display mode: 0 = Samhita, 1 = Padapatha, 2 = Both
  int _rigvedaMode = 2; 

  // String transformation helper for Swahakara Mode
  String _applySwahakara(String samhita) {
    var text = samhita.trim();
    String suffix = "";
    
    // Find trailing vertical bars and separate them
    final barsMatch = RegExp(r'\s*\|+\s*$').firstMatch(text);
    if (barsMatch != null) {
      suffix = text.substring(barsMatch.start);
      text = text.substring(0, barsMatch.start).trim();
    }
    
    // Remove any trailing accent marks if they exist on the final syllable
    while (text.endsWith('\u0951') || text.endsWith('\u0952') || text.endsWith('\u1CDA')) {
      text = text.substring(0, text.length - 1);
    }
    
    if (text.endsWith('ಂ')) {
      // Replace final anusvara 'ಂ' with anudatta accent + ZWNJ + 'ಮ್(ಸ್ವಾಹಾ᳚)'
      text = text.substring(0, text.length - 1) + "\u0952\u200Cಮ್(ಸ್ವಾಹಾ\u1CDA)";
    } else {
      // Append anudatta accent + '(ಸ್ವಾಹಾ᳚)'
      text = text + "\u0952(ಸ್ವಾಹಾ\u1CDA)";
    }
    
    return text + (suffix.isNotEmpty ? " " + suffix : " ||");
  }

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double fontSize = bookmarks.fontSize;
    final isRigveda = widget.sukta != null || widget.varga != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          // Swahakara yajna toggle button (only for Rigveda)
          if (isRigveda)
            IconButton(
              icon: Icon(
                Icons.local_fire_department_rounded,
                color: bookmarks.isSwahakaraMode ? const Color(0xFFE8722A) : null,
              ),
              tooltip: 'ಸ್ವಾಹಾಕಾರ ವೀಕ್ಷಣೆ (Yajna Mode)',
              onPressed: () {
                bookmarks.isSwahakaraMode = !bookmarks.isSwahakaraMode;
                ScaffoldMessenger.of(context).clearSnackBars();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      bookmarks.isSwahakaraMode 
                          ? 'ಸ್ವಾಹಾಕಾರ ವೀಕ್ಷಣೆ ಸಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ 🔥' 
                          : 'ಸಾಮಾನ್ಯ ಸಂಹಿತಾ ವೀಕ್ಷಣೆ ಸಕ್ರಿಯಗೊಳಿಸಲಾಗಿದೆ',
                    ),
                    duration: const Duration(seconds: 1),
                  ),
                );
              },
            ),
          // Zoom out button
          IconButton(
            icon: const Icon(Icons.zoom_out_rounded),
            onPressed: () {
              context.read<BookmarkService>().fontSize = fontSize - 2.0;
            },
          ),
          // Font size indicator
          Center(
            child: Text(
              '${fontSize.toInt()}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          // Zoom in button
          IconButton(
            icon: const Icon(Icons.zoom_in_rounded),
            onPressed: () {
              context.read<BookmarkService>().fontSize = fontSize + 2.0;
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          if (isRigveda) _buildRigvedaControls(isDark),
          Expanded(
            child: widget.sukta != null
                ? _buildRigvedaContent(widget.sukta!.mantras, widget.sukta!.label, fontSize, bookmarks.isSwahakaraMode, isDark)
                : (widget.varga != null
                    ? _buildRigvedaContent(widget.varga!.mantras, 'ವರ್ಗ ${widget.varga!.number}', fontSize, bookmarks.isSwahakaraMode, isDark)
                    : _buildYajurvedaContent(widget.chapter!, fontSize, isDark)),
          ),
        ],
      ),
    );
  }

  Widget _buildRigvedaControls(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1E1635) : Colors.amber.shade50,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('ವೀಕ್ಷಣೆ: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 8),
          Expanded(
            child: SegmentedButton<int>(
              segments: const <ButtonSegment<int>>[
                ButtonSegment<int>(
                  value: 0,
                  label: Text('ಸಂಹಿತಾ', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment<int>(
                  value: 1,
                  label: Text('ಪದಪಾಠ', style: TextStyle(fontSize: 12)),
                ),
                ButtonSegment<int>(
                  value: 2,
                  label: Text('ಎರಡೂ', style: TextStyle(fontSize: 12)),
                ),
              ],
              selected: <int>{_rigvedaMode},
              onSelectionChanged: (Set<int> newSelection) {
                setState(() {
                  _rigvedaMode = newSelection.first;
                });
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

  Widget _buildRigvedaContent(List<RigMantra> mantras, String headerLabel, double fontSize, bool isSwahakara, bool isDark) {
    final cleanLabel = headerLabel.replaceFirst(RegExp(r'^\[\d+\]\s*'), '').trim();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mantras.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.04) : Colors.amber.shade50.withOpacity(0.4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.amber.shade200,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.info_outline_rounded, color: Color(0xFFD4A843), size: 20),
                    const SizedBox(width: 8),
                    Text(
                      widget.sukta != null ? 'ಸೂಕ್ತ ವಿವರಣೆ' : 'ವರ್ಗ ವಿವರಣೆ', 
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  cleanLabel,
                  style: GoogleFonts.notoSansKannada(
                    fontSize: 14,
                    height: 1.5,
                    color: isDark ? Colors.white70 : Colors.grey.shade800,
                  ),
                ),
              ],
            ),
          );
        }

        final mantra = mantras[index - 1];
        return _buildRigMantraCard(mantra, index, fontSize, isSwahakara, isDark);
      },
    );
  }

  Widget _buildRigMantraCard(RigMantra mantra, int mantraIndex, double fontSize, bool isSwahakara, bool isDark) {
    // Clean Padapatha: replace '¦' separator with spaces
    final cleanPada = mantra.pada.replaceAll('¦', ' ').replaceAll('  ', ' ').trim();
    
    // Apply Swahakara transformation if yajna mode is active
    final samhitaText = isSwahakara ? _applySwahakara(mantra.samhita) : mantra.samhita;

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      color: isDark ? const Color(0xFF120C24) : Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.withOpacity(0.12),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Mantra Number + Rishi/Devata
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8722A).withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.sukta != null ? 'ಮಂತ್ರ ${mantra.number}' : 'ಮಂತ್ರ ${mantraIndex}',
                    style: const TextStyle(
                      color: Color(0xFFE8722A),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (mantra.rishi_dev_str.isNotEmpty)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        mantra.rishi_dev_str,
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white60 : Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.end,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
            const Divider(height: 20, thickness: 0.5),

            // Content: Samhita and/or Padapatha
            if (_rigvedaMode == 0 || _rigvedaMode == 2) ...[
              if (_rigvedaMode == 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'ಸಂಹಿತಾ ಪಾಠ:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.amber.shade300 : const Color(0xFF8B1A2B),
                    ),
                  ),
                ),
              Text(
                samhitaText,
                style: GoogleFonts.notoSansKannada(
                  fontSize: fontSize,
                  height: 1.6,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              if (_rigvedaMode == 2) const SizedBox(height: 12),
            ],

            if (_rigvedaMode == 1 || _rigvedaMode == 2) ...[
              if (_rigvedaMode == 2)
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    'ಪದಪಾಠ:',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.green.shade300 : Colors.green.shade800,
                    ),
                  ),
                ),
              Text(
                cleanPada,
                style: GoogleFonts.notoSansKannada(
                  fontSize: _rigvedaMode == 2 ? fontSize * 0.85 : fontSize,
                  height: 1.6,
                  color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            
            const SizedBox(height: 8),
            // Extra numbering index (optional footer detail)
            if (mantra.numbering.isNotEmpty)
              Text(
                mantra.numbering,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? Colors.white30 : Colors.grey.shade400,
                ),
                textAlign: TextAlign.right,
              ),
          ],
        ),
      ),
    );
  }

  // ===================== GENERIC VEDA CONTENT =====================
  Widget _buildYajurvedaContent(VedaChapter chapter, double fontSize, bool isDark) {
    IconData headerIcon = Icons.menu_book_rounded;
    Color headerIconColor = const Color(0xFFC41E3A);
    String itemLabel = 'ಮಂತ್ರ';
    
    if (widget.title.contains('ತೈತ್ತಿರೀಯ') || 
        widget.title.contains('ಬ್ರಾಹ್ಮಣ') || 
        widget.title.contains('ಆರಣ್ಯಕ') || 
        widget.title.contains('ಕೃಷ್ಣ ಯಜುರ್ವೇದ')) {
      itemLabel = 'ಅನುವಾಕ';
      headerIcon = Icons.fireplace_rounded;
      headerIconColor = const Color(0xFFC41E3A);
    } else if (widget.title.contains('ಶುಕ್ಲ ಯಜುರ್ವೇದ')) {
      itemLabel = 'ಮಂತ್ರ';
      headerIcon = Icons.wb_sunny_rounded;
      headerIconColor = const Color(0xFFF97316);
    } else if (widget.title.contains('ಸಾಮವೇದ')) {
      itemLabel = 'ಮಂತ್ರ';
      headerIcon = Icons.music_note_rounded;
      headerIconColor = const Color(0xFF0EA5E9);
    } else if (widget.title.contains('ಅಥರ್ವವೇದ')) {
      itemLabel = 'ಮಂತ್ರ';
      headerIcon = Icons.spa_rounded;
      headerIconColor = const Color(0xFF22C55E);
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: chapter.anuvakas.length,
      itemBuilder: (context, index) {
        final anuvaka = chapter.anuvakas[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 20),
          color: isDark ? const Color(0xFF120C24) : Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white.withOpacity(0.06) : Colors.grey.withOpacity(0.12),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Anuvaka/Mantra Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$itemLabel ${anuvaka.number}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.amber.shade300 : headerIconColor,
                      ),
                    ),
                    Icon(headerIcon, color: headerIconColor, size: 20),
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                const SizedBox(height: 4),
                // Prose text
                Text(
                  anuvaka.content,
                  style: GoogleFonts.notoSansKannada(
                    fontSize: fontSize,
                    height: 1.7,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// Extension to clean up rishi_dev formatting
extension on RigMantra {
  String get rishi_dev_str {
    return rishiDev.replaceAll('{', '').replaceAll('}', '').trim();
  }
}
