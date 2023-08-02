import 'dart:ui';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetingSettingScreen extends StatefulWidget {
  const MeetingSettingScreen({Key? key}) : super(key: key);

  @override
  State<MeetingSettingScreen> createState() => _MeetingSettingScreenState();
}

class _MeetingSettingScreenState extends State<MeetingSettingScreen> {
  bool isOn = false;
  bool previewVideo = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Cài đặt cuộc họp',
          style: TextStyle(color: AppColors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColors.tundora,
        iconTheme:
            context.theme.theme.iconTheme.copyWith(color: AppColors.white),
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: AppDimens.paddingHorizontal16,
          children: [
            Container(
              margin: AppDimens.paddingVertical16,
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ÂM THANH',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: ()=>AppRouter.toPage(context, AppPages.Meeting_AutoConnectAudio),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Tự động kết nối âm thanh',
                              style: context.theme.userListTileTextTheme
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Tắt',
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
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Tắt tiếng micro của tôi',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Sử dụng âm thanh gốc',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                ],
              ),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              height: 280,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'VIDEO',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Tắt video của tôi',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            'Tân trang giao diện',
                            style: context.theme.userListTileTextTheme
                                .copyWith(fontSize: 14),
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Bật',
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
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => AppRouter.toPage(context, AppPages.Meeting_RatioScreen),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Tỷ lệ khung hình',
                              style: context.theme.userListTileTextTheme
                                  .copyWith(fontSize: 14),
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Tỉ lệ gốc',
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
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Phản chiếu video của tôi',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '1';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị video xem trước',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            previewVideo = value;
                            if(previewVideo){
                              AppRouter.toPage(context, AppPages.Meeting_PreviewVideo);
                            }
                          });
                          return '1';
                        },initValue: previewVideo,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                ],
              ),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              height: 430,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CHUNG',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Luôn hiện các nút điều khiển cuộc họp',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị Phụ đề rời (khi khả dụng)',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị thời gian kết nối của tôi',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị tên khi Người khi tham vào',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị Người tham gia không có Video',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Yêu cầu xác nhận khi rời khỏi cuộc họp',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Tự động sao chép lời mời',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Hiển thị biểu tượng hồ sơ người dùng bên cạnh tin nhắn trò chuyện trong cuộc họp',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              height: 80,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'LỊCH',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Luôn hiện các nút điều khiển cuộc họp',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 14),),),
                        SwitchButton(onChanged: (value)async{
                          setState(() {
                            isOn = value;
                          });
                          return '';
                        },initValue: isOn,)
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
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
