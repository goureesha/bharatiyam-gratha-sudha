import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders Vedic text with Baraha-style svara marks.
/// Marks are prefix characters in the text:
/// - † (U+2020) = svarita → line ABOVE next syllable
/// - … (U+2026) = anudātta → line BELOW next syllable
/// - ‡ (U+2021) = double svarita → double line ABOVE next syllable
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

  static const int _svarita = 0x2020;       // †
  static const int _anudatta = 0x2026;      // …
  static const int _doubleSvarita = 0x2021;  // ‡

  static bool _isMark(int cp) =>
      cp == _svarita || cp == _anudatta || cp == _doubleSvarita;

  @override
  Widget build(BuildContext context) {
    // If no marks, use simple Text
    bool hasMarks = false;
    for (int i = 0; i < text.length; i++) {
      if (_isMark(text.codeUnitAt(i))) {
        hasMarks = true;
        break;
      }
    }

    if (!hasMarks) {
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

    return RichText(
      text: TextSpan(
        style: GoogleFonts.notoSansKannada(
          fontSize: fontSize,
          height: 2.2,
          letterSpacing: 0.3,
          color: textColor,
        ),
        children: _buildSpans(),
      ),
    );
  }

  List<InlineSpan> _buildSpans() {
    final spans = <InlineSpan>[];
    final buffer = StringBuffer();
    int i = 0;

    while (i < text.length) {
      final cp = text.codeUnitAt(i);

      if (_isMark(cp)) {
        // Flush buffered plain text
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString()));
          buffer.clear();
        }

        i++; // skip the mark character

        // Consume next syllable
        final syllableEnd = _consumeNextSyllable(i);
        if (syllableEnd > i) {
          final syllable = text.substring(i, syllableEnd);
          spans.add(_buildMarkedWidget(syllable, cp));
          i = syllableEnd;
        }
      } else {
        buffer.write(text[i]);
        i++;
      }
    }

    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString()));
    }

    return spans;
  }

  /// Build a WidgetSpan with the syllable + painted mark
  WidgetSpan _buildMarkedWidget(String syllable, int markType) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.baseline,
      baseline: TextBaseline.alphabetic,
      child: CustomPaint(
        foregroundPainter: _SvaraPainter(
          markType: markType,
          color: textColor,
        ),
        child: Text(
          syllable,
          style: GoogleFonts.notoSansKannada(
            fontSize: fontSize,
            letterSpacing: 0.3,
            color: textColor,
          ),
        ),
      ),
    );
  }

  int _consumeNextSyllable(int start) {
    int i = start;
    final n = text.length;
    if (i >= n) return i;

    final cp = text.codeUnitAt(i);

    // Independent vowel
    if (cp >= 0x0C85 && cp <= 0x0C94) {
      i++;
      while (i < n) {
        final c = text.codeUnitAt(i);
        if (c >= 0x0CBE && c <= 0x0CCC) { i++; } else { break; }
      }
      return i;
    }

    // Consonant
    if (cp >= 0x0C95 && cp <= 0x0CB9) {
      i++;
      while (i < n) {
        final c = text.codeUnitAt(i);
        if (c == 0x0CCD) { // virama
          if (i + 1 < n) {
            final next = text.codeUnitAt(i + 1);
            if (next == 0x200D && i + 2 < n && text.codeUnitAt(i + 2) >= 0x0C95 && text.codeUnitAt(i + 2) <= 0x0CB9) {
              i += 3; // virama + ZWJ + consonant
            } else if (next >= 0x0C95 && next <= 0x0CB9) {
              i += 2; // virama + consonant
            } else {
              i++; break;
            }
          } else {
            i++; break;
          }
        } else if (c == 0x200D) { // ZWJ
          if (i + 1 < n && text.codeUnitAt(i + 1) >= 0x0C95 && text.codeUnitAt(i + 1) <= 0x0CB9) {
            i += 2;
          } else {
            break;
          }
        } else {
          break;
        }
      }
      // Dependent vowel
      if (i < n) {
        final c = text.codeUnitAt(i);
        if (c >= 0x0CBE && c <= 0x0CCC) i++;
      }
      return i;
    }

    return start + 1;
  }
}

/// Paints svara marks as horizontal lines above or below the text
class _SvaraPainter extends CustomPainter {
  final int markType;
  final Color color;

  _SvaraPainter({required this.markType, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    if (markType == VedicTextWidget._anudatta) {
      // Line BELOW
      final y = size.height - 1.0;
      canvas.drawLine(Offset(1, y), Offset(size.width - 1, y), paint);
    } else if (markType == VedicTextWidget._svarita) {
      // Line ABOVE
      canvas.drawLine(const Offset(1, 1), Offset(size.width - 1, 1), paint);
    } else if (markType == VedicTextWidget._doubleSvarita) {
      // Double line ABOVE
      canvas.drawLine(const Offset(1, 0), Offset(size.width - 1, 0), paint);
      canvas.drawLine(const Offset(1, 3), Offset(size.width - 1, 3), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SvaraPainter old) =>
      markType != old.markType || color != old.color;
}
