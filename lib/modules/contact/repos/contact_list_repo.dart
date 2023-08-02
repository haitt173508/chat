import 'dart:convert';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/chat_conversations/repo/chat_conversations_repo.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ContactListRepo {
  final ApiClient _client;
  final ChatConversationsRepo _conversationsRepo;

  final int userId;
  final int companyId;

  ContactListRepo(
    this.userId, {
    required this.companyId,
  })  : _conversationsRepo = ChatConversationsRepo(userId,
            total: spService.totalConversation ?? 0),
        _client = ApiClient();

  Future<List<ApiContact>> getMyContact() async {
    final RequestResponse res = await _client.fetch(
      ApiPath.myContacts,
      data: {
        'ID': userId,
      },
    );

    return (json.decode(res.data)['data']['user_list'] as List)
        .map((e) => ApiContact.fromMyContact(e))
        .toList();
  }

  static final emptyContactRequestResponse = RequestResponse(
    '"data":{"user_list": []}',
    true,
    200,
  );

  Future<List<ApiContact>> getAllContactsInCompany(
    int companyId,
  ) async {
    if (companyId == 0) return [];
    final RequestResponse res = await _client.fetch(
      ApiPath.allContactsInCompany,
      data: {
        'ID': userId,
        'CompanyID': companyId,
      },
    );

    return await compute(_computeGetAllContactsInCompany, res);
  }

  static List<ApiContact> _computeGetAllContactsInCompany(
          RequestResponse res) =>
      (json.decode(res.data)['data']['user_list'] as List)
          .map((e) => ApiContact.fromMyContact(e))
          .toList();

  Future<RequestResponse> searchContactInCompany(String keyword) =>
      companyId == 0
          ? Future.value(emptyContactRequestResponse)
          : _client.fetch(
              ApiPath.searchContactInCompany,
              data: {
                'message': keyword,
                'senderId': userId,
                'companyId': companyId,
              },
            );

  Future<RequestResponse> searchContact(String keyword) => _client.fetch(
        ApiPath.searchContact,
        data: {
          'message': keyword,
          'senderId': userId,
          'companyId': companyId,
        },
      );

  Future<RequestResponse> getUserInfo(int id) => ApiClient().fetch(
        ApiPath.getUserInfo,
        data: {'ID': id},
        options: Options(
          receiveTimeout: 500,
        ),
      );

  /// Gọi tất cả các cuộc trò chuyện hiện tại api [GetListConversation]
  Future<List<ConversationBasicInfo>> getAllContact({
    bool groupOnly = false,
    List<ConversationBasicInfo> initCoversation = const [],
  }) async {
    var list = initCoversation;

    while (list.length < _conversationsRepo.totalRecords) {
      var res = await _conversationsRepo.loadListConversation(
        countLoaded: list.length,
      );
      try {
        list.addAll(await res.onCallBack((_) {
          var listResult = <ConversationBasicInfo>[];
          for (var e
              in (json.decode(res.data)['data']['listCoversation'] as List)) {
            final model = ChatItemModel.fromConversationInfoJsonOfUser(
              _conversationsRepo.userId,
              conversationInfoJson: e,
            );
            listResult.add(model.conversationBasicInfo);
          }
          return listResult;
        }));
      } on CustomException catch (e) {
        if (e.error.isExceedListConversation) break;
        rethrow;
      }
    }
    if (groupOnly) list.removeWhere((e) => !e.isGroup);
    return list;
  }

  Future<List<ConversationBasicInfo>> searchGroup(String keyword) async {
    var list = <ConversationBasicInfo>[];

    var res = await _client.fetch(
      ApiPath.searchListConversation,
      data: {
        'senderId': userId,
        'message': keyword,
      },
    );
    try {
      list.addAll(await res.onCallBack((_) {
        var listResult = <ConversationBasicInfo>[];
        for (var e
            in (json.decode(res.data)['data']['listCoversation'] as List)) {
          final model = ChatItemModel.fromConversationInfoJsonOfUser(
            _conversationsRepo.userId,
            conversationInfoJson: e,
          );
          listResult.add(model.conversationBasicInfo);
        }
        return listResult;
      }));
    } on CustomException catch (_) {
      rethrow;
    }
    return list;
  }

  Future<RequestResponse> searchAll(
    String keyword,
  ) =>
      ApiClient().fetch(
        ApiPath.searchAll,
        data: {
          'message': keyword,
          'senderId': userId,
          'companyId': companyId,
        },
      );

  Future<RequestResponse> searchConversations(
    String keyword, {
    int chunk = 20,
    int countLoaded = 0,
  }) =>
      ApiClient().fetch(
        ApiPath.searchConversations,
        data: {
          'userId': userId,
          'companyId': companyId,
          'message': keyword,
          'countConversation': chunk,
          'countConversationLoad': countLoaded,
        },
      );
}

// class SearchContactWithConversation {
//   final String keywords;
//   final ConversationBasicInfo contact;

//   SearchContactWithConversation(
//     this.keywords,
//     this.contact,
//   );

//   factory SearchContactWithConversation.fromConversation(ChatItemModel model) =>
//       SearchContactWithConversation(
//         model.conversationBasicInfo.name.toEngAlphabetString(),
//         model.conversationBasicInfo,
//       );

//   @override
//   String toString() => contact.name.toEngAlphabetString();
// }
