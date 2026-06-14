import 'package:flutter/material.dart';

/// Renders Nudi-encoded Kannada text using bundled Nudi fonts.
/// Used ONLY for stotra/mantra content that requires the Nudi font.
/// All UI text should use the default theme font (Noto Sans Kannada).
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
      text,
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
