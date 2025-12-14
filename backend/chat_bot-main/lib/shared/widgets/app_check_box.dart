import 'package:flutter/material.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';
import 'package:smart_home/shared/widgets/app_text.dart';


class AppCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;
  final String label;
  final EdgeInsets? padding;

  const AppCheckbox({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        onChanged.call(!value);
      },
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            Transform.translate(
              offset: const Offset(-5, 0),
              child: Checkbox(
                value: value,
                activeColor: context.colors.primaryColor,
                onChanged: onChanged,
                visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                side: const BorderSide(
                  width: 1.5,
                  color: Color(0xffD0D0D0),
                ),
              ),
            ),
            Flexible(child: AppText(label)),
          ],
        ),
      ),
    );
  }
}
