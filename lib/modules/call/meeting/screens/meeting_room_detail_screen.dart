import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class MeetingRoomDetailScreen extends StatefulWidget {
  const MeetingRoomDetailScreen({Key? key}) : super(key: key);

  @override
  State<MeetingRoomDetailScreen> createState() =>
      _MeetingRoomDetailScreenState();
}

class _MeetingRoomDetailScreenState extends State<MeetingRoomDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết cuộc họp'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () =>
                AppRouter.toPage(context, AppPages.MeetingSchedule_Edit),
            child: Text('Chỉnh sửa'),
          )
        ],
      ),
      body: SafeArea(
        child: ListView(
          shrinkWrap: true,
          padding: AppDimens.paddingHorizontal16,
          children: [
            Container(
              height: 260,
              margin: AppDimens.paddingVertical16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(children: [
                      Text(
                        'Chủ đề',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          'Cuộc họp về vấn đề BĐS,Cuộc họp về vấn đề BĐS,Cuộc họp về vấn đề BĐS,',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(children: [
                      Text(
                        'Thời gian',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          '23/07/2022 - 09:00 AM',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(children: [
                      Text(
                        'ID cuộc họp',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          '123 456 7890',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(children: [
                      Text(
                        'Thời lượng',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          '30 phút',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: context.theme.dividerDefaultColor,
                  ),
                  Expanded(
                    child: Row(children: [
                      Text(
                        'Mật mã',
                        style: context.theme.userListTileTextTheme
                            .copyWith(fontSize: 14),
                      ),
                      Expanded(
                        child: Text(
                          'abcxyz',
                          style:
                              context.theme.chatConversationDropdownTextStyle,
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ]),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => AppRouter.toPage(context, AppPages.Meeting_Screen),
              child: Container(
                height: 44,
                width: MediaQuery.of(context).size.width,
                margin: AppPadding.paddingVertical8,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  gradient: context.theme.gradient,
                ),
                child: Center(
                  child: Text(
                    'Bắt đầu',
                    style: context.theme.userListTileTextTheme
                        .copyWith(fontSize: 14, color: AppColors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 44,
              width: MediaQuery.of(context).size.width,
              margin: AppPadding.paddingVertical8,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.orange,
              ),
              child: Center(
                child: Text(
                  'Sao chép lời mời',
                  style: context.theme.userListTileTextTheme
                      .copyWith(fontSize: 14, color: AppColors.white),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => AppDialogs.showConfirmDeleteDialog(
                context,
                title: 'Xóa cuộc họp',
                onDelete: (value) {},
                successMessage: 'Xóa thành công',
                content: Padding(
                  padding: AppPadding.paddingVertical30,
                  child: Text('Bạn có chắc chắn muốn xóa cuộc họp này?'),
                ),
              ),
              child: Container(
                height: 44,
                width: MediaQuery.of(context).size.width,
                margin: AppPadding.paddingVertical8,
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.red),
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  color: context.theme.inputDecoration.fillColor,
                ),
                child: Center(
                  child: Text(
                    'Xóa',
                    style: context.theme.userListTileTextTheme
                        .copyWith(fontSize: 14, color: AppColors.red),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
