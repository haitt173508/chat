import 'package:chat_365/common/widgets/permission/permission_page_layout.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/timekeeping/widgets/permission_camera_page_layout.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionPage extends StatelessWidget {
  const CameraPermissionPage({
    Key? key,
    this.callBack,
  }) : super(key: key);

  static const String callBackArg = 'callBackArg';

  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return PermissionCameraPageLayout(
      text: Text(
        'Truy cập camera bạn mới có thể sử dụng chức năng chấm công!',
        style: AppTextStyles.regularW400(
          context,
          size: 14,
          lineHeight: 20,
        ),
        textAlign: TextAlign.center,
      ),
      title: 'Camera',
      permission: Permission.camera,
      callBackOnAcceptPermission: callBack,
    );
  }
}
