import 'package:flutter/material.dart';
import 'package:smart_home/shared/theme/styles.dart';
import 'package:smart_home/shared/widgets/app_text.dart';



import 'base_button.dart';

class AppButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
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
  final bool isOutlined;
  final Color? backgroundColor;

  const AppButton({
    super.key,
    this.onPressed,
    required this.label,
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
  })  : isOutlined = false,
        backgroundColor = Colors.transparent;

  const AppButton.outline({
    super.key,
    this.onPressed,
    required this.label,
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
    this.backgroundColor,
  }) : isOutlined = true;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
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
      backgroundColor: backgroundColor,
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisAlignment: alignment,
          children: [
            if (isLoading)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: SizedBox(
                  width: indicatorSize,
                  height: indicatorSize,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: isOutlined
                        ? primaryColor
                        : (textStyle?.color ?? Colors.white),
                  ),
                ),
              ),
            Flexible(
              child: AppText(
                label,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                color: (isOutlined
                        ? primaryColor
                        : (textStyle?.color ?? Colors.white))!
                    .withOpacity(isEnabled ? 1 : 0.6),
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
