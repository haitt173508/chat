import 'dart:convert';
import 'dart:isolate';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/pagination_mixin.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class ChatConversationsRepo with PaginationMixin {
  int userId;
  final ApiClient _apiClient = ApiClient();
  ValueNotifier<int> _totalRecords =
      ValueNotifier(spService.totalConversation ?? 0);

  ChatConversationsRepo(
    this.userId, {
    required int total,
  }) {
    _totalRecords.addListener(() {
      spService.saveTotalConversation(totalRecords);
    });
    totalRecords = total;
  }

  int get totalRecords => _totalRecords.value;

  set totalRecords(int value) {
    if (value != 0) {
      _totalRecords.value = value;
      logger.log(value, name: 'Set totalRecords');
    }
  }

  Future<RequestResponse> loadListConversation({
    required int countLoaded,
    int limit = AppConst.limitOfListDataLengthForEachRequest,
    bool useFastApi = false,
  }) async {
    var total = totalRecords.clamp(1, double.infinity).toInt();
    return _apiClient.fetch(
      !useFastApi ? ApiPath.chatList : ApiPath.fastChatList,
      data: {
        'userId': userId,
        'countConversation': total,
        'countConversationLoad': countLoaded.clamp(0, total),
      },
      retryTime: 1,
    );
  }

  Future<RequestResponse> deleteConversation(int conversationId) =>
      _apiClient.fetch(
        ApiPath.deleteChat,
        data: {
          'conversationId': conversationId,
          'senderId': userId,
        },
      );

  /// [favorite] 1: true, 0: false
  Future<RequestResponse> changeFavoriteConversationStatus(
    int conversationId, {
    required int favorite,
  }) =>
      _apiClient.fetch(
        ApiPath.toogleFavoriteChat,
        data: {
          'conversationId': conversationId,
          'senderId': userId,
          'isFavorite': favorite,
        },
      );

  Future<Map<int, List<SocketSentMessageModel>>>
      getListLastMessagesOfListConversations(
    List<int> conversationIds,
    List<int> displayMessage,
  ) async {
    // logger.log('$conversationIds / [${conversationIds.length}]',
    //     name: 'CheckListMsgAPI');
    var res = await ApiClient().fetch(
      ApiPath.listLastMessageOfConversation,
      data: {
        'userId': userId,
        'conversationId': json.encode(conversationIds),
        'displayMessage': json.encode(displayMessage),
      },
      baseOptions: BaseOptions(
        method: 'post',
        connectTimeout: 10000,
        receiveTimeout: 10000,
        sendTimeout: 10000,
      ),
    );

    return res.onCallBack((_) async {
      final ReceivePort receivePort = ReceivePort();

      final BuildContext context = navigatorKey.currentContext!;

      final isolate = await Isolate.spawn(_computeListLastMessage, [
        res,
        receivePort.sendPort,
        context.userInfo(),
        context.userType(),
      ]);

      final result = (await receivePort.first) as Map<int, List<SocketSentMessageModel>>;

      isolate.kill(priority: Isolate.immediate);

      return result;
    });
  }

  static _computeListLastMessage(
    List param,
  ) {
    final RequestResponse res = param[0];
    final SendPort sendPort = param[1];
    var listConversationInfo =
        List.from(json.decode(res.data)['data']['listConversation']);

    Isolate.exit(
      sendPort,
      Map<int, List<SocketSentMessageModel>>.fromIterable(
        listConversationInfo,
        key: (value) => value['conversationID'],
        value: (value) => List<SocketSentMessageModel>.from(
          (value['listMessages'] as List).map(
            (e) => SocketSentMessageModel.fromMap(
              e,
              userInfo: param[2],
              userType: param[3],
            ),
          ),
        ),
      ),
    );
  }
}
