import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VideoCallDisplay extends StatelessWidget {
  const VideoCallDisplay({
    Key? key,
    required this.messageModel,
  }) : super(key: key);
  final SocketSentMessageModel messageModel;

  @override
  Widget build(BuildContext context) {
    var isSentByCurrentUser = messageModel.senderId == context.userInfo().id;
    var messageType = messageModel.type!;
    return SizedBox(
      width: 180,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: AppColors.grayE6E9FD,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              Text(
                messageModel.type!.displayMessageType(
                  null,
                  isSentByCurrentUser: isSentByCurrentUser,
                ),
                style: AppTextStyles.regularW700(
                  context,
                  size: 14,
                  lineHeight: 19,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SvgPicture.asset(
                    messageType.videoCallDisplayMessageIconAssetPath(
                      isSendByCurrentUser: isSentByCurrentUser,
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (messageType == MessageType.rejectVideoCall)
                    Text(
                      isSentByCurrentUser
                          ? 'Bạn đã từ chối'
                          : 'Người nhận từ chối',
                      style: AppTextStyles.regularW400(
                        context,
                        size: 14,
                        lineHeight: 16,
                        color: AppColors.doveGray,
                      ),
                    ),
                ],
              ),
              // const SizedBox(height: 12),
              Divider(
                color: AppColors.greyCC,
                thickness: 1,
                height: 24,
              ),
              InkWell(
                onTap: () {},
                child: Text(
                  'GỌI LẠI',
                  style: AppTextStyles.regularW700(
                    context,
                    size: 14,
                    lineHeight: 19,
                    color: context.theme.primaryColor,
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
