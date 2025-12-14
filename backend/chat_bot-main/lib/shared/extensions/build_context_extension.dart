import 'package:flutter/material.dart';
import 'package:smart_home/shared/theme/color_provider.dart';
import 'package:smart_home/shared/theme/colors.dart';
import 'package:smart_home/shared/widgets/loading_dialog.dart';


extension BuildContextExt on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;

  ColorTheme get colors => ColorThemeProvider.of(this).colors;

  void showLoadingDialog({Widget? message}) => LoadingDialogManager.instance.showLoading(
        this,
        message: message,
      );

  void hideLoadingDialog() => LoadingDialogManager.instance.hideLoading(this);
}
