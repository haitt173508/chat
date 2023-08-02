import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/debouncer/text_editing_controller_debouncer.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/cupertino.dart';

class EditMyMeetingRoomScreen extends StatefulWidget {
  const EditMyMeetingRoomScreen({Key? key}) : super(key: key);

  @override
  State<EditMyMeetingRoomScreen> createState() =>
      _EditMyMeetingRoomScreenState();
}

class _EditMyMeetingRoomScreenState extends State<EditMyMeetingRoomScreen> {
  TextEditingController idController = TextEditingController();

  bool personalID = false;
  bool requirePassword = true;
  bool waitingRoom = false;
  bool hostsVideo = false;
  bool participantsVideos = false;
  bool showAdvanceSetting = false;

  String repeatValue = 'Không có';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    idController.text = '123 456 7890';
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    idController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ID Cuộc họp cá nhân'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Lưu'),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: AppDimens.paddingHorizontal16,
          children: [
            Container(
              height: 80,
              margin: AppDimens.paddingVertical16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'ID CUỘC HỌP CÁ NHÂN',
                    style:
                        context.theme.searchBigTextStyle.copyWith(fontSize: 16),
                  ),
                  OutlineTextFormField(
                    controller: idController,
                    decoration: context.theme.inputDecoration,
                  ),
                ],
              ),
            ),
            Text(
              'BẢO MẬT',
              style: context.theme.searchBigTextStyle.copyWith(fontSize: 16),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Yêu cầu mật mã cuộc họp',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Chỉ những người dùng có liên kết mời hoặc nhập đúng mật mã mới được tham gia.',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: AppColors.lawnGreen,
                    onChanged: (value) {
                      setState(() {
                        requirePassword = value;
                      });
                    },
                    value: requirePassword,
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Mật mã',
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                ),
                Text(
                  'abczxy',
                  style: context.theme.chatConversationDropdownTextStyle,
                ),
              ],
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Kích hoạt phòng chờ',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          'Chỉ những người dùng được người chủ trì chấp nhận mới được tham gia.',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  CupertinoSwitch(
                    activeColor: AppColors.lawnGreen,
                    onChanged: (value) {
                      setState(() {
                        waitingRoom = value;
                      });
                    },
                    value: waitingRoom,
                  ),
                ],
              ),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TÙY CHỌN CUỘC HỌP',
                    style:
                        context.theme.searchBigTextStyle.copyWith(fontSize: 16),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Video người chủ trì',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CupertinoSwitch(
                        activeColor: AppColors.lawnGreen,
                        onChanged: (value) {
                          setState(() {
                            hostsVideo = value;
                          });
                        },
                        value: hostsVideo,
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Video người tham gia',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      CupertinoSwitch(
                        activeColor: AppColors.lawnGreen,
                        onChanged: (value) {
                          setState(() {
                            participantsVideos = value;
                          });
                        },
                        value: participantsVideos,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            !showAdvanceSetting
                ? TextButton(
                    onPressed: () {
                      setState(() {
                        showAdvanceSetting = true;
                      });
                    },
                    child: Row(
                      children: [
                        Expanded(
                            child: Text(
                          'Tùy chọn nâng cao',
                        )),
                      ],
                    ),
                  )
                : Container(
                    height: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Cho phép người tham gia được vào bất cứ lúc nào',
                                style: context
                                    .theme.chatConversationDropdownTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CupertinoSwitch(
                              activeColor: AppColors.lawnGreen,
                              onChanged: (value) {
                                setState(() {
                                  hostsVideo = value;
                                });
                              },
                              value: hostsVideo,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tắt tiếng người tham gia cuộc họp',
                                style: context
                                    .theme.chatConversationDropdownTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CupertinoSwitch(
                              activeColor: AppColors.lawnGreen,
                              onChanged: (value) {
                                setState(() {
                                  participantsVideos = value;
                                });
                              },
                              value: participantsVideos,
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Tự động ghi lại cuộc họp',
                                style: context
                                    .theme.chatConversationDropdownTextStyle
                                    .copyWith(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            CupertinoSwitch(
                              activeColor: AppColors.lawnGreen,
                              onChanged: (value) {
                                setState(() {
                                  participantsVideos = value;
                                });
                              },
                              value: participantsVideos,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () => AppRouter.toPage(
                              context, AppPages.AcceptOrDenyAccess),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Phê duyệt hoặc chặn quyền truy cập của người dùng từ các quốc gia/khu vực',
                                  style: context
                                      .theme.chatConversationDropdownTextStyle
                                      .copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              SvgPicture.asset(
                                Images.ic_arrow_down,
                                color: context.theme.iconColor,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          'Không có',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
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
