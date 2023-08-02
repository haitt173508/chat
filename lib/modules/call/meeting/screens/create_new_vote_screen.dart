import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/call/meeting/widgets/time_limited_bottom_sheet.dart';
import 'package:chat_365/router/app_pages.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
bool pinVoteToTop = true;
class CreateNewVoteScreen extends StatefulWidget {
  const CreateNewVoteScreen({Key? key}) : super(key: key);

  @override
  State<CreateNewVoteScreen> createState() => _CreateNewVoteScreenState();
}
class _CreateNewVoteScreenState extends State<CreateNewVoteScreen> {
  // bool pinVoting = false;
  bool hideVoter = false;
  bool hideResultUntilVoted = false;
  bool chooseMultipleOptions = true;
  bool canAddOption = true;

  List<Widget> _voteItem = [];

  _buildItem(int index) {
    return OutlineTextFormField(
      decoration:
          context.theme.inputDecoration.copyWith(hintText: 'Phương án $index'),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _voteItem.add(_buildItem(1));
    _voteItem.add(_buildItem(2));
  }

  _timeLimitedPopup() {
    return showModalBottomSheet(
      isScrollControlled: true,

      backgroundColor: Colors.transparent,
      context: context,
      builder: (_) => TimeLimited(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Tạo bình chọn mới'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () =>
                AppRouter.backToPage(context, AppPages.Meeting_Screen),
            child: Text('Hoàn thành'),
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: AppDimens.paddingHorizontal16,
          shrinkWrap: true,
          children: [
            Row(
              children: [
                Checkbox(
                  value: pinVoteToTop,
                  onChanged: (value) {
                    setState(() {
                      pinVoteToTop = value!;
                    });
                  },
                ),
                Expanded(
                  child: Text('Ghim lên đầu cuộc trò chuyện'),
                ),
              ],
            ),
            Padding(
              padding: AppPadding.paddingVertical8,
              child: Text(
                'Câu hỏi',
                style:
                    context.theme.userListTileTextTheme.copyWith(fontSize: 16),
              ),
            ),
            OutlineTextFormField(
              decoration: context.theme.inputDecoration
                  .copyWith(hintText: 'Đặt câu hỏi bình chọn'),
              minLine: 3,
              maxLine: 5,
            ),
            Padding(
              padding: AppPadding.paddingVertical8,
              child: Text(
                'Phương án',
                style:
                    context.theme.userListTileTextTheme.copyWith(fontSize: 16),
              ),
            ),
            Container(
              height: _voteItem.length * 60 - 16,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(
                    _voteItem.length, (index) => _voteItem[index]),
              ),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _voteItem.add(_buildItem(_voteItem.length + 1));
                });
              },
              child: Row(
                children: [
                  SvgPicture.asset(
                    Images.ic_plus,
                    color: AppColors.primary,
                  ),
                  Expanded(
                    child: Padding(
                      padding: AppDimens.paddingHorizontal10,
                      child: Text('Thêm phương án'),
                    ),
                  )
                ],
              ),
            ),
            Divider(
              thickness: 1,
            ),
            Container(
              height: 350,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Tùy chỉnh',
                    style: context.theme.userListTileTextTheme
                        .copyWith(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () => _timeLimitedPopup(),
                    child: Text(
                      'Đặt thời hạn',
                      style: context.theme.userListTileTextTheme
                          .copyWith(fontSize: 16),
                    ),
                  ),
                  Text(
                    'Không có thời hạn',
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(fontSize: 14),
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ẩn người bình chọn',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: hideVoter,
                          onChanged: (value) {
                            setState(() {
                              hideVoter = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Ẩn kết quả khi chưa bình chọn',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: hideResultUntilVoted,
                          onChanged: (value) {
                            setState(() {
                              hideResultUntilVoted = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Chọn nhiều phương án',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: chooseMultipleOptions,
                          onChanged: (value) {
                            setState(() {
                              chooseMultipleOptions = value;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                  Divider(
                    thickness: 1,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Có thể thêm phương án',
                          style: context.theme.userListTileTextTheme
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      Transform.scale(
                        scale: 0.75,
                        child: CupertinoSwitch(
                          value: canAddOption,
                          onChanged: (value) {
                            setState(() {
                              canAddOption = value;
                            });
                          },
                        ),
                      )
                    ],
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
