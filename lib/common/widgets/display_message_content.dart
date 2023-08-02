import 'dart:io';

import 'package:chat_365/common/widgets/apply_message_display.dart';
import 'package:chat_365/common/widgets/display_contact.dart';
import 'package:chat_365/common/widgets/file_display.dart';
import 'package:chat_365/common/widgets/link_display.dart';
import 'package:chat_365/common/widgets/map_display.dart';
import 'package:chat_365/common/widgets/section/image_display.dart';
import 'package:chat_365/common/widgets/text_message_display.dart';
import 'package:chat_365/common/widgets/video_call_display.dart';
import 'package:chat_365/common/widgets/widget_slider.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Hiển thị message theo [MessageType] khác nhau
///
/// [files] là các file đính kèm 1 message
class DisplayMessageContent extends StatelessWidget {
  const DisplayMessageContent({
    Key? key,
    required this.onTapImageMessage,
    required this.messageModel,
    this.senderInfo,
  }) : super(key: key);

  final SocketSentMessageModel messageModel;
  final IUserInfo? senderInfo;

  /// Callback navigate đến [WidgetSlider] hiển các ảnh trong conversation hiện tại
  final ValueChanged<ApiFileModel> onTapImageMessage;

  // @override
  //   decoration: BoxDecoration(
  //   color: messageModel.type!.isImage
  //       ? null
  //       : _isSentByCurrentUser
  //           ? AppColors.indigo
  //           : AppColors.greyCC,
  //   borderRadius: BorderRadius.circular(20),
  // ),

  Widget build(BuildContext context) {
    final Widget child;
    final MessageType? messageType = messageModel.type;
    final IUserInfo? contact = messageModel.contact;
    final bool isSentByCurrentUser =
        messageModel.senderId == context.userInfo().id;
    final List<ApiFileModel>? files = messageModel.files;
    final String? message = messageModel.message;
    final InfoLink? infoLink = messageModel.infoLink;

    if ((messageType?.isContactCard ?? false) && contact != null) {
      child = DisplayContact(
        contact: contact,
        isSendByCurrentUser: isSentByCurrentUser,
      );
    }

    /// File
    else if (files != null) {
      if (files.isEmpty) {
        return TextDisplay(
          isSentByCurrentUser: isSentByCurrentUser,
          message: StringConst.canNotDisplayFile,
        );
      }

      /// Ảnh
      if (files.every((e) => e.fileType == MessageType.image)) {
        var imagePlaceholder = context
            .read<ChatBloc>()
            .cachedMessageImageFile[messageModel.messageId];

        child = Directionality(
          textDirection:
              isSentByCurrentUser ? TextDirection.rtl : TextDirection.ltr,
          child: files.length == 1
              ? ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: context.mediaQuerySize.height * 1 / 2,
                  ),
                  // width: 120,
                  // height: 150,
                  child: InkWell(
                    onTap: () => onTapImageMessage(files[0]),
                    child: ImageDisplay(
                      file: files[0],
                      placeholder: !imagePlaceholder.isBlank &&
                              imagePlaceholder![0].filePath != null
                          ? File(imagePlaceholder[0].filePath!)
                          : null,
                      messageModel: messageModel,
                    ),
                  ),
                )
              : GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 1,
                    crossAxisSpacing: 2,
                    mainAxisSpacing: 2,
                    mainAxisExtent: 120,
                  ),
                  addRepaintBoundaries: true,
                  addAutomaticKeepAlives: true,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: files.length.clamp(0, 4),
                  itemBuilder: (_, index) {
                    var e = files[index];
                    var p = imagePlaceholder?[index];
                    return ImageDisplay(
                      file: e,
                      placeholder: p != null ? File(p.filePath!) : null,
                      fit: BoxFit.contain,
                      messageModel: messageModel.copyWith(files: [e]),
                      cachedSize: 500,
                      remain: index == 2 && files.length > 4
                          ? files.length - index - 2
                          : 0,
                    );
                  },
                ),
        );
      }

      /// File
      else if (files.every((e) => e.fileType.isFile)) {
        child = Wrap(
          spacing: 10,
          runSpacing: 10,
          children: files
              .map(
                (e) => FileDisplay(
                  file: e,
                  messageId: messageModel.messageId,
                ),
              )
              .toList(),
        );
      } else {
        child = TextDisplay(
          message: StringConst.canNotDisplayFile,
          isSentByCurrentUser: isSentByCurrentUser,
        );
      }
    }

    /// Text
    else if (messageType?.isText == true && !message.isBlank) {
      child = TextDisplay(
        isSentByCurrentUser: isSentByCurrentUser,
        message: message,
        sentTime: messageModel.createAt,
      );
    }

    /// Link
    else if ((messageType?.isLink ?? false)) {
      if (infoLink != null)
        child = LinkDisplay(
          infoLink: infoLink,
          link: message,
        );
      else
        return TextDisplay(
          message: message,
          isSentByCurrentUser: isSentByCurrentUser,
        );

      /// Map
    } else if (messageType?.isMap ?? false) {
      child = MapDisplay(
        infoLink: infoLink,
        senderInfo: senderInfo!,
      );
    }

    /// Notification
    // else if (messageType?.isNotification ?? false) {
    //   child = NotificationMessageDisplay(
    //     listUserInfos: listUserInfos,
    //     message: message,
    //   );
    // }

    else if (messageType?.isVideoCall == true) {
      child = VideoCallDisplay(
        messageModel: messageModel,
      );
    } else if (messageType?.isApplying == true ||
        messageType?.isOfferRecieved == true ||
        messageType?.isDocument == true) {
      child = ApplyMessageDisplay(
        link: messageModel.linkNotification,
        isSentByCurrentUser: isSentByCurrentUser,
        content: message ?? '',
        infoLink: infoLink,
      );
    }

    /// Khác, không xác định
    else {
      child = InkWell(
        onTap: () =>
            Clipboard.setData(ClipboardData(text: messageModel.toString())),
        child: TextDisplay(
          isSentByCurrentUser: isSentByCurrentUser,
          message: StringConst.canNotDisplayMessage,
        ),
      );
    }

    return child;
  }
}
