import 'package:flutter/material.dart';
import 'package:smart_home/gen/fonts.gen.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';


class BaseButton extends StatelessWidget {
  final Widget child;
  final double width;
  final double height;
  final VoidCallback? onPressed;
  final TextStyle? textStyle;
  final Color? primaryColor;
  final AlignmentGeometry alignment;
  final BorderRadiusGeometry? radius;
  final BorderSide? borderSide;
  final bool isOutlined;
  final double disableOpacity;
  final bool isExpaned;
  final double elevation;
  final Color? backgroundColor;

  const BaseButton({
    super.key,
    required this.child,
    this.width = double.infinity,
    required this.height,
    this.onPressed,
    this.textStyle,
    this.primaryColor,
    this.alignment = Alignment.center,
    this.radius,
    this.isOutlined = false,
    this.borderSide,
    this.disableOpacity = 0.6,
    this.isExpaned = true,
    this.elevation = 0,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final _primaryColor = primaryColor ?? context.colors.primaryButton;
    final _disabledColor = _primaryColor.withOpacity(disableOpacity);
    final _size = Size(width, height);
    final _elevation = WidgetStateProperty.all(elevation);
    final _shape = WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: radius ?? BorderRadius.circular(25),
      ),
    );
    final _textStyle = WidgetStateProperty.all(const TextStyle(
      fontFamily: FontFamily.roboto,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ).merge(textStyle));
    return isOutlined
        ? OutlinedButton(
            style: (isExpaned
                    ? OutlinedButton.styleFrom(minimumSize: _size)
                    : OutlinedButton.styleFrom(fixedSize: _size))
                .copyWith(
              alignment: alignment,
              elevation: _elevation,
              side: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return borderSide ??
                      BorderSide(width: 1, color: _disabledColor);
                }
                return borderSide ?? BorderSide(width: 1, color: _primaryColor);
              }),
              shape: _shape,
              textStyle: _textStyle,
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return _primaryColor.withOpacity(disableOpacity);
                }
                return _primaryColor;
              }),
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                return backgroundColor;
              }),
              splashFactory: InkRipple.splashFactory,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            onPressed: onPressed,
            child: child,
          )
        : ElevatedButton(
            style: (isExpaned
                    ? ElevatedButton.styleFrom(minimumSize: _size)
                    : ElevatedButton.styleFrom(fixedSize: _size))
                .copyWith(
              alignment: alignment,
              elevation: _elevation,
              shape: _shape,
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return (textStyle?.color ?? context.colors.textPrimary)
                      .withOpacity(disableOpacity);
                }
                return textStyle?.color ?? context.colors.textPrimary;
              }),
              padding: WidgetStateProperty.all(EdgeInsets.zero),
              textStyle: _textStyle,
              splashFactory: InkRipple.splashFactory,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.disabled)) {
                  return _disabledColor;
                }
                return _primaryColor;
              }),
            ),
            onPressed: onPressed,
            child: child,
          );
  }
}
