import 'dart:convert';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:contacts_service/contacts_service.dart';

class SuggestContactRepo {
  final IUserInfo userInfo;

  SuggestContactRepo(this.userInfo);

  Future<RequestResponse> getSuggestChatUsersFromContacts(
    List<Contact> contacts,
  ) async {
    return await ApiClient().fetch(
      ApiPath.searchContactByPhone,
      data: {
        'phone': json.encode(contacts.map((e) => e.phones?[0].value).toList()),
        // 'phone': json.encode(["0331237863", "0984471022"]),
        'userId': userInfo.id,
        'companyId': userInfo.companyId,
      },
    );
  }

  Future<RequestResponse> getAddFriendRequestBasicInfo() => ApiClient().fetch(
        ApiPath.getAddFriendRequestBasicInfo,
        data: {
          // 'phone': json.encode(contacts.map((e) => e.phones?[0].value).toList()),
          'ID': userInfo.id,
        },
      );
}
