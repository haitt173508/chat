

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/asset_path.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class EmojiBottomSheet extends StatefulWidget {
  // void Function<VoidCallback>() callback;
  EmojiBottomSheet({
    Key? key,
  }) : super(key: key);

  @override
  State<EmojiBottomSheet> createState() => _EmojiBottomSheetState();
}

class _EmojiBottomSheetState extends State<EmojiBottomSheet> {
  late double _width = MediaQuery.of(context).size.width;
  late double _height = MediaQuery.of(context).size.height;
  bool isHandUp = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        padding: AppDimens.paddingHorizontal16,
        height: 450,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(15),
          ),
          color: AppColors.tundora.withOpacity(0.5),
        ),
        child: Column(
          children: [
            Container(
              margin: AppDimens.paddingVertical16,
              padding: AppPadding.paddingAll16,
              height: 250,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.tundora,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          'Bảo mật',
                          style: context.theme.userListTileTextTheme.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SvgPicture.asset(Images.ic_shield)
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.black99,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: ()=>AppRouter.toPage(context, AppPages.MeetingChat_Screen),
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Trò chuyện',
                            style: context.theme.userListTileTextTheme.copyWith(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SvgPicture.asset(
                          AssetPath.chat_filled,
                          color: AppColors.white,
                        ),
                      ]),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.black99,
                  ),
                  Expanded(
                    child: Row(children: [
                      Expanded(
                        child: Text(
                          'Cài đặt cuộc họp',
                          style: context.theme.userListTileTextTheme.copyWith(
                            fontSize: 14,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                      SvgPicture.asset(Images.ic_shield)
                    ]),
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.black99,
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async{
                        await AppRouter.toPage(
                            context, AppPages.MeetingWhiteBoard_Screen);
                        Navigator.pop(context);
                      },
                      child: Row(children: [
                        Expanded(
                          child: Text(
                            'Bảng trắng',
                            style: context.theme.userListTileTextTheme.copyWith(
                              fontSize: 14,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                        SvgPicture.asset(Images.ic_board)
                      ]),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: AppColors.black99,
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async{
                        await AppRouter.toPage(context, AppPages.MeetingVoteList_Screen);
                        // Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Bỏ phiếu',
                              style: context.theme.userListTileTextTheme.copyWith(
                                fontSize: 14,
                                color: AppColors.white,
                              ),
                            ),
                          ),
                          SvgPicture.asset(
                            Images.ic_vote,
                            color: AppColors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                setState(() {
                  isHandUp = !isHandUp;
                });
              },
              child: Container(
                width: _width,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  color: AppColors.tundora,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(Images.ic_hand_up),
                    Text(
                      isHandUp ? 'Hạ tay' : 'Giơ tay',
                      style: context.theme.userListTileTextTheme.copyWith(
                        fontSize: 14,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: AppDimens.paddingVertical16,
              width: _width,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.tundora,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SvgPicture.asset(Images.ic_hand_up),
                  SvgPicture.asset(Images.ic_grinning_face),
                  SvgPicture.asset(Images.ic_surprise),
                  SvgPicture.asset(Images.ic_sad),
                ],
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Text(
                  'Hủy',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(fontSize: 16, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
