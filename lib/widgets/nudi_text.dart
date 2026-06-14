import 'package:flutter/material.dart';

/// Maps cp1252 special characters (0x80-0x9F range) from their Unicode
/// codepoints back to PUA equivalents so the Baraha font can render them.
/// These bytes were decoded as cp1252 Unicode but the font expects PUA.
const Map<int, int> _cp1252ToPua = {
  0x20AC: 0xE080, // €
  0x201A: 0xE082, // ‚
  0x0192: 0xE083, // ƒ
  0x201E: 0xE084, // „  (svara mark)
  0x2026: 0xE085, // …  (svara mark)
  0x2020: 0xE086, // †  (svara mark)
  0x2021: 0xE087, // ‡  (svara mark)
  0x02C6: 0xE088, // ˆ
  0x2030: 0xE089, // ‰
  0x0160: 0xE08A, // Š
  0x2039: 0xE08B, // ‹
  0x0152: 0xE08C, // Œ
  0x017D: 0xE08E, // Ž
  0x2018: 0xE091, // '
  0x2019: 0xE092, // '
  0x201C: 0xE093, // "
  0x201D: 0xE094, // "
  0x2022: 0xE095, // •
  0x2013: 0xE096, // –
  0x2014: 0xE097, // —
  0x02DC: 0xE098, // ˜
  0x2122: 0xE099, // ™
  0x0161: 0xE09A, // š
  0x203A: 0xE09B, // ›
  0x0153: 0xE09C, // œ
  0x017E: 0xE09E, // ž
  0x0178: 0xE09F, // Ÿ
};

/// Remap cp1252 special chars to PUA so the Baraha font renders them.
String _fixCp1252ForBaraha(String text) {
  final buffer = StringBuffer();
  for (int i = 0; i < text.length; i++) {
    final cp = text.codeUnitAt(i);
    final pua = _cp1252ToPua[cp];
    if (pua != null) {
      buffer.writeCharCode(pua);
    } else {
      buffer.writeCharCode(cp);
    }
  }
  return buffer.toString();
}

/// Renders Nudi-encoded Kannada text using bundled Baraha fonts.
/// Handles vedic svara marks by remapping cp1252 chars to PUA codepoints.
class NudiText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlign;
  final Color? color;
  final double height;
  final int? maxLines;
  final TextOverflow? overflow;
  final FontWeight fontWeight;
  final double letterSpacing;

  const NudiText({
    super.key,
    required this.text,
    this.fontFamily = 'Brhknd',
    this.fontSize = 20.0,
    this.textAlign = TextAlign.left,
    this.color,
    this.height = 1.8,
    this.maxLines,
    this.overflow,
    this.fontWeight = FontWeight.normal,
    this.letterSpacing = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      _fixCp1252ForBaraha(text),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        height: height,
        fontWeight: fontWeight,
        letterSpacing: letterSpacing,
      ),
    );
  }
}
