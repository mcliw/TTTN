import 'package:flutter/material.dart';
import 'package:smart_home/gen/fonts.gen.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';


class AppText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextDirection? textDirection;
  final Color? color;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final TextDecoration? textDecoration;
  final double? lineHeight;
  final FontStyle? fontStyle;

  const AppText(
    this.text, {
    super.key,
    this.style,
    this.maxLines,
    this.textAlign,
    this.overflow,
    this.textDecoration,
    this.color,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
    this.textDirection,
    this.lineHeight,
    this.fontStyle,
  })  : assert(color == null || style == null, 'Can\'t provide both color and style\n'),
        assert(fontStyle == null || style == null, 'Can\'t provide both fontStyle and style\n'),
        assert(fontFamily == null || style == null, 'Can\'t provide both fontFamily and style\n'),
        assert(fontSize == null || style == null, 'Can\'t provide both fontSize and style\n'),
        assert(textDecoration == null || style == null,
            'Can\'t provide both textDecoration and style\n'),
        assert(fontWeight == null || style == null, 'Can\'t provide both fontWeight and style\n');

  @override
  Widget build(BuildContext context) {
    TextStyle _textStyle = TextStyle(
      fontSize: 14,
      fontFamily: FontFamily.roboto,
      color: context.colors.textPrimary,
      fontWeight: FontWeight.w400,
    );
    if (style != null) {
      _textStyle = _textStyle.merge(style);
    } else {
      _textStyle = _textStyle.copyWith(
        fontFamily: fontFamily,
        color: color,
        fontSize: fontSize,
        decoration: textDecoration,
        fontWeight: fontWeight,
        height: lineHeight,
        fontStyle: fontStyle,
      );
    }
    return Text(
      text,
      style: _textStyle,
      maxLines: maxLines,
      textAlign: textAlign,
      overflow: overflow,
      textDirection: textDirection,
    );
  }
}
