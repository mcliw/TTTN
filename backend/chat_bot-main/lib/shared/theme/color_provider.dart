import 'package:flutter/material.dart';
import 'colors.dart';

class ColorThemeProvider extends InheritedWidget {
  final ColorTheme colors;

  const ColorThemeProvider({
    super.key,
    required this.colors,
    required super.child,
  });

  static ColorThemeProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ColorThemeProvider>()!;
  }

  @override
  bool updateShouldNotify(covariant ColorThemeProvider oldWidget) => colors != oldWidget.colors;
}
