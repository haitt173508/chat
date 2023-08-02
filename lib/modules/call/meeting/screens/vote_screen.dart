import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/call/meeting/widgets/vote_result.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';

class VoteScreen extends StatefulWidget {
  const VoteScreen({Key? key}) : super(key: key);

  @override
  State<VoteScreen> createState() => _VoteScreenState();
}

class _VoteScreenState extends State<VoteScreen> {
  late double _width = MediaQuery.of(context).size.width;
  late double _height = MediaQuery.of(context).size.height;
  bool hideVoter = true;
  bool multiSelection = true;
  int? votedIndex;
  int voteItemCount = 4;
  int _page = 0;
  List voted = [false, false, false, false];


  _showResult() {
    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) => VoteResult(),
    );
  }

  _buildVoteItemUnique(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          votedIndex = index;
        });
      },
      child: Container(
        height: 44,
        width: _width,
        margin: AppPadding.paddingVertical8,
        padding: AppDimens.paddingHorizontal10,
        decoration: BoxDecoration(
          borderRadius: AppBorderAndRadius.defaultBorderRadius,
          color: votedIndex == index
              ? AppColors.blueGradients2.withOpacity(0.75)
              : AppColors.black99.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Checkbox(
              tristate: true,
              shape: CircleBorder(),
              onChanged: (value) {
                setState(() {
                  votedIndex = index;
                });
              },
              value: votedIndex == index,
            ),
            Expanded(
              flex: 4,
              child: Text('Kết thúc vào lúc'),
            ),
            hideVoter
                ? Text('1')
                : Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: 40,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.lawnGreen,
                          ),
                        ),
                        Positioned(
                          right: 0,
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
      ),
    );
  }

  _buildVoteItemMulti(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          voted[index] = !voted[index];
        });
      },
      child: Container(
        height: 44,
        width: _width,
        margin: AppPadding.paddingVertical8,
        padding: AppDimens.paddingHorizontal10,
        decoration: BoxDecoration(
          borderRadius: AppBorderAndRadius.defaultBorderRadius,
          color: voted[index]
              ? AppColors.blueGradients2.withOpacity(0.75)
              : AppColors.black99.withOpacity(0.5),
        ),
        child: Row(
          children: [
            Checkbox(
              tristate: true,
              shape: CircleBorder(),
              onChanged: (value) {
                setState(() {
                  voted[index] = !voted[index];
                });
              },
              value: voted[index],
            ),
            Expanded(
              flex: 4,
              child: Text('Kết thúc vào lúc'),
            ),
            hideVoter
                ? Text('1')
                : Expanded(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          right: 40,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                        Positioned(
                          right: 20,
                          child: CircleAvatar(
                            radius: 15,
                            backgroundColor: AppColors.lawnGreen,
                          ),
                        ),
                        Positioned(
                          right: 0,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Bình chọn'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          margin: AppPadding.paddingAll16,
          height: _height,
          width: _width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'Con chó đen người ta gọi là con chó mực. Con chó vàng, người ta gọi là con chó phèn. Con chó sanh người ta gọi là con chó đẻ. Vậy con chó đỏ, người ta gọi là con chó gì?',
                style: context.theme.userListTileTextTheme
                    .copyWith(color: AppColors.black, fontSize: 16),
              ),
              Container(
                margin: AppDimens.paddingVertical16,
                child: Text(
                  'Nguyễn Văn Nam: 10:10 AM 20/10/2020',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(color: AppColors.tundora),
                ),
              ),
              Container(
                child: Text(
                  'Kết thúc vào lúc: 11:10 AM 20/10/2020',
                  style: context.theme.chatConversationDropdownTextStyle
                      .copyWith(color: AppColors.tundora),
                ),
              ),
              multiSelection
                  ? Padding(
                      padding: AppDimens.paddingVertical16,
                      child: Text(
                        'Chọn được nhiều phương án',
                        style: context.theme.chatConversationDropdownTextStyle
                            .copyWith(color: AppColors.tundora),
                      ),
                    )
                  : Container(),
              hideVoter
                  ? Text(
                      'Ẩn người bình chọn',
                      style: context.theme.chatConversationDropdownTextStyle
                          .copyWith(color: AppColors.tundora),
                    )
                  : Container(),
              TextButton(
                onPressed: () => _showResult(),
                child: Text('1 người đã bình chọn'),
              ),
              Expanded(
                child: Column(
                  children: List.generate(
                      voteItemCount,
                      (index) => multiSelection
                          ? _buildVoteItemMulti(index)
                          : _buildVoteItemUnique(index)),
                ),
              ),
              InkWell(
                onTap: () {
                  if (votedIndex != null || voted.contains(true)) {
                    AppRouter.back(context);
                  }
                },
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    borderRadius: AppBorderAndRadius.defaultBorderRadius,
                    gradient: AppColors.blueGradients,
                  ),
                  child: Center(
                    child: Text(
                      'BÌNH CHỌN',
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
    );
  }
}
