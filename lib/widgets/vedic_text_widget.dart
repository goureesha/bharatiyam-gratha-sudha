import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders Vedic text with svara marks using Flutter's TextDecoration.
/// Strips combining marks (U+0951, U+0952, U+1CDA) and renders them as:
/// - Anudātta (U+0952): underline below the syllable
/// - Svarita (U+0951): overline above the syllable
/// - Double Svarita (U+1CDA): thick overline above the syllable
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

  static const int _anudatta = 0x0952;
  static const int _svarita = 0x0951;
  static const int _doubleSvarita = 0x1CDA;

  static bool _isMark(int cp) =>
      cp == _anudatta || cp == _svarita || cp == _doubleSvarita;

  @override
  Widget build(BuildContext context) {
    // If no marks, use simple Text
    if (!text.runes.any((r) => _isMark(r))) {
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
          height: 1.9,
          letterSpacing: 0.3,
          color: textColor,
        ),
        children: _buildSpans(),
      ),
    );
  }

  List<TextSpan> _buildSpans() {
    final spans = <TextSpan>[];
    final runes = text.runes.toList();
    final buffer = StringBuffer();
    int? pendingMark;

    for (int i = 0; i < runes.length; i++) {
      final cp = runes[i];

      if (_isMark(cp)) {
        // Found a mark — flush buffer as plain text, then mark the
        // PREVIOUS syllable. We need to go back and split it.
        final plain = buffer.toString();
        buffer.clear();

        if (plain.isNotEmpty) {
          // Find last syllable boundary
          final splitIdx = _lastSyllableStart(plain);
          if (splitIdx > 0) {
            spans.add(TextSpan(text: plain.substring(0, splitIdx)));
          }
          // The marked syllable
          final syllable = plain.substring(splitIdx);
          spans.add(_decoratedSpan(syllable, cp));
        }
      } else {
        buffer.writeCharCode(cp);
      }
    }

    // Flush remaining
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString()));
    }

    return spans;
  }

  TextSpan _decoratedSpan(String syllable, int markType) {
    TextDecoration decoration;
    Color decoColor = textColor.withOpacity(0.7);
    double thickness = 1.5;

    if (markType == _anudatta) {
      decoration = TextDecoration.underline;
    } else if (markType == _svarita) {
      decoration = TextDecoration.overline;
    } else {
      // double svarita
      decoration = TextDecoration.overline;
      thickness = 3.0;
    }

    return TextSpan(
      text: syllable,
      style: TextStyle(
        decoration: decoration,
        decorationColor: decoColor,
        decorationThickness: thickness,
        decorationStyle: markType == _doubleSvarita
            ? TextDecorationStyle.double
            : TextDecorationStyle.solid,
      ),
    );
  }

  /// Find start index of the last syllable in a string.
  int _lastSyllableStart(String s) {
    final runes = s.runes.toList();
    int i = runes.length - 1;

    // Skip trailing anusvara/visarga (they're part of syllable display)
    while (i >= 0 && (runes[i] == 0x0C82 || runes[i] == 0x0C83)) {
      i--;
    }

    // Skip trailing dependent vowels
    while (i >= 0 && _isDepVowel(runes[i])) {
      i--;
    }

    // Walk back through consonant+virama clusters
    while (i >= 0) {
      if (_isConsonant(runes[i])) {
        if (i - 1 >= 0 && runes[i - 1] == 0x0CCD) {
          i -= 2; // virama + consonant
        } else if (i - 1 >= 0 && runes[i - 1] == 0x200D) {
          i -= 2; // ZWJ
        } else {
          break; // start of syllable
        }
      } else {
        break;
      }
    }

    if (i < 0) i = 0;
    return i;
  }

  static bool _isConsonant(int cp) => cp >= 0x0C95 && cp <= 0x0CB9;
  static bool _isDepVowel(int cp) => cp >= 0x0CBE && cp <= 0x0CCC;
}
