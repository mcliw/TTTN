import 'package:flutter/material.dart';

class BottomNavigationController extends ChangeNotifier {
  BottomNavigationController({
    required int initialIndex,
  }) : _index = initialIndex;

  int _index = 0;
  int get index => _index;

  void changeIndex(int value) {
    if (value == _index) {
      return;
    }
    _index = value;
    notifyListeners();
  }
}

class BottomNavigationProvider extends InheritedWidget {
  final BottomNavigationController controller;

  const BottomNavigationProvider(
    Widget child, {
    super.key,
    required this.controller,
  }) : super(child: child);

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }

  static BottomNavigationProvider? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BottomNavigationProvider>();
}
