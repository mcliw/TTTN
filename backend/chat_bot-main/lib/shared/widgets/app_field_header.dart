import 'package:flutter/material.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';


class AppFieldHeader extends StatelessWidget {
  final String text;
  final bool isRequired;
  const AppFieldHeader({super.key, required this.text, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        RichText(
            text: TextSpan(
                text: text,
                style: TextStyle(color: context.colors.black, fontSize: 14),
                children: [
              const WidgetSpan(
                  child: SizedBox(
                width: 5,
              )),
              isRequired
                  ? const TextSpan(
                      text: '*',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                      ))
                  : const WidgetSpan(child: SizedBox(width: 0)),
            ])),
      ],
    );
  }
}
