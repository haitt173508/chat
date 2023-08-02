import 'dart:convert';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';

import 'models/group_conversation_creation_kind.dart';

class ConversationCreationRepo {
  final ApiClient _apiClient;

  ConversationCreationRepo() : _apiClient = ApiClient();

  /// return group id if success
  Future<int> createGroup({
    required GroupConversationCreationKind groupKind,
    required String name,
    required List<int> memberIds,
  }) async {
    try {
      var userId = navigatorKey.currentContext!.userInfo().id;

      final resolvedMemberIds = [userId, ...memberIds];

      final RequestResponse res = await _apiClient.fetch(
        ApiPath.createGroupChat,
        data: {
          'senderId': userId,
          'typeGroup': groupKind.serverName,
          'conversationName': name,
          'memberList': resolvedMemberIds.toString(),
        },
      );

      if (res.hasError) throw res.error!.messages!;

      final id =
          json.decode(res.data)['data']['conversation_info']['conversationId'];

      return id;
    } catch (e) {
      rethrow;
    }
  }

  Future<RequestResponse> listLoginHistory(
    int? idUser,
  ) =>
      _apiClient.fetch(
        ApiPath.list_login_history + "${idUser}",
        method: RequestMethod.get,
      );

// Future<bool> createChat({
//   required int contactId,
// }) async {
//   final RequestResponse res = await _client.fetch(
//     ApiPath.createChat,
//     RequestMethod.post,
//     data: {
//       'userId': AuthRepo.id,
//       'contactId': contactId,
//     },
//   );
// }
}
