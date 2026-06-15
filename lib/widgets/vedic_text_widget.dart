import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders Vedic svara marks as painted lines above/below syllables
/// instead of relying on font-based combining marks.
///
/// Mark types:
/// - U+0952 (anudātta): horizontal line BELOW the syllable
/// - U+0951 (svarita): vertical/horizontal line ABOVE the syllable
/// - U+1CDA (double svarita): double line ABOVE the syllable
class VedicTextWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;

  const VedicTextWidget({
    super.key,
    required this.text,
    required this.fontSize,
    required this.textColor,
  });

  // Vedic accent mark codepoints
  static const int _anudatta = 0x0952;   // line below
  static const int _svarita = 0x0951;    // line above
  static const int _doubleSvarita = 0x1CDA; // double line above

  static bool _isMark(int cp) =>
      cp == _anudatta || cp == _svarita || cp == _doubleSvarita;

  @override
  Widget build(BuildContext context) {
    // Check if text has any Vedic marks
    bool hasMarks = text.runes.any((r) => _isMark(r));

    if (!hasMarks) {
      // No marks — use simple Text widget
      return Text(
        text,
        style: GoogleFonts.notoSansKannada(
          fontSize: fontSize,
          height: 1.9,
          letterSpacing: 0.3,
          color: textColor,
        ),
      );
    }

    // Build RichText with styled spans for marked syllables
    final spans = _buildSpans();
    return RichText(
      text: TextSpan(
        style: GoogleFonts.notoSansKannada(
          fontSize: fontSize,
          height: 2.2, // Extra height for marks
          letterSpacing: 0.3,
          color: textColor,
        ),
        children: spans,
      ),
    );
  }

  List<InlineSpan> _buildSpans() {
    final List<InlineSpan> spans = [];
    final runes = text.runes.toList();
    final buffer = StringBuffer();

    int i = 0;
    while (i < runes.length) {
      final cp = runes[i];

      if (_isMark(cp)) {
        // Flush any preceding text
        if (buffer.isNotEmpty) {
          // Find the last syllable in the buffer to apply the mark to
          final bufStr = buffer.toString();
          final lastSyllableStart = _findLastSyllableStart(bufStr);

          if (lastSyllableStart > 0) {
            // Add text before the marked syllable
            spans.add(TextSpan(text: bufStr.substring(0, lastSyllableStart)));
          }

          // Add the marked syllable with decoration
          final syllable = bufStr.substring(lastSyllableStart);
          spans.add(_createMarkedSpan(syllable, cp));
          buffer.clear();
        }
        i++;
      } else {
        buffer.writeCharCode(cp);
        i++;
      }
    }

    // Flush remaining text
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString()));
    }

    return spans;
  }

  /// Find the start of the last syllable in the string.
  /// A syllable is: consonant(+virama+consonant)* + dependent_vowel
  int _findLastSyllableStart(String s) {
    if (s.isEmpty) return 0;

    final runes = s.runes.toList();
    int end = runes.length - 1;

    // Skip trailing dependent vowels
    while (end >= 0 && _isDepVowel(runes[end])) {
      end--;
    }

    // Walk back through consonant clusters (consonant + virama)
    while (end >= 0) {
      if (_isConsonant(runes[end])) {
        if (end - 1 >= 0 && runes[end - 1] == 0x0CCD) {
          // virama before this consonant - continue back
          end -= 2;
        } else {
          // Start of syllable
          break;
        }
      } else {
        break;
      }
    }

    if (end < 0) end = 0;
    return end;
  }

  WidgetSpan _createMarkedSpan(String syllable, int markType) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: _MarkedSyllable(
        syllable: syllable,
        markType: markType,
        fontSize: fontSize,
        textColor: textColor,
      ),
    );
  }

  static bool _isConsonant(int cp) => cp >= 0x0C95 && cp <= 0x0CB9;
  static bool _isDepVowel(int cp) => cp >= 0x0CBE && cp <= 0x0CCC;
}

class _MarkedSyllable extends StatelessWidget {
  final String syllable;
  final int markType;
  final double fontSize;
  final Color textColor;

  const _MarkedSyllable({
    required this.syllable,
    required this.markType,
    required this.fontSize,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final markColor = textColor.withOpacity(0.85);

    return CustomPaint(
      foregroundPainter: _SvaraPainter(
        markType: markType,
        color: markColor,
        fontSize: fontSize,
      ),
      child: Text(
        syllable,
        style: GoogleFonts.notoSansKannada(
          fontSize: fontSize,
          color: textColor,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SvaraPainter extends CustomPainter {
  final int markType;
  final Color color;
  final double fontSize;

  _SvaraPainter({
    required this.markType,
    required this.color,
    required this.fontSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = fontSize * 0.06
      ..style = PaintingStyle.stroke;

    final width = size.width;

    if (markType == VedicTextWidget._anudatta) {
      // Horizontal line BELOW the text
      final y = size.height - fontSize * 0.05;
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    } else if (markType == VedicTextWidget._svarita) {
      // Horizontal line ABOVE the text
      final y = fontSize * 0.15;
      canvas.drawLine(Offset(0, y), Offset(width, y), paint);
    } else if (markType == VedicTextWidget._doubleSvarita) {
      // Double line ABOVE the text
      final y1 = fontSize * 0.1;
      final y2 = fontSize * 0.2;
      canvas.drawLine(Offset(0, y1), Offset(width, y1), paint);
      canvas.drawLine(Offset(0, y2), Offset(width, y2), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvaraPainter oldDelegate) =>
      markType != oldDelegate.markType ||
      color != oldDelegate.color ||
      fontSize != oldDelegate.fontSize;
}
