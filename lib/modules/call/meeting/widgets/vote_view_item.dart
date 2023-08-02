import 'dart:ui';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class VoteViewItem extends StatefulWidget {
  const VoteViewItem({Key? key}) : super(key: key);

  @override
  State<VoteViewItem> createState() => _VoteViewItemState();
}

class _VoteViewItemState extends State<VoteViewItem> {
  int? votedIndex = 1;
  int? votedTemp;
  bool hideVoter = true;
  int _voteItemCount = 4;

  _buildVoteItem(int index) {
    return Container(
      height: 44,
      padding: AppDimens.paddingHorizontal10,
      decoration: BoxDecoration(
        borderRadius: AppBorderAndRadius.defaultBorderRadius,
        color: votedIndex == index
            ? AppColors.blueGradients2.withOpacity(0.75)
            : AppColors.black99.withOpacity(0.5),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              'Kết thúc vào lúc',
            ),
          ),
          hideVoter
              ? Text('1')
              : Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Positioned(
                        left: 0,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.primary,
                        ),
                      ),
                      Positioned(
                        left: 20,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.lawnGreen,
                        ),
                      ),
                      Positioned(
                        left: 40,
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: AppColors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _voteOption() {
    return showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => Container(
        margin: AppDimens.paddingHorizontal16,
        height: 280,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              // height: 200,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Tùy chọn'),
                  SizedBox(
                    height: 44,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {},
                      child: Text('Ghim lên đầu cuộc trò chuyện',
                          style: TextStyle(fontSize: 14)),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 44,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await AppDialogs.showConfirmDialog(
                          context,
                          title: 'Khóa bình chọn',
                          onFunction: (value) {},
                          nameFunction: 'Đồng ý',
                          successMessage: 'Khóa thành công',
                          content: Padding(
                            padding: AppPadding.paddingVertical30,
                            child:
                            Text('Bạn có chắc chắn muốn khóa bình chọn này?'),
                          ),
                        );
                        Navigator.pop(_);
                      },
                      child: Text(
                        'Khóa bình chọn',
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  SizedBox(
                    height: 44,
                    child: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () async {
                        await AppDialogs.showConfirmDeleteDialog(
                          context,
                          title: 'Xóa bình chọn',
                          onDelete: (value) {},
                          successMessage: 'Xóa thành công',
                          content: Padding(
                            padding: AppPadding.paddingVertical30,
                            child:
                            Text('Bạn có chắc chắn muốn xóa bình chọn này?'),
                          ),
                        );
                        Navigator.pop(_);
                      },
                      child: Text(
                        'Xóa bình chọn',
                        style: context.theme.userListTileTextTheme
                            .copyWith(color: AppColors.error, fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: AppPadding.paddingVertical8,
              decoration: BoxDecoration(
                borderRadius: AppBorderAndRadius.defaultBorderRadius,
                color: AppColors.white,
              ),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.pop(_),
                child: Text('Hủy'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: AppPadding.paddingVertical8,
      padding: AppPadding.paddingVertical8,
      height: _voteItemCount >= 3 ? 480 : 450,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: AppBorderAndRadius.defaultBorderRadius,
        color: AppColors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              radius: 30,
              backgroundColor: AppColors.orange,
            ),
            title: Text(
              'Nguyễn Văn Nam',
              style: context.theme.userListTileTextTheme
                  .copyWith(color: AppColors.black, fontSize: 14),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Đã tạo 1 bình chọn',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(color: AppColors.tundora),
                ),
                Text(
                  '10:10 AM 20/10/2020',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(color: AppColors.tundora),
                ),
              ],
            ),
            trailing: IconButton(
              onPressed: _voteOption,
              icon: SvgPicture.asset(
                Images.ic_more_hoz,
                color: AppColors.black,
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Expanded(
            child: Padding(
              padding: AppDimens.paddingHorizontal16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Con chó đen người ta gọi là con chó mực. Con chó vàng, người ta gọi là con chó phèn. Con chó sanh người ta gọi là con chó đẻ. Vậy con chó đỏ, người ta gọi là con chó gì?',
                    style: context.theme.userListTileTextTheme
                        .copyWith(color: AppColors.black, fontSize: 16),
                  ),
                  Text(
                    'Kết thúc vào lúc: 10:10 AM 20/10/2020',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(color: AppColors.tundora),
                  ),
                  hideVoter
                      ? Text(
                          'Ẩn người bình chọn',
                          style: context.theme.chatConversationDropdownTextStyle
                              .copyWith(color: AppColors.tundora),
                        )
                      : Container(),
                  TextButton(
                    onPressed: () {},
                    child: Text('1 người đã bình chọn'),
                  ),
                  _buildVoteItem(0),
                  _buildVoteItem(1),
                  _voteItemCount >= 3 ? _buildVoteItem(2) : Container(),
                  _voteItemCount > 3
                      ? TextButton(
                          onPressed: () {},
                          child: Text('Xem thêm bình chọn'),
                        )
                      : Container(),
                  InkWell(
                    onTap: () =>AppRouter.toPage(context, AppPages.MeetingVote_Screen),
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        borderRadius: AppBorderAndRadius.defaultBorderRadius,
                        gradient: AppColors.blueGradients,
                      ),
                      child: Center(
                        child: Text(
                          votedIndex == null ? 'BÌNH CHỌN' : 'ĐỔI BÌNH CHỌN',
                          style: context.theme.searchBigTextStyle
                              .copyWith(color: AppColors.white, fontSize: 14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
