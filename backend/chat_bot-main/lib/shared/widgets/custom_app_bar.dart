import 'package:flutter/material.dart';
import 'package:smart_home/gen/assets.gen.dart';
import 'package:smart_home/shared/extensions/color_extension.dart';


import 'app_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Color titleColor;
  final double titleFontSize;
  final FontWeight titleFontWeight;
  final List<Widget>? actions;
  final Color backgroundColor;
  final bool canBack;

  const CustomAppBar({
    super.key,
    this.title,
    this.titleColor = const Color(0xff373737),
    this.titleFontSize = 18,
    this.titleFontWeight = FontWeight.w500,
    this.actions,
    this.backgroundColor = Colors.white,
    this.canBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      centerTitle: true,
      elevation: 5,
      shadowColor: Colors.grey.withOpacity(0.2),
      surfaceTintColor: Colors.white,
      leading: canBack && Navigator.of(context).canPop()
          ? IconButton(
              onPressed: () => Navigator.of(context).pop(),
              splashRadius: 20,
              icon: Center(
                child: Assets.icons.iconBack.svg(
                  colorFilter: titleColor.colorFilter,
                  width: 32,
                ),
              ),
            )
          : null,
      title: title != null
          ? AppText(
              title!,
              color: titleColor,
              fontSize: titleFontSize,
              fontWeight: titleFontWeight,
            )
          : null,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}
