import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';

class ChatDetailRepo {
  /// Id người dùng hiện tại
  final int userId;

  ChatDetailRepo(this.userId);

  Future<RequestResponse> loadConversationDetail(int conversationId) => ApiClient().fetch(ApiPath.chatInfo, data: {
        "conversationId": conversationId,
        "senderId": userId,
      });

  Future<RequestResponse> changePassword({required String email, required int type365, required String newPassword, required String oldPassword}) =>
      ApiClient().fetch(ApiPath.changePassword, data: {
        "Email": email,
        "type365": type365.toString(),
        "newPassword": newPassword,
        "oldPassword": oldPassword,
      });

  Future<RequestResponse> loadListMessage(
    int conversationId, {
    // Tổng số tin đã load
    required int loadedMessages,

    /// Tổng số tin nhắn
    required int totalMessages,
    int? messageDisplay,
  }) =>
      ApiClient().fetch(
        ApiPath.chatDetail,
        data: {
          "conversationId": conversationId,
          "listMess": loadedMessages,
          "countMessage": totalMessages,
          "messageDisplay": messageDisplay,
        },
      );

  /// [favorite] 1: true, 0: false
  Future<RequestResponse> changeFavoriteConversationStatus(
    int conversationId, {
    required int favorite,
  }) =>
      ApiClient().fetch(
        ApiPath.toogleFavoriteChat,
        data: {
          'conversationId': conversationId,
          'senderId': userId,
          'isFavorite': favorite,
        },
      );

  Future<RequestResponse> getMessage(String value) => ApiClient().fetch(ApiPath.getMessage, data: {
        'MessageID': value,
      });

  Future<RequestResponse> getDetailInfo(int idChat, int type) => ApiClient().fetch(ApiPath.get_detail_info,
      data: {
        'id_chat': idChat,
        'type': type,
      },
      method: RequestMethod.post);
}
