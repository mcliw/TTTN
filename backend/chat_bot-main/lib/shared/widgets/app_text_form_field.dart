import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:smart_home/gen/fonts.gen.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';
import 'package:smart_home/shared/theme/styles.dart';


import 'app_text.dart';

class AppTextFormField extends FormField<String> {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool obscured;
  final String? hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? errorStyle;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final bool enableBorder;
  final bool filled;
  final Color? fillColor;
  final bool enableCounter;

  AppTextFormField({
    super.key,
    this.prefixIcon,
    this.suffixIcon,
    this.obscured = false,
    super.initialValue,
    this.hintText,
    this.hintTextStyle,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.keyboardType,
    super.enabled,
    super.validator,
    this.focusNode,
    this.controller,
    this.onTap,
    this.textStyle,
    this.errorStyle,
    this.contentPadding,
    AutovalidateMode super.autovalidateMode = AutovalidateMode.disabled,
    this.onSubmitted,
    this.textAlign = TextAlign.start,
    this.autoFocus = false,
    this.borderRadius,
    this.enableBorder = true,
    this.filled = true,
    this.fillColor,
    this.enableCounter = false,
  }) : super(
          builder: (FormFieldState<String> field) {
            void onChangedHandler(String value) {
              onChanged?.call(value);
              field.didChange(value);
            }

            return _BTextField(
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              obscured: obscured,
              initialValue: initialValue,
              hintText: hintText,
              onChanged: onChangedHandler,
              inputFormatters: inputFormatters,
              errorText: field.errorText,
              maxLength: maxLength,
              maxLines: maxLines,
              enabled: enabled,
              keyboardType: keyboardType,
              focusNode: focusNode,
              controller: controller,
              onTap: onTap,
              textStyle: textStyle,
              hintTextStyle: hintTextStyle,
              contentPadding: contentPadding,
              errorStyle: errorStyle,
              onSubmitted: onSubmitted,
              textAlign: textAlign,
              autoFocus: autoFocus,
              enableBorder: enableBorder,
              borderRadius: borderRadius,
              fillColor: fillColor,
              filled: filled,
              enableCounter: enableCounter,
            );
          },
        );
}

class _BTextField extends StatefulWidget {
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? obscured;
  final String? initialValue;
  final String? hintText;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final List<TextInputFormatter>? inputFormatters;
  final int? maxLength;
  final int maxLines;
  final bool enabled;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final VoidCallback? onTap;
  final TextStyle? textStyle;
  final TextStyle? hintTextStyle;
  final TextStyle? errorStyle;
  final EdgeInsets? contentPadding;
  final TextAlign textAlign;
  final bool autoFocus;
  final BorderRadius? borderRadius;
  final bool enableBorder;
  final bool filled;
  final Color? fillColor;
  final bool enableCounter;

  const _BTextField({
    this.prefixIcon,
    this.suffixIcon,
    this.obscured,
    this.initialValue,
    this.hintText,
    this.errorText,
    this.onChanged,
    this.inputFormatters,
    this.maxLength,
    this.maxLines = 1,
    this.enabled = true,
    this.keyboardType,
    this.focusNode,
    this.controller,
    this.onTap,
    this.textStyle,
    this.hintTextStyle,
    this.errorStyle,
    this.contentPadding,
    this.onSubmitted,
    this.textAlign = TextAlign.start,
    required this.autoFocus,
    this.borderRadius,
    this.enableBorder = true,
    this.filled = true,
    this.fillColor,
    this.enableCounter = false,
  });

  @override
  State<_BTextField> createState() => _BTextFieldState();
}

class _BTextFieldState extends State<_BTextField> {
  late TextEditingController controller;
  late FocusNode focusNode;
  bool get showError => widget.errorText != null;
  String? cacheErrorText;

  @override
  void initState() {
    super.initState();
    focusNode = widget.focusNode ?? FocusNode();
    controller = widget.controller ?? TextEditingController();
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant _BTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      if (!focusNode.hasFocus) {
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          controller.text = widget.initialValue!;
          widget.onChanged?.call(controller.text);
        });
      }
    }
    if (widget.errorText != oldWidget.errorText) {
      if (mounted) {
        setState(() {
          cacheErrorText = widget.errorText;
        });
      }
    }
  }

  void _onFocusChanged() {
    if (!focusNode.hasFocus) {
      widget.onChanged?.call(controller.text);
    }
  }

  InputBorder _getEnabledBorder() {
    Color borderColor = context.colors.inputBorder;
    if (showError) {
      borderColor = context.colors.textError;
    }
    return OutlineInputBorder(
      borderSide: widget.enableBorder ? BorderSide(color: borderColor) : BorderSide.none,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppRadius.inputRadius),
    );
  }

  InputBorder _getFocusedBorder() {
    Color borderColor = context.colors.focusedInputBorder;
    if (showError) {
      borderColor = context.colors.textError;
    }
    return OutlineInputBorder(
      borderSide: widget.enableBorder ? BorderSide(color: borderColor, width: 2) : BorderSide.none,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppRadius.inputRadius),
    );
  }

  InputBorder _getDisabledBorder() {
    return OutlineInputBorder(
      borderSide: widget.enableBorder
          ? BorderSide(color: context.colors.disabledInputBorder)
          : BorderSide.none,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(AppRadius.inputRadius),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(
            maxHeight: widget.maxLines == 1 ? AppSize.inputHeight : double.infinity,
          ),
          child: TextFormField(
            autofocus: widget.autoFocus,
            controller: controller,
            enabled: widget.enabled,
            focusNode: focusNode,
            cursorColor: context.colors.cursor,
            obscureText: widget.obscured!,
            onChanged: widget.onChanged,
            inputFormatters: widget.inputFormatters,
            maxLength: widget.maxLength,
            maxLines: widget.maxLines,
            keyboardType: widget.keyboardType,
            onTap: widget.onTap,
            onFieldSubmitted: widget.onSubmitted,
            textAlign: widget.textAlign,
            onTapOutside: (_) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            buildCounter: widget.enableCounter
                ? null
                : (context, {int? currentLength, bool? isFocused, int? maxLength}) => null,
            style: TextStyle(
              fontSize: 15,
              fontFamily: FontFamily.roboto,
              color: context.colors.textPrimary,
              fontWeight: FontWeight.w400,
            ).merge(widget.textStyle),
            decoration: InputDecoration(
              contentPadding: widget.contentPadding,
              enabledBorder: _getEnabledBorder(),
              focusedBorder: _getFocusedBorder(),
              disabledBorder: _getDisabledBorder(),
              filled: widget.filled,
              fillColor:
                  widget.fillColor ?? (widget.enabled ? Colors.white : const Color(0xffEFEFEF)),
              hintText: widget.hintText,
              hintStyle: TextStyle(
                fontSize: 16,
                color: context.colors.placeholderColor,
                fontFamily: FontFamily.roboto,
              ).merge(widget.hintTextStyle),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              constraints: const BoxConstraints(maxHeight: AppSize.inputHeight),
            ),
          ),
        ),
        if (cacheErrorText != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: AppText(
                cacheErrorText!,
                style: TextStyle(
                  fontSize: 12,
                  color: context.colors.textError,
                ).merge(widget.errorStyle),
              ),
            ),
          )
      ],
    );
  }
}
