import 'dart:async';

import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';

part 'chat_member_model.g.dart';

@HiveType(typeId: HiveTypeId.chatMemberModelHiveTypeId)
class ChatMemberModel extends IUserInfo {
  ChatMemberModel({
    required this.unReader,
    this.readMessageTime,
    required int id,
    required String name,
    required String avatar,
    this.unreadMessageId,
    UserStatus userStatus = UserStatus.online,
    String? status,
    DateTime? lastActive,
    int? companyId,
  }) : super(
          id: id,
          name: name,
          avatar: avatar,
          userStatus: userStatus,
          status: status,
          lastActive: lastActive,
          companyId: companyId,
        );

  @HiveField(kMaxIUserInfoMaxFieldId + 1)
  int unReader;
  @HiveField(kMaxIUserInfoMaxFieldId + 2)
  DateTime? readMessageTime;

  String? unreadMessageId;

  factory ChatMemberModel.fromMap(Map<String, dynamic> json) {
    try {
      var lastActiveFromJson = NullableDateTimeExt.lastActiveFromJson(json);
      var name = json["userName"];
      var id = json["id"];

      return ChatMemberModel(
        id: id,
        name: name,
        avatar: (!(json["avatarUser"] as String?).isBlank ? json["avatarUser"] : json["linkAvatar"]),
        unReader: json["unReader"] ?? 0,
        userStatus: UserStatus.fromId(
          json["active"] ?? json["Active"] ?? UserStatus.online.id,
        ),
        status: json["status"],
        readMessageTime: DateTimeExt.timeZoneParse(json["timeLastSeener"] ?? ''),
        lastActive: lastActiveFromJson,
        companyId: json['companyId'] ?? json['CompanyId'],
        unreadMessageId: json['readMessageId'],
      )..userType = UserType.fromId(json['type365']);
    } catch (e, s) {
      logger.logError(e, s);
      logger.logError(json, 'ChatMemberModel_JsonError');
      logger.logError('-------------------------------------------------------');
      return ChatMemberModel.unknown();
    }
  }

  factory ChatMemberModel.unknown() => ChatMemberModel(
        id: -1,
        name: 'Người dùng 365',
        avatar: '',
        unReader: 0,
      );

  @override
  Map<String, dynamic> toJson() {
    // TODO: implement toJson
    throw UnimplementedError();
  }

  @override
  FutureOr<Map<String, dynamic>> toLocalStorageJson() {
    // TODO: implement toLocalStorageJson
    throw UnimplementedError();
  }

  @override
  String toString() => name;
}

// extension ListChatMemberModelExt on List<ChatMemberModel> {
//   ValueNotifier<List<ChatMemberModel>> get toValueListenable =>
//       ValueNotifier(this);

//   List<int> get memberIds => map((e) => e.id).toList();

//   int get firstMemberId => first.id;
// }
