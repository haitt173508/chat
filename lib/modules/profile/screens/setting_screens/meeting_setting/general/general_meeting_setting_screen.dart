import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';

class GeneralMeetingSettingScreen extends StatefulWidget {
  const GeneralMeetingSettingScreen({Key? key}) : super(key: key);

  @override
  State<GeneralMeetingSettingScreen> createState() =>
      _GeneralMeetingSettingScreenState();
}

class _GeneralMeetingSettingScreenState
    extends State<GeneralMeetingSettingScreen> {
  bool isOn = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chung',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.tundora,
        iconTheme:
            context.theme.theme.iconTheme.copyWith(color: AppColors.white),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: 130,
              margin: AppDimens.paddingVertical16,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                  border: Border(
                      top: BorderSide(color: AppColors.greyCC),
                      bottom: BorderSide(color: AppColors.greyCC)),
                  color: context.theme.backgroundColor),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ảnh chụp nhanh mờ trên trình chuyển đổi tác vụ',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      SwitchButton(
                        onChanged: (_) async {
                          setState(() {
                            isOn = _;
                          });
                        },
                        initValue: isOn,
                      ),
                    ],
                  ),
                  Expanded(
                    child: Text(
                      'Bật tùy chọn này để ẩn thông tin có thể là nhạy cảm khỏi ảnh chụp nhanh trong cửa sổ chính của Chat365. Ảnh chụp nhanh này hiển thị dưới dạng màn hình xem trước trong trình chuyển đổi tác vụ khi đang mở nhiều ứng dụng',
                      style: context.theme.chatConversationDropdownTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 60,
              margin: AppDimens.paddingVertical16,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: GestureDetector(
                onTap: () => AppRouter.toPage(
                    context, AppPages.Meeting_RingSetting),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        'Nhạc chuông',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Chọn nhạc chuông cho cuộc họp',
                              style: context
                                  .theme.chatConversationDropdownTextStyle,
                            ),
                          ),
                          SvgPicture.asset(
                            Images.ic_arrow_right,
                            color: context.theme.iconColor,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
