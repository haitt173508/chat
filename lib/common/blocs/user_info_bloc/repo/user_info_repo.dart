import 'dart:async';
import 'dart:convert';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/unauth_type.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';

import '../bloc/user_info_event.dart';

class UserInfoRepo {
  UserInfoRepo() {
    chatClient
      ..on(ChatSocketEvent.changeAvatarUser, _onAvatarChangedHandler)
      ..on(ChatSocketEvent.changeGroupAvatar, _onAvatarGroupChangedHandler)
      ..on(ChatSocketEvent.userDisplayNameChanged, _onUserNameChangedHandler)
      ..on(ChatSocketEvent.presenceStatusChanged, _onUserStatusChangedHandler)
      ..on(ChatSocketEvent.moodMessageChanged, _onStatusChangedHandler)
      ..on(ChatSocketEvent.groupNameChanged, _onGroupNameChangedHandler)
      ..on(ChatSocketEvent.nickNameChanged, _onNicknameChangedHandler)
      ..on(ChatSocketEvent.login, _onLoggedInChangedHander)
      ..on(ChatSocketEvent.logout, _onLoggedOutChangedHander);
  }

  _onAvatarChangedHandler(e) async {
    _controller.sink.add(
      UserInfoEventAvatarChanged(
        userId: e[0],
        avatar: e[1] as String,
      ),
    );
  }

  _onAvatarGroupChangedHandler(e) async {
    _controller.sink.add(
      UserInfoEventAvatarChanged(
        userId: int.parse(e[0].toString()),
        avatar: e[1] as String,
      ),
    );
  }

  _onUserNameChangedHandler(e) {
    _controller.sink.add(
      UserInfoEventUserNameChanged(
        userId: e[0],
        name: e[1],
      ),
    );
  }

  _onUserStatusChangedHandler(e) {
    try {
      _controller.sink.add(
        UserInfoEventUserStatusChanged(
          userId: e[0],
          userStatus: UserStatus.fromId(e[1]),
        ),
      );
    } catch (_) {
      _controller.sink.add(
        UserInfoEventUserStatusChanged(
          userId: e[0][0],
          userStatus: UserStatus.fromId(e[0][1]),
        ),
      );
    }
  }

  _onStatusChangedHandler(e) {
    logger.log(e);
    _controller.sink.add(
      UserInfoEventStatusChanged(
        userId: int.parse(e[0].toString()),
        status: e[1],
      ),
    );
  }

  _onGroupNameChangedHandler(e) {
    _controller.sink.add(UserInfoEventUserNameChanged(
      name: e[1],
      userId: int.parse(e[0].toString()),
    ));
  }

  _onNicknameChangedHandler(e) {
    _controller.sink.add(
      UserInfoEventNicknameChanged(
        newNickname: e[1],
        conversationId: int.parse(e[0].toString()),
      ),
    );
  }

  _onLoggedInChangedHander(e) {
    try {
      _controller.sink.add(
        UserInfoEventActiveTimeChanged(
          int.parse(e.toString()),
          AuthStatus.authenticated,
          lastActive: null,
        ),
      );
    } catch (exc) {
      logger.logError(e, exc, 'LoggedInError');
    }
  }

  _onLoggedOutChangedHander(e) {
    try {
      // logger.log(e, name: ChatSocketEvent.logout);
      var params = (e as Iterable).flattenDeep;
      var unauthType = UnauthTypeExt.fromId(params[1]);
      _controller.sink.add(
        UserInfoEventActiveTimeChanged(
          params[0],
          AuthStatus.unauthenticated,
          lastActive: unauthType == UnauthType.disconnect
              ? DateTime.now()
              : DateTime.now().add(const Duration(days: 10)),
        ),
      );
    } catch (exc) {
      logger.logError(e, exc, 'LoggedOutError');
    }
  }

  final StreamController<UserInfoEvent> _controller =
      StreamController.broadcast();

  StreamController<UserInfoEvent> get controller => _controller;

  Stream<UserInfoEvent> get stream => _controller.stream;

  /// Nếu [isGroup]: [chatId] là [conversationId]
  ///
  /// Nếu không, [chatId] là [id]
  Future<IUserInfo?> getChatInfo(int chatId, bool isGroup) async {
    if (chatId != 0)
      try {
        IUserInfo info;
        if (isGroup)
          info = await _getConversationInfo(chatId);
        else {
          info = await _getUserInfo(chatId);
        }

        return info;
      } catch (e, s) {
        logger.logError(e, s);
      }
    return null;
  }

  int get currentUserId => navigatorKey.currentContext!.userInfo().id;

  /// Tự động add các event liên quan đến [IUserInfo] của user
  broadCastUserInfo(IUserInfo info) {
    var chatId = info.id;
    controller.sink
      ..add(
        UserInfoEventUserStatusChanged(
          userId: chatId,
          userStatus: info.userStatus,
        ),
      )
      ..add(
        UserInfoEventStatusChanged(
          userId: chatId,
          status: info.status ?? '',
        ),
      )
      ..add(
        UserInfoEventActiveTimeChanged(
          chatId,
          info.lastActive == null
              ? AuthStatus.authenticated
              : AuthStatus.unauthenticated,
          lastActive: info.lastActive,
        ),
      )
      ..add(
        UserInfoEventAvatarChanged(
          userId: chatId,
          avatar: info.avatar,
        ),
      )
      ..add(
        UserInfoEventUserNameChanged(
          userId: chatId,
          name: info.name,
        ),
      );
  }

  /// Tự động add các event liên quan đến [ConversationBasicInfo] của user
  broadCastConversationInfo(ConversationBasicInfo info) {
    controller.sink
      ..add(
        UserInfoEventAvatarChanged(
          avatar: info.avatar,
          userId: info.id,
        ),
      )
      ..add(
        UserInfoEventUserNameChanged(
          name: info.name,
          userId: info.id,
        ),
      );
  }

  dispose() {
    _controller.close();
  }

  Future<IUserInfo> _getConversationInfo(int conversationId) async {
    var res = await ApiClient().fetch(ApiPath.chatInfo, data: {
      "conversationId": conversationId,
      "senderId": currentUserId,
    });

    return res.onCallBack(
      (_) {
        var conversationInfo = ChatItemModel.fromConversationInfoJsonOfUser(
          currentUserId,
          conversationInfoJson: json.decode(res.data)["data"]
              ["conversation_info"],
        );

        broadCastConversationInfo(conversationInfo.conversationBasicInfo);

        return conversationInfo.conversationBasicInfo;
      },
    );
  }

  Future<IUserInfo> _getUserInfo(int userId) async {
    var res = await ApiClient().fetch(
      ApiPath.getUserInfo,
      data: {'ID': userId},
      baseOptions: BaseOptions(
        sendTimeout: 7000,
        receiveTimeout: 7000,
        connectTimeout: 7000,
      ),
    );

    return res.onCallBack((_) {
      var userInfo = resultLoginFromJson(res.data).data!.userInfo;

      broadCastUserInfo(userInfo);

      return userInfo;
    });
  }
}

final UserInfoRepo userInfoRepo = UserInfoRepo();
