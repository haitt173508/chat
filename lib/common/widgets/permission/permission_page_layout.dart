import 'package:chat_365/common/widgets/button/gradient_button.dart';
import 'package:chat_365/common/widgets/permission/_permission_images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionPageLayout extends StatefulWidget {
  const PermissionPageLayout({
    Key? key,
    required this.title,
    required this.text,
    required this.permission,
    required this.callBackOnAcceptPermission,
    this.permissionAppSettings,
  }) : super(key: key);

  final String title;
  final Widget text;
  final Permission permission;
  final VoidCallback? callBackOnAcceptPermission;
  final VoidCallback? permissionAppSettings;

  @override
  State<PermissionPageLayout> createState() => _PermissionPageLayoutState();
}

class _PermissionPageLayoutState extends State<PermissionPageLayout>
    with WidgetsBindingObserver {
  bool _didNavigateToAppSettings = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _didNavigateToAppSettings) {
      _didNavigateToAppSettings = false;
      var status = await widget.permission.status;
      _onPermissionGrandted(status);
    }

    super.didChangeAppLifecycleState(state);
  }

  void _onPermissionGrandted(PermissionStatus status) {
    if (status == PermissionStatus.granted ||
        status == PermissionStatus.limited) Navigator.of(context).pop();
    widget.callBackOnAcceptPermission?.call();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        elevation: 1,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: PermissionImage(),
            ),
            widget.text,
            const SizedBox(height: 50),
            GradientButton(
              width: 170,
              child: Center(
                child: Text(
                  StringConst.update,
                  style: AppTextStyles.regularW500(
                    context,
                    size: 14,
                    lineHeight: 16,
                    color: AppColors.white,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              gradientColor: context.theme.gradient,
              onPressed: () async {
                var status = await widget.permission.request();
                if (status == PermissionStatus.granted ||
                    status == PermissionStatus.limited) {
                  _onPermissionGrandted(status);
                  return;
                }

                if (status.isDisabled) {
                  _didNavigateToAppSettings = true;
                  (widget.permissionAppSettings ?? openAppSettings).call();
                  return;
                }
              },
            ),
            const SizedBox(height: 20),
            GradientButton(
              width: 170,
              onPressed: () {
                Navigator.of(context).pop();
                // widget.callBackOnAcceptPermission?.call();
              },
              child: Center(
                child: Text(
                  StringConst.skip,
                  style: AppTextStyles.regularW500(
                    context,
                    size: 14,
                    lineHeight: 16,
                    color: AppColors.black99,
                  ),
                ),
              ),
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              border: Border.all(
                color: AppColors.black99,
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
