import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Renders Vedic text with Baraha-style svara marks.
///
/// The data contains Baraha prefix marks:
/// - † (U+2020) = svarita → line ABOVE the next syllable
/// - … (U+2026) = anudātta → line BELOW the next syllable
/// - ‡ (U+2021) = double svarita → double line ABOVE the next syllable
///
/// These are stripped from the text and rendered as TextDecoration
/// on the syllable they mark.
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

  // Baraha prefix mark characters
  static const String _svarita = '\u2020';       // †
  static const String _anudatta = '\u2026';      // …
  static const String _doubleSvarita = '\u2021';  // ‡

  static bool _isMark(String ch) =>
      ch == _svarita || ch == _anudatta || ch == _doubleSvarita;

  @override
  Widget build(BuildContext context) {
    // If no marks, use simple Text
    if (!text.contains(_svarita) &&
        !text.contains(_anudatta) &&
        !text.contains(_doubleSvarita)) {
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
    final buffer = StringBuffer();
    int i = 0;

    while (i < text.length) {
      final ch = text[i];

      if (_isMark(ch)) {
        // Flush any buffered text
        if (buffer.isNotEmpty) {
          spans.add(TextSpan(text: buffer.toString()));
          buffer.clear();
        }

        // This is a PREFIX mark — applies to the NEXT syllable
        i++; // skip the mark character

        // Consume the next syllable
        final syllableEnd = _consumeNextSyllable(i);
        final syllable = text.substring(i, syllableEnd);

        if (syllable.isNotEmpty) {
          spans.add(_decoratedSpan(syllable, ch));
        }
        i = syllableEnd;
      } else {
        buffer.write(ch);
        i++;
      }
    }

    // Flush remaining
    if (buffer.isNotEmpty) {
      spans.add(TextSpan(text: buffer.toString()));
    }

    return spans;
  }

  /// Consume the next Kannada syllable starting at position [start].
  /// A syllable is: consonant(+virama+consonant)* + dependent_vowel
  int _consumeNextSyllable(int start) {
    int i = start;
    final n = text.length;
    if (i >= n) return i;

    final cp = text.codeUnitAt(i);

    // If it starts with an independent vowel
    if (_isKnVowel(cp)) {
      i++;
      while (i < n && _isKnDepVowel(text.codeUnitAt(i))) i++;
      return i;
    }

    // If it starts with a consonant
    if (_isKnConsonant(cp)) {
      i++;
      while (i < n) {
        final c = text.codeUnitAt(i);
        if (c == 0x0CCD) {
          // virama — check for next consonant
          if (i + 1 < n && _isKnConsonant(text.codeUnitAt(i + 1))) {
            i += 2; // consume virama + consonant
          } else {
            i++; break; // bare virama
          }
        } else if (c == 0x200D) {
          // ZWJ
          if (i + 1 < n && _isKnConsonant(text.codeUnitAt(i + 1))) {
            i += 2;
          } else {
            break;
          }
        } else {
          break;
        }
      }
      // Consume dependent vowel
      if (i < n && _isKnDepVowel(text.codeUnitAt(i))) {
        i++;
      }
      return i;
    }

    // Not a Kannada character — just consume one character
    return start + 1;
  }

  TextSpan _decoratedSpan(String syllable, String markType) {
    TextDecoration decoration;
    TextDecorationStyle decoStyle = TextDecorationStyle.solid;
    double thickness = 1.2;

    if (markType == _anudatta) {
      decoration = TextDecoration.underline;
    } else if (markType == _svarita) {
      decoration = TextDecoration.overline;
    } else {
      // double svarita
      decoration = TextDecoration.overline;
      decoStyle = TextDecorationStyle.double;
      thickness = 1.2;
    }

    return TextSpan(
      text: syllable,
      style: TextStyle(
        decoration: decoration,
        decorationColor: textColor,
        decorationThickness: thickness,
        decorationStyle: decoStyle,
      ),
    );
  }

  static bool _isKnConsonant(int cp) => cp >= 0x0C95 && cp <= 0x0CB9;
  static bool _isKnVowel(int cp) => cp >= 0x0C85 && cp <= 0x0C94;
  static bool _isKnDepVowel(int cp) => cp >= 0x0CBE && cp <= 0x0CCC;
}
