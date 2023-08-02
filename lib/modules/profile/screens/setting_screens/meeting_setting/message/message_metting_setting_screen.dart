
import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/button/switch_button.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MessageMeetingSettingScreen extends StatefulWidget {
  const MessageMeetingSettingScreen({Key? key}) : super(key: key);

  @override
  State<MessageMeetingSettingScreen> createState() => _MessageMeetingSettingScreenState();
}

class _MessageMeetingSettingScreenState extends State<MessageMeetingSettingScreen> {
  bool isOn = false;
  List notification = [true,false,false];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Trò chuyện',
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
              height: 50,
              child: Row(
                children: [
                  Expanded(child: Text('Hiển thị xem trước liên kết',
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
            Container(
              margin: AppDimens.paddingVertical16,
              height: 180,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NHẬN THÔNG BÁO ĐỐI VỚI',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          notification = List.filled(notification.length, false);
                          notification[0]=true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text('Tất cả tin nhắn',
                            style: context.theme.userListTileTextTheme
                                .copyWith(fontSize: 14),),),
                          notification[0]?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          notification = List.filled(notification.length, false);
                          notification[1]=true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text('Chỉ tin nhắn riêng tư hoặc lần nhắc đến',
                            style: context.theme.userListTileTextTheme
                                .copyWith(fontSize: 14),),),
                          notification[1]?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: (){
                        setState(() {
                          notification = List.filled(notification.length, false);
                          notification[2]=true;
                        });
                      },
                      child: Row(
                        children: [
                          Expanded(child: Text('Không',
                            style: context.theme.userListTileTextTheme
                                .copyWith(fontSize: 14),),),
                          notification[2]?SvgPicture.asset(Images.ic_tick,color: AppColors.blueGradients1,):Container(),
                        ],
                      ),
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
              height: 250,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NHẬN THÔNG BÁO ĐỐI VỚ',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Luôn đặt tất cả tin nhắn chưa đọc trên đầu',
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
                        Expanded(child: Text('Di chuyển tin nhắn có câu trả lời mới xuống phía dưới cùng của cuộc trò chuyện',
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
                        Expanded(child: Text('Thông báo cho tôi về các câu trả lời mới đối với tin nhắn mà tôi đang theo dõi',
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
                        Expanded(child: Text('Tắt đi khi đang trong cuộc họp',
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
              height: 130,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'CÁCH THÔNG BÁO CHO TÔI',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                  Divider(
                    thickness: 0.5,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        Expanded(child: Text('Rung trong ứng dụng',
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
                        Expanded(child: Text('Âm cảnh báo trong ứng dụng',
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
