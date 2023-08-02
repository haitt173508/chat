import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class OverviewSecuritySettingScreen extends StatefulWidget {
  const OverviewSecuritySettingScreen({Key? key}) : super(key: key);

  @override
  State<OverviewSecuritySettingScreen> createState() =>
      _OverviewSecuritySettingScreenState();
}

class _OverviewSecuritySettingScreenState
    extends State<OverviewSecuritySettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tổng quan về cài đặt bảo mật'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Hoàn thành'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Chỉ người dùng đã xác thực mới có thể tham gia',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Bị tắt',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Chỉ người dùng đã xác thực mới cỏ thể tham gia từ Web Client',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Bị tắt',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Chặn người dùng trong các miền cụ thể khỏi việc tham gia cuộc họp và hội thảo trực tuyến',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Bị tắt',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Loại âm thanh',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Âm thanh máy tính',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Yêu cầu mật khẩu đối với người tham gia',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Đã bật',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Yêu cầu mã hóa cho các điểm cuối của bên thứ 3 (SOP/H.323)',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Bị tắt',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: AppPadding.paddingAll16,
              decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.black99))),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      'Thông báo bằng âm thanh khi ai đó tham gia hoặc rời khỏi',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 14),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Bị tắt',
                      style: context.theme.chatConversationDropdownTextStyle,
                      textAlign: TextAlign.right,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
