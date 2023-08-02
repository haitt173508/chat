import 'dart:ui';

import 'package:chat_365/common/images.dart';
import 'package:chat_365/common/widgets/form/outline_text_form_field.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_dimens.dart';
import 'package:chat_365/modules/call/meeting/screens/create_new_vote_screen.dart';
import 'package:chat_365/modules/call/meeting/widgets/vote_view_item.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MeetingChatScreen extends StatefulWidget {
  const MeetingChatScreen({Key? key}) : super(key: key);

  @override
  State<MeetingChatScreen> createState() => _MeetingChatScreenState();
}

class _MeetingChatScreenState extends State<MeetingChatScreen> {
  bool notification = true;
  late List chatBox = [
    _chatItem('Nguyễn Văn Nam', 'tất cả mọi người',
        'Wikipedia tiếng Việt. Bạn chính là tác giả của Wikipedia. 1.274.544 '),
    _chatItem('Tôi', 'tất cả mọi người',
        'Wikipedia tiếng Việt. Bạn chính là tác giả của Wikipedia. 1.274.544 bài viết và 873.795 thành viên. 1.274.544 bài viết và 873.795 thành viên.'),
    _chatItem('Nguyễn Văn Nam', 'tất cả mọi người', 'file'),
  ];

  Widget _voteView= VoteViewItem();

  _chatItem(String sender, String receiver, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          child: RichText(
            textAlign: sender == 'Tôi' ? TextAlign.right : TextAlign.left,
            text: TextSpan(
                style: context.theme.chatConversationDropdownTextStyle,
                children: [
                  TextSpan(text: sender),
                  TextSpan(text: ' tới '),
                  TextSpan(
                    text: receiver,
                    style: context.theme.chatConversationDropdownTextStyle
                        .copyWith(color: AppColors.primary),
                  ),
                ]),
          ),
        ),
        Container(
          margin: AppPadding.paddingVertical8,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sender == 'Tôi'
                  ? SizedBox.shrink()
                  : CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.orange,
                    ),
              Expanded(
                child: Container(
                  padding: AppPadding.paddingAll16,
                  margin: AppDimens.paddingHorizontal16,
                  decoration: BoxDecoration(
                    color: AppColors.tundora.withOpacity(0.1),
                    borderRadius: AppBorderAndRadius.defaultBorderRadius,
                  ),
                  child: Text(
                    content,
                    style: context.theme.chatConversationDropdownTextStyle,
                  ),
                ),
              ),
              sender != 'Tôi'
                  ? SizedBox.shrink()
                  : CircleAvatar(
                      radius: 15,
                      backgroundColor: AppColors.orange,
                    ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text('Trò chuyện'),
        centerTitle: true,
        actions: [
          notification
              ? IconButton(
                  onPressed: () => AppDialogs.showConfirmDialog(
                    context,
                    title: 'Tắt tiếng thông báo',
                    onFunction: (a) {
                      setState(() {
                        notification = false;
                      });
                    },
                    successMessage: '',
                    nameFunction: 'TẮT TIẾNG',
                    content: Padding(
                      padding: AppPadding.paddingVertical30,
                      child: Text(
                        'Bạn sẽ không nhìn thấy bất kỳ thông báo trò chuyện nào trong phiên này?',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  icon: SvgPicture.asset(
                    Images.ic_bell,
                    color: AppColors.blueGradients2,
                  ),
                )
              : IconButton(
                  onPressed: () => AppDialogs.showConfirmDialog(
                    context,
                    title: 'Bỏ tắt tiếng thông báo',
                    onFunction: (a) {
                      setState(() {
                        notification = true;
                      });
                    },
                    successMessage: '',
                    nameFunction: 'BỎ TẮT TIẾNG',
                    content: Padding(
                      padding: AppPadding.paddingVertical30,
                      child: Text(
                        'Bạn sẽ nhìn thấy các thông báo xem trước trò chuyện trong phiên này?',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  icon: SvgPicture.asset(
                    Images.ic_notifications_off,
                    color: AppColors.blueGradients2,
                  ),
                ),
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          padding: AppDimens.paddingALl16,
          // reverse: true,
          itemCount: pinVoteToTop?chatBox.length+1:chatBox.length,
          itemBuilder: (_, index) => pinVoteToTop?index==0?_voteView:chatBox[index-1]:chatBox[index],
        ),
      ),
      bottomSheet: Container(
        // height: 100,
        padding: AppDimens.paddingHorizontal16,
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.black99)),
          color: Colors.transparent
        ),
        child: IntrinsicHeight(
          child: Column(
            children: [
              Row(
                children: [
                  Text('Gửi đến: '),
                  TextButton(
                    onPressed: () {},
                    child: Row(
                      children: [
                        Text('Mọi người'),
                        SvgPicture.asset(
                          Images.ic_arrow_down,
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: OutlineTextFormField(
                      decoration: context.theme.inputDecoration.copyWith(
                        hintText: 'Nhập...',
                        suffixIcon: SvgPicture.asset(Images.ic_emoji,),
                        suffix: Padding(padding: AppDimens.paddingHorizontal10),
                      ),
                      minLine: 1,
                      maxLine: 5,
                    ),
                  ),
                  const SizedBox(width: 8,),
                  Container(
                    height: 44,
                    width: 44,
                    padding: AppPadding.paddingAll8,
                    decoration: BoxDecoration(
                      borderRadius: AppBorderAndRadius.defaultBorderRadius,
                      gradient: AppColors.blueGradients,
                    ),
                    child: SvgPicture.asset(Images.ic_send,color: AppColors.white,),
                  ),
                ],
              ),
              const SizedBox(height: 8,),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}
