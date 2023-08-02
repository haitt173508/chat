import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';

/// Model dùng để lưu trữ các tin nhắn nháp
class DraftModel {
  final SocketSentMessageModel? editingMessasge;
  final ApiRelyMessageModel? replyingMessage;
  final String draftContent;

  DraftModel(
    this.draftContent, {
    this.editingMessasge,
    this.replyingMessage,
  });
}
