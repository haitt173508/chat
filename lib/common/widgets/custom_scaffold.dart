import 'package:chat_365/common/widgets/will_unfocus_form_scope.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({
    Key? key,
    required this.title,
    this.actions,
    this.backBtnPressedHandler,
    required this.body,
    this.bottomNavigationBar,
  }) : super(key: key);

  final String title;
  final List<Widget>? actions;
  final void Function()? backBtnPressedHandler;
  final Widget body;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    Widget current = WillUnfocusFormScope(
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              title,
            ),
            actions: actions,
            shape: Border(
              bottom: BorderSide(color: AppColors.greyCC, width: 1),
            ),
            elevation: 0,
          ),
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );

    if (backBtnPressedHandler != null)
      current = WillPopScope(
        child: current,
        onWillPop: () async {
          backBtnPressedHandler!();
          return false;
        },
      );

    return current;
  }
}
