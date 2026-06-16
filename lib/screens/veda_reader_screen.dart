import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/veda.dart';
import '../services/bookmark_service.dart';

class VedaReaderScreen extends StatefulWidget {
  final String title;
  final RigSukta? sukta;
  final VedaChapter? chapter;

  const VedaReaderScreen({
    super.key,
    required this.title,
    this.sukta,
    this.chapter,
  });

  @override
  State<VedaReaderScreen> createState() => _VedaReaderScreenState();
}

class _VedaReaderScreenState extends State<VedaReaderScreen> {
  // Rigveda display mode: 0 = Samhita, 1 = Padapatha, 2 = Both
  int _rigvedaMode = 2; 

  @override
  Widget build(BuildContext context) {
    final bookmarks = context.watch<BookmarkService>();
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final double fontSize = bookmarks.fontSize;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
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
          if (widget.sukta != null) _buildRigvedaControls(isDark),
          Expanded(
            child: widget.sukta != null
                ? _buildRigvedaContent(widget.sukta!, fontSize, isDark)
                : _buildYajurvedaContent(widget.chapter!, fontSize, isDark),
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

  Widget _buildRigvedaContent(RigSukta sukta, double fontSize, bool isDark) {
    // Show Sukta label / Devata info at the top if present
    final labelText = sukta.label.replaceFirst(RegExp(r'^\[\d+\]\s*'), '').trim();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: sukta.mantras.length + 1,
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
                const Row(
                  children: [
                    Icon(Icons.info_outline_rounded, color: Color(0xFFD4A843), size: 20),
                    SizedBox(width: 8),
                    Text('ಸೂಕ್ತ ವಿವರಣೆ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  labelText,
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

        final mantra = sukta.mantras[index - 1];
        return _buildRigMantraCard(mantra, index, fontSize, isDark);
      },
    );
  }

  Widget _buildRigMantraCard(RigMantra mantra, int mantraIndex, double fontSize, bool isDark) {
    // Clean Padapatha: replace '¦' separator with a dot or a thin space
    final cleanPada = mantra.pada.replaceAll('¦', ' ').replaceAll('  ', ' ').trim();

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
                    'ಮಂತ್ರ ${mantra.number}',
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
                mantra.samhita,
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

  // ===================== YAJURVEDA CONTENT =====================
  Widget _buildYajurvedaContent(VedaChapter chapter, double fontSize, bool isDark) {
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
                // Anuvaka Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ಅನುವಾಕ ${anuvaka.number}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.amber.shade300 : const Color(0xFFC41E3A),
                      ),
                    ),
                    const Icon(Icons.fireplace_rounded, color: Color(0xFFC41E3A), size: 20),
                  ],
                ),
                const Divider(height: 20, thickness: 0.5),
                const SizedBox(height: 4),
                // Prose text (justified or left-aligned for readable reading)
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
    // strip the surrounding curly braces if any
    return rishiDev.replaceAll('{', '').replaceAll('}', '').trim();
  }
}
