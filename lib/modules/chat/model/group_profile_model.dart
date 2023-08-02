import 'dart:io';

import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:flutter/foundation.dart';

import 'chat_member_model.dart';

class GroupProfileModel {
  GroupProfileModel({
    required this.conversationId,
    required String conversationName,
    required this.avatarUrl,
    required this.adminName,
    required this.isGroup,
    required this.typeGroup,
    required this.adminId,
    required this.memberList,
    required this.createAt,
  })  : conversationName = ValueNotifier(conversationName),
        conversationAvatar = ValueNotifier(null);

  final int conversationId;
  final ValueNotifier<String> conversationName;
  final ValueNotifier<File?> conversationAvatar;
  final String avatarUrl;
  final bool isGroup;
  final String typeGroup;
  final int adminId;
  final String adminName;
  final List<ChatMemberModel> memberList;
  final DateTime createAt;

  factory GroupProfileModel.fromMap(
    Map<String, dynamic> json, {
    required int currentUserId,
    required String adminName,
  }) {
    final bool isGroup = json["isGroup"] == 1;

    final String conversationName = json["conversationName"];
    final String conversationAvatar =
        (json["avatarConversation"] as String).isBlank
            ? json["linkAvatar"]
            : json["avatarConversation"];

    final List<ChatMemberModel> memberList = List<ChatMemberModel>.from(
      json["listMember"].map((x) => ChatMemberModel.fromMap(x)),
    );

    final ChatMemberModel currentUser =
        memberList.firstWhere((e) => e.id != currentUserId);

    final int effectiveId = isGroup ? json["conversationId"] : currentUser.id;

    final String effectiveConversationName =
        conversationName.isNotEmpty ? conversationName : currentUser.name;

    final String effectiveConversationAvatar =
        conversationAvatar.isNotEmpty && conversationAvatar.isImageUrl
            ? conversationAvatar
            : isGroup
                ? ''
                : currentUser.avatar;

    return GroupProfileModel(
      conversationId: effectiveId,
      conversationName: effectiveConversationName,
      avatarUrl: effectiveConversationAvatar,
      adminName: adminName,
      isGroup: isGroup,
      typeGroup: json["typeGroup"],
      adminId: json["adminId"],
      memberList: memberList,
      createAt: DateTime.parse(json["createAt"]),
    );
  }
}
