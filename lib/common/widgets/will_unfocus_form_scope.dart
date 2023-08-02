import 'package:chat_365/utils/ui/system_chrome_extension.dart';
import 'package:flutter/material.dart';

class WillUnfocusFormScope extends StatelessWidget {
  const WillUnfocusFormScope({
    Key? key,
    required this.child,
    this.willUnfocusCallback,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? willUnfocusCallback;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        SystemChromeExtension.hideKeyboardIfVisible();
        willUnfocusCallback?.call();
      },
      child: child,
    );
  }
}
