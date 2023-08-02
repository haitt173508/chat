import 'dart:async';
import 'dart:convert';

import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/constants/status_code.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ChatRepo {
  final ApiClient _client = ApiClient();

  ChatRepo() {
    chatClient
      ..on(
        ChatSocketEvent.messageSent,
        (recieveMsg) {
          var socketSentMessageModel =
              SocketSentMessageModel.fromMapOfSocket(recieveMsg);
          if ((socketSentMessageModel.type?.isLink == true ||
                  socketSentMessageModel.type?.isMap == true) &&
              socketSentMessageModel.infoLink == null) return;
          _controller.sink
              .add(ChatEventOnRecievedMessage(socketSentMessageModel));
          logger.log(socketSentMessageModel,
              name: 'ChatRepo_${this.hashCode} ${ChatSocketEvent.messageSent}');
          if (RegExp(r'\d+ was add friend to \d+')
              .hasMatch(socketSentMessageModel.message ?? '')) {
            var ids = socketSentMessageModel.message!.getListIntFromThis();
            if (ids[0] != navigatorKey.currentContext!.userInfo().id)
              _onRequestAddFriend(ids[1], ids[0]);
          }
        },
      )
      ..on(
        ChatSocketEvent.markReadAllMessage,
        (res) {
          logger.log(res, name: 'Message Read _$hashCode');
          var senderId = res[0];
          var conversationId = res[1];
          markReadAllMessage(senderId, conversationId);
        },
      )
      ..on(
        ChatSocketEvent.typing,
        (res) {
          var senderId = res[0];
          var conversationId = res[1];
          logger.log(res, name: 'Typing', color: StrColor.green);
          _controller.sink.add(
            ChatEventOnTyping(
              senderId: int.parse(senderId.toString()),
              conversationId: int.parse(conversationId.toString()),
            ),
          );
        },
      )
      ..on(
        ChatSocketEvent.stopTyping,
        (res) {
          var senderId = res[0];
          var conversationId = res[1];
          logger.log(res, name: 'OutTyping', color: StrColor.green);
          _controller.sink.add(
            ChatEventOnStopTyping(
              senderId: int.parse(senderId.toString()),
              conversationId: int.parse(conversationId.toString()),
            ),
          );
        },
      )
      ..on(ChatSocketEvent.recievedEmotionMessage, (res) {
        logger.log(res, name: "Recieved Emotion Message");
        _controller.sink.add(
          ChatEventOnRecievedEmotionMessage(
            senderId: res[0],
            messageId: res[1],
            conversationId: res[2],
            emoji: Emoji.fromId(res[3]),
            checked: res[5],
            messageType: MessageTypeExt.valueOf(res[6]),
            message: res[7],
          ),
        );
      })
      ..on(ChatSocketEvent.messageEdited, (res) {
        logger.log(res, name: "Message Editted");
        _controller.sink.add(
          ChatEventOnMessageEditted(
            int.tryParse(res[0].toString()),
            res[1],
            res[2],
          ),
        );
      })
      ..on(ChatSocketEvent.newConversationAdded, (res) {
        logger.log(res, name: "New Conversation Created");
        _controller.sink.add(
          ChatEventOnRecievedMessage(
            SocketSentMessageModel(
              conversationId: int.parse(res.toString()),
              createAt: DateTime.now(),
              messageId: '',
              senderId: 0,
              type: MessageType.text,
              autoDeleteMessageTimeModel:
                  AutoDeleteMessageTimeModel.defaultModel(),
            ),
          ),
        );
      })
      ..on(ChatSocketEvent.newMemberAddedToGroup, (res) async {
        logger.log(res, name: "Added New Member To Group");
        var conversationId = int.parse(res[0].toString());
        var memberIds =
            List<int>.from(res[1].map((e) => int.parse(e.toString())));
        var users = await getListUserInfos(memberIds);
        var chatEventOnNewMemberAddedToGroup = ChatEventOnNewMemberAddedToGroup(
          conversationId,
          users,
        );
        _controller.sink.add(chatEventOnNewMemberAddedToGroup);
        // logger.log(chatEventOnNewMemberAddedToGroup);
      })
      ..on(ChatSocketEvent.requestAddFriend, (res) {
        logger.log(res, name: ChatSocketEvent.requestAddFriend);
        res = (res as List).flattenDeep;
        _onRequestAddFriend(res[0], res[1]);
        // var senderId = res[0];
        // var recieveId = res[1];
        // _controller.sink.add(
        //   ChatEventOnFriendStatusChanged(
        //     senderId,
        //     recieveId,
        //     FriendStatus.request,
        //   ),
        // );
      })
      ..on(ChatSocketEvent.acceptRequestAddFriend, (res) {
        res = (res as List).flattenDeep;
        var senderId = res[1];
        var responseUserId = res[0];
        _controller.sink.add(
          ChatEventOnFriendStatusChanged(
            senderId,
            responseUserId,
            FriendStatus.accept,
          ),
        );
        logger.log(res, name: ChatSocketEvent.acceptRequestAddFriend);
      })
      ..on(ChatSocketEvent.declineRequestAddFriend, (res) {
        res = (res as List).flattenDeep;
        logger.log(res);
        var senderId = res[1];
        var declineUserId = res[0];
        _controller.sink.add(
          ChatEventOnFriendStatusChanged(
            senderId,
            declineUserId,
            FriendStatus.decline,
          ),
        );
        logger.log(res, name: ChatSocketEvent.declineRequestAddFriend);
      })
      ..on(ChatSocketEvent.nickNameChanged, (res) {
        logger.log(res, name: ChatSocketEvent.nickNameChanged);
      })
      ..on(ChatSocketEvent.pinMessage, (res) {
        logger.log(res, name: ChatSocketEvent.pinMessage);
        // res = (res as List<dynamic>).flatten;
        var conversationId = res[0];
        var messageId = res[1];
        _controller.sink.add(ChatEventOnPinMessage(conversationId, messageId));
      })
      ..on(ChatSocketEvent.unPinMessage, (res) {
        logger.log(res, name: ChatSocketEvent.unPinMessage);
        var conversationId = res;
        _controller.sink.add(ChatEventOnUnPinMessage(conversationId));
      })
      ..on(ChatSocketEvent.messageDeleted, (res) {
        logger.log(res, name: ChatSocketEvent.messageDeleted);
        var newRes = (res as List).flattenDeep;
        var conversationId = newRes[0];
        var msgId = newRes[1];

        _controller.sink.add(ChatEventOnDeleteMessage(conversationId, msgId));
      })
      ..on(ChatSocketEvent.deleteContact, (res) {
        logger.log(res, name: ChatSocketEvent.deleteContact);
        var newRes = (res as List).flattenDeep;
        var userId = newRes[0];
        var chatId = newRes[1];

        _controller.sink.add(ChatEventOnDeleteContact(userId, chatId));
      })
      ..on(ChatSocketEvent.changeFavoriteConversationStatus, (res) {
        logger.log(res, name: ChatSocketEvent.changeFavoriteConversationStatus);
        var newRes = (res as List).flattenDeep;
        var conversationId = newRes[0];
        var isChangeToFavorite = newRes[1] == 1;
        _controller.sink.add(ChatEventOnChangeFavoriteStatus(
          conversationId,
          isChangeToFavorite,
        ));
      })
      ..on(ChatSocketEvent.outGroup, (res) {
        logger.log(res, name: ChatSocketEvent.outGroup);
        // WIO.EmitAsync("OutGroup", conversationId, userId, adminId, listMember);
        var newRes = (res as List).flattenDeep;
        var conversationId = newRes[0];
        var deletedMemberId = newRes[1];
        var newAdminId = newRes[2];
        _controller.sink.add(ChatEventOnOutGroup(
          conversationId,
          deletedMemberId,
          newAdminId,
        ));
      })
      ..on(ChatSocketEvent.logoutAllDevice, (res) {
        logger.log(res, name: ChatSocketEvent.logoutAllDevice);
        _controller.sink.add(ChatEventLogUotAllDevice());
      });
    // ..on(ChatSocketEvent.groupNameChanged, (res) {
    //   logger.log(res, name: ChatSocketEvent.groupNameChanged);
    // });
  }

  void markReadAllMessage(senderId, conversationId) {
    return _controller.sink.add(
      ChatEventOnMarkReadAllMessage(
        senderId: senderId,
        conversationId: conversationId,
      ),
    );
  }

  final StreamController<ChatEvent> _controller = StreamController.broadcast();

  Stream<ChatEvent> get stream => _controller.stream;

  Future<RequestResponse> sendMessage(
    ApiMessageModel msg, {
    required List<int> recieveIds,
    ConversationBasicInfo? conversationBasicInfo,
    List<int>? onlineUsers,
    ValueNotifier<double>? progress,
  }) async {
    List<String> listUploadedFileNames = [];

    ApiMessageModel? newMsg;

    if (!msg.files.isBlank) {
      var uploadRes = await _uploadFiles(
        msg,
        recieveIds: recieveIds,
        progress: progress,
      );
      if (uploadRes.hasError) {
        var error = uploadRes.error ??
            ErrorResponse(
              code: StatusCode.errorUnknownCode,
              message: 'Tải file thất bại',
            );
        return RequestResponse(
          '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
          false,
          error.code,
          error: error,
        );
      }
      try {
        listUploadedFileNames.addAll([
          ...msg.files!.where((e) => e.uploaded).map((e) => e.resolvedFileName),
          ...List<String>.from(
              json.decode(uploadRes.data)["data"]['listNameFile'])
        ]);
        if (listUploadedFileNames.length != msg.files!.length) {
          var error = uploadRes.error ??
              ErrorResponse(
                code: StatusCode.errorUnknownCode,
                message: 'Tải file thất bại',
              );
          return RequestResponse(
            '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
            false,
            error.code,
            error: error,
          );
        }

        // _sendMessage(
        //   newMsg ?? msg,
        //   recieveIds: recieveIds,
        //   conversationBasicInfo: conversationBasicInfo,
        //   onlineUsers: onlineUsers,
        // );

        newMsg = ApiMessageModel(
          conversationId: msg.conversationId,
          senderId: msg.senderId,
          messageId: msg.messageId,
          type: msg.type,
          files: msg.files!.asMap().keys.map(
            (index) {
              var e = msg.files![index];
              return ApiFileModel(
                fileName: e.fileName,
                fileType: e.fileType,
                fileSize: e.fileSize,
                uploaded: true,
                // fileDatas: e.fileDatas,
                resolvedFileName: listUploadedFileNames[index],
                displayFileSize: e.displayFileSize,
              );
            },
          ).toList(),
        );

        // return _uploadFiles(msg, recieveIds);
      } catch (e, s) {
        logger.logError(e, s);
        var error = ErrorResponse(message: e.toString());
        return RequestResponse(
          '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
          false,
          error.code,
          error: error,
        );
      }
    }

    if (msg.type == MessageType.document) {
      var message = msg.message!;
      var indexOfFirstEndline = message.indexOf('\n');
      var title = message.substring(0, indexOfFirstEndline);
      var notiMessage = message.substring(indexOfFirstEndline + 1);
      var sendNotificationMessage = await _sendNotificationMessage(
        {
          'SenderId': msg.senderId,
          'Type': msg.type.databaseName,
          'Title': title,
          'Message': notiMessage,
          'Link': msg.infoLink?.link ?? msg.infoLink?.linkHome,
          'ConversationId': msg.conversationId,
        },
        messageType: msg.type,
      );
      return sendNotificationMessage;
    }

    return await _sendMessage(
      newMsg ?? msg,
      recieveIds: recieveIds,
      conversationBasicInfo: conversationBasicInfo,
      onlineUsers: onlineUsers,
    );
  }

  Future<RequestResponse> _sendMessage(
    ApiMessageModel msg, {
    required List<int> recieveIds,
    ConversationBasicInfo? conversationBasicInfo,
    List<int>? onlineUsers,
  }) async {
    var map = msg.toMap();
    if (conversationBasicInfo != null) {
      var encodedRecieveIds = json.encode(recieveIds);
      var encodedOnlineUsers = json.encode(onlineUsers);
      map.addAll({
        'ListMember': encodedRecieveIds,
        'ConversationName': conversationBasicInfo.name,
        'IsOnline': encodedOnlineUsers,
        'IsGroup': conversationBasicInfo.isGroup ? 1 : 0,
      });
    }
    return _client.fetch(
      ApiPath.sendMessage,
      data: map,
      retryTime: 1,
    );
  }

  Future<RequestResponse> _sendNotificationMessage(
    Map<String, dynamic> mapData, {
    required MessageType messageType,
  }) async {
    if (messageType == MessageType.document)
      return _client.fetch(
        ApiPath.sendNewNotification_v2,
        data: mapData,
      );
    throw CustomException(
      ExceptionError(
        'MessageType $messageType chưa hỗ trợ gửi dưới dạng notification',
      ),
    );
  }

  Future<RequestResponse> _uploadFiles(
    ApiMessageModel msg, {
    List<int>? recieveIds,
    ValueNotifier<double>? progress,
  }) async {
    var data = [
      for (final file in msg.files!)
        if (!file.uploaded)
          await MultipartFile.fromFile(
            file.filePath!,
            filename: file.fileName,
          ),
    ];
    if (data.isNotEmpty)
      return await _client.upload(
        ApiPath.uploadFile,
        data,
        mapData: {
          'MessageID': msg.messageId,
          'ConversationID': msg.conversationId,
          'SenderID': msg.senderId,
          'MessageType': msg.type.name,
          'ListFile':
              msg.files!.map((e) => e.toJsonString()).toList().toString(),
          'MemberList': json.encode(recieveIds),
          'DeleteTime': 0,
        },
        progressListener: progress,
      );
    return RequestResponse(
      '{"data":{"listNameFile":[]},"result":true,"code":${StatusCode.ok}}',
      true,
      StatusCode.ok,
    );
  }

  // sendSocketMessage(
  //   ApiMessageModel msg, {
  //   required List<int> recieveIds,
  // }) {
  //   chatClient.emit(
  //     ChatSocketEvent.sendMessage,
  //     [msg.toMap(), recieveIds],
  //   );
  // }

  changeCurrentUserTypingState(
    bool isTyping, {
    required int userId,
    required int conversationId,
    required List<int> listMemeber,
  }) {
    chatClient.emit(
      isTyping ? ChatSocketEvent.typing : ChatSocketEvent.stopTyping,
      [userId, conversationId, listMemeber],
    );
  }

  /// [messageIds] == null: markRead tất cả message
  ///
  /// Api không hỗ trợ markRead 1 message nên hiện tại messageIds luôn null
  markReadMessage({
    List<int>? messageIds,
    required int senderId,
    required int conversationId,
    required List<int> memebers,
  }) {
    _client.fetch(
      ApiPath.markAsRead,
      data: {
        'conversationId': conversationId,
        'senderId': senderId,
      },
    );
    var data2 = [senderId, conversationId, memebers];
    logger.log(data2, name: 'EmitReadMessage');
    chatClient.emit(
      ChatSocketEvent.markReadAllMessage,
      data2,
    );
  }

  changeReaction(ChatEventEmitChangeReationMessage event) async {
    var data = [
      event.userId,
      event.messageId,
      event.conversationId,
      event.emoji.id,
      event.emoji.linkEmotion,
      event.allMemberIdsInConversation,
      event.isChecked,
      event.messageType.databaseName,
      event.message,
    ];
    logger.log(data, name: 'Emit ReactionMessage Data');
    chatClient.emit(
      ChatSocketEvent.changeReactionMessage,
      data,
    );

    String userIds;

    /// unlike
    if (event.isChecked) {
      // event.memberReactThisEmoji.remove(currentUserId);
      userIds = event.memberReactThisEmoji.join(',');
    } else {
      /// like
      userIds = event.userId.toString();
    }

    var res = await _client.fetch(
      ApiPath.changeEmotionMessage,
      data: {
        'MessageID': event.messageId,
        'ListUserId': userIds,
        'Type': event.emoji.id,
      },
      options: Options(
        receiveTimeout: 7000,
        sendTimeout: 7000,
      ),
    );
    res.onCallBack((_) {});
  }

  deleteMessage(
    ApiMessageModel message, {
    required List<int> members,
  }) async {
    var res = await _client.fetch(
      ApiPath.deleteMessage,
      data: {
        'MessageID': message.messageId,
      },
    );
    res.onCallBack((_) {
      if (!res.hasError && res.result == true ||
          res.error?.messages == 'Tin nhắn không tồn tại') {
        chatClient.emit(ChatSocketEvent.deleteMessage, [
          {
            'MessageID': message.messageId,
            'ConversationID': message.conversationId,
          },
          members,
        ]);
      }
    });
  }

  editMessage(
    int conversationId,
    String messageId,
    String message, {
    required List<int> members,
  }) async {
    // throw CustomException();
    var res = await _client.fetch(
      ApiPath.editMessage,
      data: {
        'MessageID': messageId,
        'Message': message,
      },
    );
    res.onCallBack((_) {
      if (!res.hasError && res.result == true) {
        chatClient.emit(ChatSocketEvent.editMessage, [
          {
            "ConversationID": conversationId,
            "MessageID": messageId,
            "Message": message,
          },
          members,
        ]);
      }
    });
  }

  Future<IUserInfo?> getUserInfo(int userId) async {
    var res = await _client.fetch(
      ApiPath.getUserInfo,
      data: {'ID': userId},
    );

    try {
      return res.onCallBack(
        (_) => resultLoginFromJson(res.data).data!.userInfo,
      );
    } catch (e) {
      return null;
    }
  }

  Future<ConversationBasicInfo?> getConversationInfo(int conversationId) async {
    return (await getChatItemModel(conversationId))?.conversationBasicInfo;
  }

  Future<ChatItemModel?> getChatItemModel(int conversationId) async {
    var currentUserId =
        navigatorKey.currentContext?.userInfo().id ?? userInfo?.id;
    var res = await _client.fetch(
      ApiPath.chatInfo,
      data: {
        'conversationId': conversationId,
        'senderId': currentUserId,
      },
    );

    try {
      return res.onCallBack(
        (_) => ChatItemModel.fromConversationInfoJsonOfUser(
          currentUserId!,
          conversationInfoJson: json.decode(res.data)["data"]
              ["conversation_info"],
        ),
      );
    } catch (e, s) {
      logger.logError(e, s);
    }
    return null;
  }

  Future<List<IUserInfo>> getListUserInfos(List<int> userIds) async {
    var res = await Future.wait(userIds.map((e) => getUserInfo(e)).toList());
    res.removeWhere((e) => e == null);
    return res.cast();
  }

  dispose() {
    _controller.close();
  }

  Future<RequestResponse> getConversationId(int chatId) => ApiClient().fetch(
        ApiPath.resolveChatId,
        data: {
          'userId': navigatorKey.currentContext!.userInfo().id,
          'contactId': chatId,
        },
      );

  emitAddFriend(int senderId, int chatId) => chatClient.emit(
      ChatSocketEvent.requestAddFriend,
      [
        senderId,
        chatId,
      ].toSet());

  Future<bool> responseAddFriend(
      int responseId, int requestId, FriendStatus status) async {
    // chatClient.emit(
    //   status == FriendStatus.accept
    //       ? ChatSocketEvent.acceptRequestAddFriend
    //       : ChatSocketEvent.declineRequestAddFriend,
    //   [responseId, requestId],
    // );
    // return true;
    var res = await _client.fetch(
      status == FriendStatus.accept
          ? ApiPath.acceptRequestAddFriend
          : ApiPath.decilineRequestAddFriend,
      data: {
        'userId': responseId,
        'contactId': requestId,
      },
    );

    return res.onCallBack((_) {
      if (res.result == true)
        chatClient.emit(
          status == FriendStatus.accept
              ? ChatSocketEvent.acceptRequestAddFriend
              : ChatSocketEvent.declineRequestAddFriend,
          [responseId, requestId],
        );
      return res.result == true;
    });
  }

  _onRequestAddFriend(int requestId, int recieveId) {
    _controller.sink.add(
      ChatEventOnFriendStatusChanged(
        requestId,
        recieveId,
        FriendStatus.request,
      ),
    );
  }

  void emitNameChanged(
    int id,
    String newNickName,
    bool isGroup,
    List<int> members,
  ) {
    if (isGroup)
      chatClient.emit(
        ChatSocketEvent.changeGroupName,
        [id, newNickName, members],
      );
    else
      chatClient.emit(
        ChatSocketEvent.changeNickName,
        [id, newNickName, navigatorKey.currentContext!.userInfo().id],
      );
  }

  void emitChangeUserName(int id, String newName) {
    chatClient.emit(ChatSocketEvent.changeUserName, [id, newName]);
  }

  void emitChangeAvatarUser(
    int id,
    String avatar,
  ) {
    chatClient.emit(ChatSocketEvent.changeAvatarUser,
        [id, 'https://mess.timviec365.vn/avatarUser/$id/$avatar']);
  }

  void logout(int id) {
    logger.log('Emit Logout: $id', name: ChatSocketEvent.logout);
    chatClient.emit(ChatSocketEvent.logout, id);
  }

  void emitChangeAvatarGroup(
    int idConversation,
    String avatar,
    List<int> members,
  ) {
    chatClient.emit(ChatSocketEvent.changeGroupAvatar, [
      idConversation,
      'https://mess.timviec365.vn/avatarGroup/$idConversation/$avatar',
      members,
    ]);
  }

  pinMessasge(int conversationId, String messageContent, String messageId,
      List<int> members) async {
    chatClient.emit(ChatSocketEvent.pinMessage, [
      conversationId,
      messageId,
      members,
    ]);
    sendMessage(
      ApiMessageModel(
        messageId: GeneratorService.generateMessageId(currentUserId),
        conversationId: conversationId,
        senderId: currentUserId,
        message: '${currentUserId} pinned a message: ${messageContent}',
        type: MessageType.notification,
      ),
      recieveIds: members,
    );
    _client.fetch(ApiPath.pinMessage, data: {
      'conversationId': conversationId,
      'pinMessageId': messageId,
    });
  }

  int get currentUserId =>
      navigatorKey.currentContext?.userInfo().id ?? userInfo!.id;

  unPinMessage(
      int conversationId, String messageContent, List<int> members) async {
    chatClient.emit(ChatSocketEvent.unPinMessage, [conversationId, members]);
    sendMessage(
      ApiMessageModel(
        messageId: GeneratorService.generateMessageId(currentUserId),
        conversationId: conversationId,
        senderId: currentUserId,
        message: '${currentUserId} unpinned a message: $messageContent',
        type: MessageType.notification,
      ),
      recieveIds: members,
    );
    _client.fetch(
      ApiPath.unPinMessage,
      data: {
        'conversationId': conversationId,
      },
    );
  }

  void emitDeleteMember(
    int chatId,
    int deleteMemberId,
    int adminId,
    List<int> members, [
    int? newAdminId,
  ]) {
    chatClient.emit(ChatSocketEvent.outGroup, [
      chatId, deleteMemberId, newAdminId ?? 0, members,
      // WIO.EmitAsync("OutGroup", conversationId, userId, adminId, listMember);
    ]);
    sendMessage(
      ApiMessageModel(
        messageId: GeneratorService.generateMessageId(deleteMemberId),
        conversationId: chatId,
        senderId: adminId,
        message: adminId == deleteMemberId
            ? '$deleteMemberId leaved this consersation'
            : '$adminId has removed $deleteMemberId from this conversation',
        type: MessageType.notification,
      ),
      recieveIds: members,
    );
  }

  void emitDeleteContact(int userId, int chatId) {
    chatClient.emit(
      ChatSocketEvent.deleteContact,
      {userId, chatId},
    );
  }

  void emitChangeFavoriteconversationStatus(
    int userId,
    int conversationId,
    int favoriteStatus,
  ) {
    chatClient.emit(
      ChatSocketEvent.changeFavoriteConversationStatus,
      [userId, conversationId, favoriteStatus],
    );
  }

  Future<Set<int>?> getUnreadConversationIds() async {
    try {
      var res = await ApiClient().fetch(
        ApiPath.unreadConversation,
        data: {
          'userId': currentUserId,
        },
      );
      return res.onCallBack(
        (_) => Set<int>.from(json.decode(res.data)['data']['listConversation']),
      );
    } catch (e, s) {
      logger.logError(e, s);
      return null;
    }
  }
}

final ChatRepo chatRepo = ChatRepo();
