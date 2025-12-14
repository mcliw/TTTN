import 'package:flutter/material.dart';

import 'app_circle_loading.dart';

class LoadingDialogManager {
  static LoadingDialogManager? _instance;
  static LoadingDialogManager get instance => _instance ?? (_instance = LoadingDialogManager());

  LoadingDialogManager();

  bool isShowing = false;

  void hideLoading(BuildContext context) {
    if (isShowing) {
      isShowing = false;
      Navigator.of(context).pop();
    }
  }

  void showLoading(BuildContext context, {Widget? message}) {
    if (!isShowing) {
      isShowing = true;
      showLoadingDialog(context, message: message).then((_) => isShowing = false);
    }
  }
}

Future<void> showLoadingDialog(BuildContext context, {Widget? message}) {
  return showDialog(
    barrierDismissible: false,
    context: context,
    barrierColor: Colors.black.withOpacity(0.3),
    builder: (_) => _LoadingDialog(
      message: message,
    ),
  );
}

class _LoadingDialog extends StatelessWidget {
  final Widget? message;
  const _LoadingDialog({
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    if (message != null) {
      return PopScope(
        canPop: false,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
              ),
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const AppCircleLoading(),
                  const SizedBox(width: 16),
                  Expanded(child: message!),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return PopScope(
      canPop: false,
      child: Wrap(
        alignment: WrapAlignment.center,
        runAlignment: WrapAlignment.center,
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.all(12),
            child: const Center(
              child: AppCircleLoading(),
            ),
          ),
        ],
      ),
    );
  }
}
