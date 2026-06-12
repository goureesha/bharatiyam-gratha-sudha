import 'package:flutter/material.dart';

/// Renders Nudi-encoded Kannada text using bundled Nudi fonts.
/// The text is stored as Latin-1 string (byte values 0-255 as Unicode codepoints).
class NudiText extends StatelessWidget {
  final String text;
  final String fontFamily;
  final double fontSize;
  final TextAlign textAlign;
  final Color? color;
  final double height;
  final int? maxLines;
  final TextOverflow? overflow;

  const NudiText({
    super.key,
    required this.text,
    this.fontFamily = 'Brhknd',
    this.fontSize = 20.0,
    this.textAlign = TextAlign.left,
    this.color,
    this.height = 1.6,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: fontFamily,
        fontSize: fontSize,
        color: color ?? Theme.of(context).colorScheme.onSurface,
        height: height,
      ),
    );
  }
}
