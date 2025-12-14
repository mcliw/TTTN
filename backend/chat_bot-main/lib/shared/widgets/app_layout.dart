import 'package:flutter/material.dart';
import 'package:smart_home/shared/extensions/build_context_extension.dart';


class AppLayout extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final bool? resizeToAvoidBottomInset;
  final EdgeInsets? padding;
  final List<Color>? gradientColors;
  final Color? backgroundColor;

  const AppLayout({
    super.key,
    required this.child,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.padding,
    this.gradientColors,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? context.colors.primaryBackground,
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              )
            : null,
      ),
      child: Scaffold(
        body: child,
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
        appBar: appBar,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
