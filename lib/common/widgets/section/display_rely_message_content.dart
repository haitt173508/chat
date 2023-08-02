import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_state.dart';
import 'package:chat_365/common/widgets/reply_message_builder.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DisplayRelyMessageContent extends StatelessWidget {
  const DisplayRelyMessageContent({
    Key? key,
    required this.messageModel,
    required this.userInfoBloc,
  }) : super(key: key);

  final UserInfoBloc userInfoBloc;
  final SocketSentMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    var quoteMsg = messageModel.relyMessage!;
    var isSentByCurrentUser = messageModel.senderId == context.userInfo().id;
    var textColor = isSentByCurrentUser
        ? AppColors.white
        : context.theme.replyOriginTextStyle.color;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSentByCurrentUser ? null : context.theme.messageBoxColor,
        gradient: isSentByCurrentUser ? context.theme.gradient : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<UserInfoBloc, UserInfoState>(
              bloc: userInfoBloc,
              builder: (context, state) {
                final replyModel = ApiRelyMessageModel(
                  senderName: state.userInfo.name,
                  message: quoteMsg.message,
                  createAt: quoteMsg.createAt,
                  messageId: quoteMsg.messageId,
                  senderId: quoteMsg.senderId,
                );
                return ReplyMessageBuilder(
                  replyModel: replyModel,
                  originMessageTextColor: textColor,
                  replyInfoTextColor: textColor,
                );
              }),
          Divider(
            color: textColor,
            height: 16,
            thickness: 1,
          ),
          Text(
            messageModel.message ?? StringConst.canNotDisplayMessage,
            style: context.theme.messageTextStyle.copyWith(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
