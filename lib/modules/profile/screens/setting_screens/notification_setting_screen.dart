import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';

class NotificationSettingModel {
  final String title;
  final String? content;
  bool isSelect;

  NotificationSettingModel({
    required this.title,
    required this.content,
    required this.isSelect,
  });

  set setIsSelect(bool value) {
    isSelect = value;
  }
}

List<NotificationSettingModel> listNotiSetting = [
  NotificationSettingModel(
    title: 'Thông báo trò chuyện',
    content: 'Nhận thông báo khi có tin nhắn đến',
    isSelect: true,
  ),
  NotificationSettingModel(
    title: 'Tương tác',
    content: 'Nhận thông báo khi có người tương tác với tin nhắn của bạn',
    isSelect: true,
  ),
  NotificationSettingModel(
    title: 'Âm báo',
    content: 'Phát âm thanh khi có thông báo mới',
    isSelect: true,
  ),
  NotificationSettingModel(
    title: 'Mẹo và thủ thuật',
    content:
        'Hiển thị thông báo trong ứng dụng từ Chat365 về tính năng. Thông báo hệ thống quan trọng vẫn sẽ được hiển thị ngay cả khi đã tắt',
    isSelect: false,
  ),
  NotificationSettingModel(
    title: 'Thông báo về cuộc gọi theo lịch',
    content: 'Nhận thông báo về các cuộc gọi đã lên lịch',
    isSelect: false,
  ),
  NotificationSettingModel(
    title: 'Thông báo về cuộc thăm dò ý kiến',
    content: null,
    isSelect: true,
  ),
  NotificationSettingModel(
    title: 'Báo nhắc cuộc trò chuyện bị nhỡ',
    content:
        'Nhận lời nhắc email vè các cuộc trog chuyện bạn đã bỏ lỡ trong 72 giờ qua',
    isSelect: true,
  ),
];
TextStyle _style(
  BuildContext context,
) =>
    AppTextStyles.regularW500(
      context,
      size: 16,
      lineHeight: 22,
    );

class NotificationSettingScreen extends StatefulWidget {
  const NotificationSettingScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NotificationSettingScreen> createState() =>
      _NotificationSettingScreenState();
}

class _NotificationSettingScreenState extends State<NotificationSettingScreen> {
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
          title: Text('Thông báo'),
          elevation: 1,
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.all(15).copyWith(top: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int index = 0; index < listNotiSetting.length; index++)
                  UnderlineWidget(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${listNotiSetting[index].title}',
                                    style: _style(context),
                                  ),
                                ),
                                listNotiSetting[index].content == null
                                    ? SwitchButton(
                                        initValue:
                                            listNotiSetting[index].isSelect,
                                        onChanged: (_) async {
                                          setState(() {
                                            listNotiSetting[index].isSelect =
                                                !listNotiSetting[index]
                                                    .isSelect;
                                          });
                                          return '';
                                        })
                                    : SizedBox(),
                              ],
                            ),
                            SizedBoxExt.h5,
                            listNotiSetting[index].content != null
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          listNotiSetting[index].content!,
                                          style: AppTextStyles.hintText,
                                        ),
                                      ),
                                      SwitchButton(
                                          initValue:
                                              listNotiSetting[index].isSelect,
                                          onChanged: (_) async {
                                            setState(() {
                                              listNotiSetting[index].isSelect =
                                                  !listNotiSetting[index]
                                                      .isSelect;
                                            });
                                            return '';
                                          })
                                    ],
                                  )
                                : SizedBox(),
                          ]),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UnderlineWidget extends StatelessWidget {
  const UnderlineWidget({
    Key? key,
    required this.child,
  }) : super(key: key);
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        child,
        Divider(
          thickness: 1,
          height: 1,
          color: AppColors.greyCC,
        ),
      ],
    );
  }
}
