import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_home/gen/fonts.gen.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';
import 'package:smart_home/shared/extensions/color_extension.dart';


class AppTextIcon extends StatelessWidget {
  final String text;
  final String icon;
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
  final bool isReverse;
  final double iconSize;
  final Color? iconColor;
  final double spacing;
  final bool isOnTap;
  final VoidCallback? onTap;

  const AppTextIcon(this.text,
      {super.key,
      required this.icon,
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
      this.isReverse = false,
      this.iconSize = 12,
      this.iconColor,
      this.spacing = 4,
      this.isOnTap = false,
      this.onTap})
      : assert(color == null || style == null, 'Can\'t provide both color and style\n'),
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
    return Row(
      textDirection: isReverse ? TextDirection.rtl : TextDirection.ltr,
      mainAxisSize: MainAxisSize.min,
      children: [
        Material(
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: isOnTap ? onTap : null,
            child: SvgPicture.asset(
              icon,
              width: iconSize,
              height: iconSize,
              colorFilter: iconColor?.colorFilter,
            ),
          ),
        ),
        SizedBox(width: spacing),
        Flexible(
          child: Text(
            text,
            style: _textStyle,
            maxLines: maxLines,
            textAlign: textAlign,
            overflow: overflow,
            textDirection: textDirection,
          ),
        ),
      ],
    );
  }
}
