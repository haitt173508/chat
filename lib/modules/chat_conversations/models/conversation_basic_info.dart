import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:hive_flutter/adapters.dart';

part 'conversation_basic_info.g.dart';

@HiveType(typeId: HiveTypeId.conversationBasicInfoHiveTypeId)
class ConversationBasicInfo extends IUserInfo {
  ConversationBasicInfo({
    required this.conversationId,
    required this.isGroup,
    required this.userId,
    this.pinMessageId,
    this.groupLastSenderId,
    this.lastConversationMessageTime,
    this.lastConversationMessage,
    this.countUnreadMessage,
    this.totalGroupMemebers,
    this.lastMessasgeId,
    required String name,
    String? avatar,
    UserStatus userStatus = UserStatus.online,
    DateTime? lastActive,
    int? companyId,
    String? email,
    FriendStatus? friendStatus,
  }) : super(
          id: isGroup ? conversationId : userId,
          name: name,
          avatar: avatar,
          userStatus: userStatus,
          lastActive: lastActive,
          companyId: companyId,
          email: email,
          friendStatus: isGroup ? null : friendStatus,
        );

  @HiveField(kMaxIUserInfoMaxFieldId + 1)
  final bool isGroup;
  @HiveField(kMaxIUserInfoMaxFieldId + 2)
  String? lastConversationMessage;
  @HiveField(kMaxIUserInfoMaxFieldId + 3)
  DateTime? lastConversationMessageTime;
  @HiveField(kMaxIUserInfoMaxFieldId + 4)
  int? countUnreadMessage;
  @HiveField(kMaxIUserInfoMaxFieldId + 5)
  String? pinMessageId;

  /// [id] của người cuối cùng nhắn tin trong group
  @HiveField(kMaxIUserInfoMaxFieldId + 6)
  int? groupLastSenderId;

  /// Message de lay id nguoi ghim va noi dung tin de ghim
  @HiveField(kMaxIUserInfoMaxFieldId + 7)
  String? message;

  @HiveField(kMaxIUserInfoMaxFieldId + 8)
  final int conversationId;

  /// Nếu là nhóm
  @HiveField(kMaxIUserInfoMaxFieldId + 9)
  final int userId;

  @HiveField(kMaxIUserInfoMaxFieldId + 10)
  int? totalGroupMemebers;

  @HiveField(kMaxIUserInfoMaxFieldId + 11)
  String? lastMessasgeId;

  // FriendStatus? _friendStatus;

  // @override
  // FriendStatus? get friendStatus => super.friendStatus;

  // @override
  // set friendStatus(FriendStatus? status) => super.friendStatus = status;

  static const kConversationBasicInfoMaxFieldId = kMaxIUserInfoMaxFieldId + 11;

  // ConversationBasicInfo copyWith({
  //   String? name,
  //   String? avatarUrl,
  //   UserStatus? userStatus,
  // }) =>
  //     ConversationBasicInfo(
  //       id: id,
  //       conversationId: this.conversationId,
  //       name: name ?? this.name,
  //       avatarUrl: avatarUrl,
  //       userStatus: userStatus ?? this.userStatus,
  //     );

  @override
  Map<String, dynamic> toJson() => {};

  Future<Map<String, dynamic>> toLocalStorageJson() async {
    return {
      "id": id,
      "name": name,
      "avatar": avatar.isBlank ? [] : await ApiClient().downloadImage(avatar!),
    };
  }

  @override
  String toJsonString() {
    return """{
        "Id": $id,
        "ID365": $id365,
        "Email": "$email",
        "UserName": "$name",
        "AvatarUser": "$avatar",
        "Status": "$status",
      }""";
  }

  @override
  String toString() => name;
}
