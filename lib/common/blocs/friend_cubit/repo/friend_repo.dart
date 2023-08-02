import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';

class FriendRepo {
  FriendRepo();

  final ApiClient _apiClient = ApiClient();

  Future<RequestResponse> getListRequest(int userId) =>
      _apiClient.fetch(ApiPath.listFriendRequest, data: {
        'ID': userId,
      });
  // lay danh sach ban moi
  Future<RequestResponse> getListNewFriends(int userId) => _apiClient
      .fetch(ApiPath.getListNewFriends(userId), method: RequestMethod.get);

  Future<RequestResponse> addFriend(int senderId, int chatId) =>
      ApiClient().fetch(
        ApiPath.addFriend,
        data: {
          'userId': senderId,
          'contactId': chatId,
        },
      );

  Future<RequestResponse> deleteRequestAddFriend(int senderId, int chatId) =>
      ApiClient().fetch(
        ApiPath.deleteRequestAddFriend,
        data: {
          'userId': senderId,
          'contactId': chatId,
        },
      );

  Future<RequestResponse> deleteContact(int userId, int contact) async {
    return ApiClient().fetch(ApiPath.deleteContact, data: {
      'userId': userId,
      'contactId': contact,
    });
  }
}
