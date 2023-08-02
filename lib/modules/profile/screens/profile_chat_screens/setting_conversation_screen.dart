import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';

TextStyle _style(
  BuildContext context,
) =>
    AppTextStyles.regularW700(
      context,
      size: 14,
      lineHeight: 22,
      color: context.theme.textColor,
    );

class SettingConversationScreen extends StatefulWidget {
  final IUserInfo userInfo;
  const SettingConversationScreen({Key? key, re, required this.userInfo})
      : super(key: key);

  @override
  State<SettingConversationScreen> createState() =>
      _SettingConversationScreenState();
}

class _SettingConversationScreenState extends State<SettingConversationScreen> {
  bool onNoti = true;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        listTileTheme: ListTileThemeData(
          contentPadding: EdgeInsets.zero,
          dense: true,
          minLeadingWidth: 20,
          minVerticalPadding: 0,
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Cài đặt cuộc trò chuyện'),
          elevation: 1,
          leading: BackButton(
            color: context.theme.iconColor,
          ),
        ),
        body: Padding(
          padding: EdgeInsets.all(15).copyWith(top: 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: AppPadding.paddingVertical10,
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        'Thông báo',
                        style: _style(context),
                      ),
                    ),
                    SwitchButton(
                        initValue: onNoti,
                        onChanged: (_) async {
                          setState(() {
                            onNoti = !onNoti;
                          });
                          return '';
                        }),
                  ],
                ),
              ),
              //
              ListTile(
                title: Text(
                  'Ẩn cuộc trò chuyện',
                  style: _style(context),
                ),
                // contentPadding: AppPadding.paddingVertical10,
                onTap: () {
                  AppDialogs.showConfirmDialog(
                    context,
                    title: 'Ẩn cuộc trò chuyện',
                    content: Padding(
                      padding: AppPadding.paddingVertical15,
                      child: Text(
                        'Cuộc trò chuyện này sẽ bị ẩn cho đến khi có tin nhắn mới. Hãy sử dụng tính năng tìm kiếm để tìm lại cuộc trò chuyện này',
                        textAlign: TextAlign.center,
                        style: context.theme.hintStyle
                            .copyWith(color: context.theme.textColor),
                      ),
                    ),
                    onFunction: (_) {
                      Future.delayed(Duration(milliseconds: 900), () {
                        AppRouter.back(context);
                        // Do something
                      });
                      return null;
                    },
                    successMessage: 'Ẩn cuộc trò chuyện thành công',
                    nameFunction: 'Đồng ý',
                  );
                },
              ),
              //
              ListTile(
                title: Text(
                  'Xóa cuộc hội thoại trên Chat365',
                  style: _style(context),
                ),
                // contentPadding: AppPadding.paddingVertical10,
                onTap: () {
                  AppDialogs.showConfirmDialog(
                    context,
                    title: 'Xóa cuộc trò chuyện',
                    content: Padding(
                      padding: AppPadding.paddingVertical15,
                      child: Text(
                        'Cuộc trò chuyện này sẽ bị xóa khỏi chat365 và không thể khôi phục.',
                        textAlign: TextAlign.center,
                        style: context.theme.hintStyle
                            .copyWith(color: context.theme.textColor),
                      ),
                    ),
                    onFunction: (_) {
                      Future.delayed(Duration(milliseconds: 900), () {
                        AppRouter.back(context);
                        // Do something
                      });
                      return null;
                    },
                    successMessage: 'Xóa cuộc trò chuyện thành công.',
                    nameFunction: 'Xóa',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
