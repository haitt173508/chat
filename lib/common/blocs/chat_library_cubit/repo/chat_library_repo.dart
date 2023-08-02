import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_response.dart';

class ChatLibraryRepo {
  final int conversationId;

  ChatLibraryRepo(this.conversationId);

  Future<RequestResponse> getLibrary({
    required int listMess,
    required int countMessage,
    int messageDisplay = 0,
  }) =>
      ApiClient().fetch(
        ApiPath.chatLibrary,
        data: {
          'conversationId': conversationId,
          'listMess': listMess,
          'countMessage': countMessage,
          'messageDisplay': messageDisplay,
        },
      );
}
