import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';
import 'package:smart_home/shared/extensions/color_extension.dart';
import 'package:smart_home/shared/theme/styles.dart';
import 'package:smart_home/shared/widgets/app_text.dart';

import 'base_button.dart';

class AppIconButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? label;
  final double width;
  final double height;
  final TextStyle? textStyle;
  final Color? primaryColor;
  final BorderRadiusGeometry? radius;
  final BorderSide? borderSide;
  final bool isLoading;
  final double? indicatorSize;
  final double disableOpacity;
  final bool isExpaned;
  final double elevation;
  final EdgeInsets padding;
  final MainAxisAlignment alignment;
  final String icon;
  final Color? iconColor;
  final double iconSize;
  final double spacing;
  final bool isOutlined;

  const AppIconButton({
    super.key,
    required this.icon,
    this.iconSize = 24,
    this.iconColor,
    this.spacing = 5,
    this.onPressed,
    this.label,
    this.width = double.infinity,
    this.height = AppSize.buttonHeight,
    this.textStyle,
    this.primaryColor,
    this.radius,
    this.borderSide,
    this.isLoading = false,
    this.indicatorSize = 18,
    this.disableOpacity = 0.6,
    this.isExpaned = true,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.alignment = MainAxisAlignment.center,
  }) : isOutlined = false;

  const AppIconButton.outline({
    super.key,
    required this.icon,
    this.iconSize = 24,
    this.iconColor,
    this.spacing = 5,
    this.onPressed,
    this.label,
    this.width = double.infinity,
    this.height = AppSize.buttonHeight,
    this.textStyle,
    this.primaryColor,
    this.radius,
    this.borderSide,
    this.isLoading = false,
    this.indicatorSize = 18,
    this.disableOpacity = 0.6,
    this.isExpaned = true,
    this.elevation = 0,
    this.padding = EdgeInsets.zero,
    this.alignment = MainAxisAlignment.center,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final _iconColor = iconColor ??
        (isOutlined
            ? (primaryColor ?? context.colors.primaryButton)
            : (textStyle?.color ?? context.colors.textPrimary));
    return BaseButton(
      onPressed: isLoading ? null : onPressed,
      width: width,
      height: height,
      textStyle: textStyle,
      primaryColor: primaryColor,
      radius: radius,
      borderSide: borderSide,
      disableOpacity: disableOpacity,
      isExpaned: isExpaned,
      elevation: elevation,
      isOutlined: isOutlined,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: textStyle?.color ?? Colors.white,
                  ),
                ),
              ),
            SvgPicture.asset(
              icon,
              width: iconSize,
              height: iconSize,
              colorFilter: onPressed == null
                  ? _iconColor.withOpacity(disableOpacity).colorFilter
                  : _iconColor.colorFilter,
            ),
            if (label != null)
              Flexible(
                child: AppText(
                  label!,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              )
          ],
        ),
      ),
    );
  }
}
