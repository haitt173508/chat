import 'package:chat_365/common/blocs/friend_cubit/cubit/friend_cubit.dart';
import 'package:chat_365/common/components/choice_dialog_item.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/widgets/chat_input_bar.dart';
import 'package:chat_365/modules/chat_conversations/bloc/chat_conversation_bloc.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Các type cần [chatInputBarKey] để trigger mode (reply, edit) tương ứng của [ChatInputBar]
class ChoiceDialogTypes {
  static copy(
    BuildContext context, {
    required String? content,
    String text = StringConst.copy,
  }) =>
      ChoiceDialogItem(
        value: text,
        onTap: () {
          if (content != null) SystemUtils.copyToClipboard(content);
        },
      );

  static reply(
    BuildContext context, {
    required ApiRelyMessageModel replyModel,
    required GlobalKey<ChatInputBarState> chatInputBarKey,
  }) =>
      ChoiceDialogItem(
        value: StringConst.reply,
        onTap: () => chatInputBarKey.currentState?.replyMessage(replyModel),
      );

  static edit(
    BuildContext context, {
    required SocketSentMessageModel message,
    required GlobalKey<ChatInputBarState> chatInputBarKey,
  }) =>
      ChoiceDialogItem(
        value: StringConst.edit,
        onTap: () => chatInputBarKey.currentState?.editMessage(message),
      );

  static delete(
    BuildContext context, {
    required ApiMessageModel message,
    required List<int> members,
  }) =>
      ChoiceDialogItem(
        value: StringConst.delete,
        onTap: () => context.read<ChatBloc>().add(
              ChatEventEmitDeleteMessage(
                message,
                members,
              ),
            ),
      );

  static forward(
    BuildContext context, {
    required SocketSentMessageModel message,
    required IUserInfo senderInfo,
    String? name,
  }) =>
      ChoiceDialogItem(
        value: StringConst.forward + (name ?? ''),
        onTap: () => AppRouterHelper.toForwardMessagePage(
          context,
          message: message,
          senderInfo: senderInfo,
        ),
      );

  static addConversationToFavorite(
    BuildContext context, {
    required int conversationId,
    required ChatConversationBloc chatConversationBloc,
    bool isReversed = false,
  }) =>
      ChoiceDialogItem(
        value: StringConst.addToFavorite,
        onTap: () {
          AppDialogs.showConfirmDialog(
            context,
            title: 'Thêm cuộc trò chuyện vào danh sách yêu thích ?',
            nameFunction: 'Thêm',
            onFunction: (_) => chatConversationBloc.changeFavoriteConversation(
              conversationId,
              favorite: 1,
            ),
            isReversed: false,
            successMessage: 'Thêm vào yêu thích thành công',
          );
          ;
        },
      );

  static removeConversationToFavorite(
    BuildContext context, {
    required int conversationId,
    required ChatConversationBloc chatConversationBloc,
  }) =>
      ChoiceDialogItem(
        value: StringConst.removeFromFavorite,
        onTap: () {
          AppDialogs.showConfirmDeleteDialog(
            context,
            title: 'Xóa cuộc trò chuyện khỏi danh sách yêu thích',
            onDelete: (_) => chatConversationBloc.changeFavoriteConversation(
              conversationId,
              favorite: 0,
            ),
            successMessage: 'Xóa thành công',
          );
          ;
        },
      );

  static deleteConversation(
    BuildContext context, {
    required int conversationId,
    required ChatConversationBloc chatConversationBloc,
  }) =>
      ChoiceDialogItem(
        value: StringConst.deleteConversation,
        onTap: () => AppDialogs.showConfirmDeleteDialog(
          context,
          title: 'Xóa cuộc trò chuyện trên Chat365',
          successMessage: 'Xóa cuộc trò chuyện thành công',
          content: Padding(
            padding: const EdgeInsets.symmetric(vertical: 35),
            child: Text(
              'Bạn có chắc chắn muốn xóa cuộc trò chuyện này?',
              textAlign: TextAlign.center,
              style: AppTextStyles.regularW400(
                context,
                size: 14,
                lineHeight: 20,
              ),
            ),
          ),
          onDelete: (_) =>
              chatConversationBloc.deleteConversation(conversationId),
          onError: (error) => AppDialogs.toast(error.toString()),
        ),
      );

  static markReadAllMessage(
    BuildContext context, {
    required int conversationId,
    required List<int> members,
  }) =>
      ChoiceDialogItem(
        value: StringConst.markAsRead,
        onTap: () => context.read<ChatBloc>().markReadMessages(
              senderId: context.userInfo().id,
              conversationId: conversationId,
              memebers: members,
            ),
      );

  static pinMessage(
    BuildContext context, {
    required String messageId,
    required String messageContent,
  }) =>
      ChoiceDialogItem(
        value: StringConst.pinMessage,
        onTap: () {
          context.read<ChatDetailBloc>().pinMessage(
                messageId,
                messageContent,
              );
        },
      );

  static deleteContact(BuildContext context, int contact) {
    var friendCubit = context.read<FriendCubit>();
    return ChoiceDialogItem(
      value: StringConst.deleteContact,
      onTap: () {
        AppDialogs.showConfirmDialog(
          context,
          title: 'Xóa liên hệ',
          nameFunction: 'Xóa',
          onFunction: (_) => friendCubit.deleteContact(contact),
          successMessage: 'Xóa liên hệ thành công',
          content: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text('Bạn có chắc muốn xóa liên hệ này ?'),
          ),
        );
      },
    );
  }

  static save(
    BuildContext context, {
    required ApiFileModel file,
    String? messageId,
  }) {
    return ChoiceDialogItem(
      value: StringConst.save,
      onTap: () async {
        var savePath = await SystemUtils.prepareSaveDir();
        if (savePath == null)
          return AppDialogs.toast('Tạo đường dẫn tải file thất bại');
        SystemUtils.downloadFile(
          file.fullFilePath,
          savePath,
          fileName: file.fileName,
          messageId: messageId,
        );
      },
    );
  }
}
