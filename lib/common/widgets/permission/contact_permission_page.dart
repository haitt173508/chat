import 'package:chat_365/common/widgets/permission/permission_page_layout.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class ContactPermissionPage extends StatelessWidget {
  const ContactPermissionPage({
    Key? key,
    this.callBack,
  }) : super(key: key);

  static const String callBackArg = 'callBackArg';

  final VoidCallback? callBack;

  @override
  Widget build(BuildContext context) {
    return PermissionPageLayout(
      text: Text(
        'Cập nhật danh bạ giúp tìm kiếm và liên lạc với bạn bè dễ dàng hơn. Chat365 cam kết dữ liệu của bạn luôn được mã hóa và bảo mật tuyệt đối.',
        style: AppTextStyles.regularW400(
          context,
          size: 14,
          lineHeight: 20,
        ),
        textAlign: TextAlign.center,
      ),
      title: 'Danh bạ từ máy',
      permission: Permission.contacts,
      callBackOnAcceptPermission: callBack,
    );
  }
}
