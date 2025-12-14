import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smart_home/shared/extensions/color_extension.dart';


import 'bottom_navigation_controller.dart';

/// Bottom Navigation Item
class BottomNavigationItem {
  final String icon;
  final Widget page;
  final Widget? badge;

  /// [label] : bottom tab's label
  /// [icon] : bottom tab's icon
  /// [page] : displaying page when item is focused
  /// [badge] : displaying badge count above of icon
  BottomNavigationItem({
    required this.icon,
    required this.page,
    this.badge,
  });
}

/// Bottom Navigation with list of tab items and page for each
class BottomNavigation extends StatefulWidget {
  final List<BottomNavigationItem> items;
  final Color activeColor;
  final Color inActiveColor;
  final Color backgroundColor;
  final Color indicatorColor;
  final double indicatorHeight;
  final int initIndex;
  final BoxDecoration? decoration;
  final double iconSize;
  final EdgeInsets labelPadding;
  final EdgeInsets iconPadding;
  final Function(int index)? onTabChanged;

  /// [items] : pages and bottom tab for each
  /// [activeColor] : color of label and icon when tab is focused
  /// [inActiveColor] : color of label and icon when tab is unfocused
  /// [backgroundColor] : background color of bottom navigation
  /// [indicatorColor] : color of indicator that display in top of each tab.
  /// Pass transparent color and [indicatorHeight] = 0 if want to hide indicator
  /// [indicatorHeight] : height of indicator that display in top of each tab
  /// [initIndex] : initial index of tab, default is first tab
  /// [decoration] : BoxDecoration for bottom tab
  /// [iconSize] : size of tab's icon
  /// [iconPadding] : padding of tab's icon
  /// [labelPadding] : padding of tab's label
  /// [onTabChanged] : callback one tab changed, and return new focused tab [index]
  const BottomNavigation({
    super.key,
    required this.items,
    required this.activeColor,
    this.inActiveColor = Colors.grey,
    this.backgroundColor = Colors.white,
    this.initIndex = 0,
    this.decoration,
    this.iconSize = 24,
    this.labelPadding = EdgeInsets.zero,
    this.iconPadding = EdgeInsets.zero,
    this.indicatorColor = Colors.transparent,
    this.indicatorHeight = 0,
    this.onTabChanged,
  });

  @override
  BottomNavigationState createState() => BottomNavigationState();
}

class BottomNavigationState extends State<BottomNavigation> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final BottomNavigationController _controller;

  @override
  void initState() {
    _controller = BottomNavigationController(initialIndex: widget.initIndex);
    _tabController = TabController(
      length: widget.items.length,
      vsync: this,
      initialIndex: widget.initIndex,
    )..addListener(() {
        widget.onTabChanged?.call(_tabController.index);
      });
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void changeToTab(int index) {
    _controller.changeIndex(_tabController.index);
    setState(() {
      _tabController.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _bottom = MediaQuery.of(context).padding.bottom;
    final _items = widget.items;
    return Scaffold(
      backgroundColor: widget.backgroundColor,
      body: BottomNavigationProvider(
        IndexedStack(
          index: _tabController.index,
          children: _items.map((item) => item.page).toList(),
        ),
        controller: _controller,
      ),
      bottomNavigationBar: Container(
        height: 55 + _bottom,
        padding: EdgeInsets.only(bottom: _bottom),
        decoration:
            (widget.decoration ?? const BoxDecoration()).copyWith(color: widget.backgroundColor),
        child: TabBar(
          indicator: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: widget.indicatorColor,
                width: widget.indicatorHeight,
              ),
            ),
          ),
          indicatorPadding: EdgeInsets.zero,
          indicatorColor: Colors.transparent,
          labelPadding: widget.labelPadding,
          controller: _tabController,
          tabs: List.generate(
            _items.length,
            (index) {
              final _item = _items[index];
              final _isSelected = index == _tabController.index;
              return Tab(
                iconMargin: widget.iconPadding,
                icon: Stack(
                  children: [
                    SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(
                        child: SvgPicture.asset(
                          _item.icon,
                          height: widget.iconSize,
                          width: widget.iconSize,
                          colorFilter: _isSelected
                              ? widget.activeColor.colorFilter
                              : widget.inActiveColor.colorFilter,
                        ),
                      ),
                    ),
                    if (_item.badge != null)
                      Positioned.fill(
                        bottom: null,
                        child: Row(
                          children: [
                            const Spacer(),
                            Expanded(
                              child: _item.badge!,
                            ),
                          ],
                        ),
                      )
                  ],
                ),
                child: const SizedBox(),
              );
            },
          ),
          onTap: changeToTab,
        ),
      ),
    );
  }
}

mixin BottomNavigationMixin<Page extends StatefulWidget> on State<Page> {
  BottomNavigationController? _controller;
  bool isFocused = false;

  @protected
  int get tabIndex;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller = BottomNavigationProvider.of(context)?.controller;
      _controller?.addListener(onChangedTab);
    });
  }

  @override
  void dispose() {
    _controller?.removeListener(onChangedTab);
    super.dispose();
  }

  void onChangedTab() {
    isFocused = tabIndex == _controller?.index;
  }
}
