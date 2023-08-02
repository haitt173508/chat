import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/common/widgets/display_message_content.dart';
import 'package:chat_365/common/widgets/section/display_rely_message_content.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

class MessageBox extends StatelessWidget {
  const MessageBox({
    Key? key,
    required this.messageModel,
    required this.hasReplyMessage,
    required this.isSentByCurrentUser,
    required this.listUserInfoBlocs,
    this.borderRadius,
    this.width,
  }) : super(key: key);

  final SocketSentMessageModel messageModel;
  final bool hasReplyMessage;
  final bool isSentByCurrentUser;
  final BorderRadius? borderRadius;
  final Map<int, UserInfoBloc> listUserInfoBlocs;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: AppConst.maxMessageBoxWidth,
        ),
        color: context.theme.backgroundColor,
        // width: double.infinity,
        child: hasReplyMessage && messageModel.relyMessage != null
            ? DisplayRelyMessageContent(
                messageModel: messageModel,
                userInfoBloc:
                    listUserInfoBlocs[messageModel.relyMessage!.senderId] ??
                        UserInfoBloc(
                          BasicInfo(
                            id: messageModel.relyMessage!.senderId,
                            name: messageModel.relyMessage!.senderName,
                            // state: messageModel.relyMessage!.
                          ),
                        ),
              )
            : DisplayMessageContent(
                messageModel: messageModel,
                senderInfo: messageModel.type?.isMap == true
                    ? (listUserInfoBlocs[messageModel.senderId]
                            ?.state
                            .userInfo ??
                        UserInfoBloc.unknown(messageModel.senderId)
                            .state
                            .userInfo)
                    : null,
                onTapImageMessage: (image) {},
              ),
      ),
    );
  }
}
