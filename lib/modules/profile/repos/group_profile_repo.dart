import 'dart:io';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/chat_socket_event.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/new_conversation/models/group_conversation_creation_kind.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/clients/chat_client.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:chat_365/utils/helpers/file_utils.dart';
import 'package:dio/dio.dart';

class GroupProfileRepo {
  final ApiClient _apiClient;

  /// Nếu là group infoId = conversationId
  ///
  /// Nếu là user infoId = id của user đó
  final int infoId;

  final int currentUserId = navigatorKey.currentContext!.userInfo().id;

  final bool isGroup;

  GroupProfileRepo(this.infoId, this.isGroup) : _apiClient = ApiClient();

  Future<void> changeName({
    required String newName,
    required List<int> memberIds,
  }) async {
    final RequestResponse res = await _apiClient.fetch(
      ApiPath.changeGroupName,
      data: {
        'conversationId': infoId,
        'conversationName': newName,
      },
    );

    if (res.hasError) throw res.error!.messages!;

    chatClient.emit(
      ChatSocketEvent.changeGroupName,
      [infoId, newName, memberIds],
    );
  }

  Future<void> changeAvatar({
    required File file,
    required List<int> memberIds,
  }) async {
    final RequestResponse res = await _apiClient.upload(
      ApiPath.changeGroupAvatar,
      [await MultipartFile.fromFile(file.path)],
    );

    if (res.hasError) throw res.error!.messages!;

    chatClient.emit(
      ChatSocketEvent.changeGroupAvatar,
      [infoId, file.nameOnly, memberIds],
    );
  }

  Future<ExceptionError?> addMember({
    required Iterable<int> newMemberIds,
    required Iterable<int> oldMemberIds,
  }) async {
    final RequestResponse res = await _apiClient.fetch(
      ApiPath.addMemberToGroup,
      data: {
        'senderId': currentUserId,
        'typeGroup': GroupConversationCreationKind.public.serverName,
        'conversationName': '',
        'memberList': newMemberIds.toString(),
        'conversationId': infoId,
      },
    );

    try {
      res.onCallBack((_) {
        chatClient.emit(
          ChatSocketEvent.addMemberToGroup,
          [infoId, newMemberIds.toList(), oldMemberIds.toList()],
        );
      });
      return null;
    } on CustomException catch (e) {
      return e.error;
    }
  }

  Future deleteMember({
    required int deleteMemberId,
    required List<int> memberIds,
  }) async {
    final RequestResponse res = await _apiClient.fetch(
      ApiPath.deleteMemberFromGroup,
      data: {
        'conversationId': infoId,
        'senderId': deleteMemberId,
        'adminId': -1,
      },
    );

    if (res.hasError) throw res.error!.messages!;

    chatClient.emit(
      ChatSocketEvent.outGroup,
      [infoId, deleteMemberId, -1, memberIds],
    );
  }

  changeStatus(String text) async {
    // TODO: Không có api https đổi status
    chatClient.emit(ChatSocketEvent.changeMoodMessage, [infoId, text]);
  }

  changeUserStatus(UserStatus status) {
    _apiClient.fetch(ApiPath.changePresenceStatus, data: {
      'ID': infoId,
      'Active': status.id,
    });
    chatClient.emit(ChatSocketEvent.changePresenceStatus, [infoId, status.id]);
  }
}
