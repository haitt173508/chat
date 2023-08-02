import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:image_picker/image_picker.dart';

class MyMeetingScreen extends StatefulWidget {
  const MyMeetingScreen({Key? key}) : super(key: key);

  @override
  State<MyMeetingScreen> createState() => _MyMeetingScreenState();
}

class _MyMeetingScreenState extends State<MyMeetingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cuộc họp'),
        centerTitle: true,
        actions: [
          IconButton(
            padding: EdgeInsets.zero,
            onPressed: () =>
                AppRouter.toPage(context, AppPages.MeetingSchedule_Create),
            icon: SvgPicture.asset(
              Images.ic_video_plus,
              color: context.theme.primaryColor,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: AppDimens.paddingHorizontal16,
          child: Column(
            children: [
              Container(
                margin: AppDimens.paddingVertical16,
                height: 80,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  gradient: context.theme.gradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'ID cuộc họp cá nhân',
                      style: context.theme.chatConversationDropdownTextStyle.copyWith(color: AppColors.white),
                    ),
                    Text(
                      '012 345 6789',
                      style: context.theme.searchBigTextStyle.copyWith(
                        fontSize: 20,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                // margin: AppDimens.paddingVertical16,
                height: 44,
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => AppRouter.toPage(context, AppPages.Meeting_Screen),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: AppBorderAndRadius.defaultBorderRadius,
                            gradient: context.theme.gradient,
                          ),
                          child: Center(
                            child: Text(
                              'Bắt đầu',
                              style: context.theme.searchBigTextStyle
                                  .copyWith(color: AppColors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: AppBorderAndRadius.defaultBorderRadius,
                          color: AppColors.orange,
                        ),
                        child: Center(
                          child: Text(
                            'Gửi lời mời',
                            style: context.theme.searchBigTextStyle
                                .copyWith(color: AppColors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => AppRouter.toPage(
                            context, AppPages.MyMeetingRoom_Edit),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius:
                                AppBorderAndRadius.defaultBorderRadius,
                            color: AppColors.black99,
                          ),
                          child: Center(
                            child: Text(
                              'Chỉnh sửa',
                              style: context.theme.searchBigTextStyle.copyWith(
                                  color: AppColors.white, fontSize: 16),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
                color: context.theme.dividerDefaultColor,
              ),
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: List.generate(
                    10,
                    (index) => GestureDetector(
                      onTap: () =>
                          AppRouter.toPage(context, AppPages.MeetingRoomDetail),
                      child: Container(
                        margin: AppDimens.paddingVertical16,
                        height: 135,
                        child: Column(
                          children: [
                            Container(
                              height: 35,
                              width: MediaQuery.of(context).size.width,
                              padding: AppPadding.paddingAll8,
                              decoration: BoxDecoration(
                                borderRadius:
                                    AppBorderAndRadius.defaultBorderRadius,
                                color: AppColors.black99,
                              ),
                              child: Text(
                                'Hôm nay',
                                style: context
                                    .theme.chatConversationDropdownTextStyle
                                    .copyWith(color: AppColors.black),
                              ),
                            ),
                            Expanded(
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Container(
                                              margin: AppPadding.paddingAll8,
                                              child: Text('09:00 AM')),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Padding(
                                            padding:
                                                AppPadding.paddingVertical8,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    'Cuộc họp về vấn đề BĐS',
                                                    style: context.theme
                                                        .userListTileTextTheme
                                                        .copyWith(fontSize: 14),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Cuộc họp về vấn đề BĐS',
                                                    style: context.theme
                                                        .chatConversationDropdownTextStyle
                                                        .copyWith(fontSize: 13),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    // margin: AppDimens.paddingVertical16,
                                    height: 44,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () => AppRouter.toPage(context, AppPages.Meeting_Screen),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: AppBorderAndRadius
                                                    .defaultBorderRadius,
                                                gradient:
                                                    context.theme.gradient,
                                              ),
                                              child: Center(
                                                child: Text(
                                                  'Bắt đầu',
                                                  style: context
                                                      .theme.searchBigTextStyle
                                                      .copyWith(
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 3,
                                          child: Container(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
