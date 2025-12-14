import 'package:flutter/material.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';


Future<T?> showAppBottomsheet<T>({
  required BuildContext context,
  required Widget child,
  Color? backgroundColor,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = false,
}) {
  return showModalBottomSheet(
    context: context,
    barrierColor: barrierColor,
    isScrollControlled: true,
    isDismissible: isDismissible,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    backgroundColor: backgroundColor ?? context.colors.primaryBackground,
    enableDrag: enableDrag,
    builder: (_) => child,
  );
}
