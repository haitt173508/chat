import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/chat/model/chat_member_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

part 'result_chat_conversation.g.dart';

@HiveType(typeId: HiveTypeId.chatItemModelHiveTypeId)
class ChatItemModel extends Equatable {
  ChatItemModel({
    required this.conversationId,
    required int numberOfUnReadMessgae,
    required this.isGroup,
    required this.senderId,
    required String? message,
    required this.messageType,
    required this.totalNumberOfMessages,
    required this.messageDisplay,
    required this.typeGroup,
    required this.adminId,
    this.adminName,
    this.browerMemberList,
    required this.memberList,
    required this.isFavorite,
    required this.isHidden,
    required this.createAt,
    required this.conversationBasicInfo,
    String? status,
    AutoDeleteMessageTimeModel? initAutoDeleteMessageTimeModel,
    this.lastMessages,
  })  : this.numberOfUnreadMessage = numberOfUnReadMessgae,
        this.message = messageType?.displayMessageType(message) ?? '',
        this.autoDeleteMessageTimeModel = initAutoDeleteMessageTimeModel ??
            AutoDeleteMessageTimeModel.defaultModel();

  @HiveField(0)
  final int conversationId;
  @HiveField(1)
  final int numberOfUnreadMessage;
  @HiveField(2)
  final bool isGroup;
  @HiveField(3)
  int senderId;
  @HiveField(4)
  final String message;
  @HiveField(5)
  final MessageType? messageType;
  @HiveField(6)
  int totalNumberOfMessages;
  @HiveField(7)
  final int messageDisplay;
  @HiveField(8)
  final String typeGroup;
  @HiveField(9)
  final int adminId;
  @HiveField(10)
  final String? adminName;
  @HiveField(11)
  List<ChatMemberModel>? browerMemberList;
  @HiveField(12)
  List<ChatMemberModel> memberList;
  @HiveField(13)
  bool isFavorite;
  @HiveField(14)
  bool isHidden;
  @HiveField(15)
  final DateTime createAt;
  @HiveField(16)
  final ConversationBasicInfo conversationBasicInfo;
  @HiveField(17)
  String? status;
  @HiveField(18)
  AutoDeleteMessageTimeModel autoDeleteMessageTimeModel;
  List<SocketSentMessageModel>? lastMessages;

  Map<int, int> unreadMessageUserAndMessageIndex = {};

  /// Danh sách [senderId] và [message] tương ứng chưa đọc
  Map<int, String> unreadMessageUserAndMessageId = {};

  /// Người đầu tiên trong [memberList] có [userId] khác vs [userId] người dùng hiện tại
  ///
  /// [userId]: id người dùng hiện tại
  ChatMemberModel firstOtherMember(int userId) => memberList.firstWhere(
        (e) => e.id != userId,
        orElse: () => memberList.first,
      );

  /// [userId] hiện tại của cuộc trò chuyện
  ///
  /// Nếu [isGroup] => [userId] hiện tại là conversationId
  ///
  /// Nếu không => [userId] hiện tại là id của người còn lại trong chat != conversationId
  int effectiveId(int userId) =>
      isGroup ? conversationId : firstOtherMember(userId).id;

  /// Tên hiển thị của cuộc trò chuyện
  ///
  /// Nếu [conversationName] isNotEmpty => [conversationName]
  ///
  /// Nếu [isGroup] => Tên DS thành viên
  ///
  /// Nếu không => chat 2 người => Tên người còn lại [firstOtherMember]
  String effectiveConversationName(int userId) =>
      conversationBasicInfo.name.isNotEmpty
          ? conversationBasicInfo.name
          : isGroup
              ? (browerMemberList ?? memberList).names
              : firstOtherMember(userId).name;

  /// Nếu [avatar] không null và không rỗng => [avataUrl]
  ///
  /// Nếu không:
  /// - [isGroup]: => rỗng vì [avatar] null hoặc rỗng nên group không có avatar
  /// - [avatar] người còn lại
  String effectiveConversationAvatar(int userId) => isGroup
      ? (conversationBasicInfo.avatar ?? '')
      : firstOtherMember(userId).avatar;

  // bool get hasUnReadMessgae => numberOfUnreadMessage.state.counter != 0;

  /// [UserStatus] hiện tại của cuộc trò chuyện
  UserStatus currentCoversationUserStatus(int userId) {
    if (!isGroup) return firstOtherMember(userId).userStatus;
    return UserStatus.none;
  }

  factory ChatItemModel.fromMap(
    Map<String, dynamic> json, {
    required MessageType? messageType,
    required String message,
    String? adminName,
    required List<ChatMemberModel> memberList,
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) {
    late final List<ChatMemberModel>? browerMemberList;

    if (json["listBrowerMember"] == null)
      browerMemberList = null;
    else {
      final list = List.of(json["listBrowerMember"]);

      browerMemberList = list.isEmpty
          ? null
          : list
              .map<ChatMemberModel>(
                  (e) => ChatMemberModel.fromMap(e['userMember']))
              .toList();
    }

    var isGroup = json["isGroup"] == 1;
    var createAt = DateTimeExt.timeZoneParse(json["createAt"]);
    var countUnreadMessage = json["unReader"];

    final int senderId = json["senderId"];
    var lastMessageId = json['messageId'];
    return ChatItemModel(
      conversationId: json["conversationId"],
      // conversationName: ,
      // avatarConversation: ,
      numberOfUnReadMessgae: countUnreadMessage,
      isGroup: isGroup,
      senderId: senderId,
      message: message,
      messageType: messageType,
      totalNumberOfMessages: json["countMessage"],
      messageDisplay: json["messageDisplay"],
      typeGroup: json["typeGroup"],
      adminId: json["adminId"],
      adminName: adminName,
      browerMemberList: browerMemberList,
      memberList: memberList,
      isFavorite: json["isFavorite"] == 1,
      isHidden: json["isHidden"] == 1,
      createAt: createAt,
      conversationBasicInfo: ConversationBasicInfo(
        isGroup: isGroup,
        userId: json["conversationId"],
        avatar: (json["avatarConversation"] as String?).isBlank
            ? json["linkAvatar"]
            : json["avatarConversation"],
        conversationId: json["conversationId"],
        lastConversationMessage: message,
        lastConversationMessageTime: createAt,
        countUnreadMessage: countUnreadMessage,
        // isGroup: json["isGroup"] == 1,
        // avatar: await ApiClient().downloadImage(json["avatarConversation"]),
        userStatus: UserStatus.fromId(
          int.tryParse(json["active"].toString()) ?? UserStatus.online.id,
        ),
        friendStatus: FriendStatusExt.fromApiValue(json["friendStatus"] ?? ''),
        // avatarUrl: ImageUrlResolver.avatar(
        //   json["conversationId"],
        //   json["avatarConversation"],
        // ),
        pinMessageId: json['pinMessageId'],
        name: json["conversationName"] ?? '',
        lastMessasgeId: lastMessageId,
        groupLastSenderId: senderId == 0 && lastMessageId != null
            ? int.parse(lastMessageId!.split('_').last)
            : senderId,
      ),
      lastMessages: json['listMessage'] != null
          ? List<SocketSentMessageModel>.from(
              (json['listMessage'] as List)
                  .map((e) => SocketSentMessageModel.fromMap(
                        e,
                        userInfo: currentUserInfo,
                        userType: currentUserType,
                      )),
            )
          : null,
      initAutoDeleteMessageTimeModel: AutoDeleteMessageTimeModel.fromJson(json),
    );
  }

  factory ChatItemModel.fromConversationInfoJsonOfUser(
    int currentUserId, {
    required Map<String, dynamic> conversationInfoJson,
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) {
    final List<ChatMemberModel> memberList = List<ChatMemberModel>.from(
      conversationInfoJson["listMember"].map((x) => ChatMemberModel.fromMap(x)),
    );

    MessageType? messageType;
    try {
      messageType = MessageTypeExt.valueOf(conversationInfoJson["messageType"]);
    } catch (e) {}

    var conversationLastMessage = conversationInfoJson["message"] ?? '';

    String message =
        messageType?.displayMessageType(conversationLastMessage) ?? '';
    // : await _userNameRepo.replaceIdByUserName(e["message"]);

    final model = ChatItemModel.fromMap(
      conversationInfoJson,
      messageType: messageType,
      message: message,
      memberList: memberList,
      currentUserInfo: currentUserInfo,
      currentUserType: currentUserType,
    );

    var firstOtherMember = model.firstOtherMember(currentUserId);

    model.conversationBasicInfo
      ..id = model.effectiveId(currentUserId)
      ..name = model.effectiveConversationName(currentUserId)
      ..avatar = model.effectiveConversationAvatar(currentUserId)
      ..userStatus = model.currentCoversationUserStatus(currentUserId)
      ..lastActive = model.isGroup ? null : firstOtherMember.lastActive;

    if (!model.isGroup) {
      model.conversationBasicInfo
        ..companyId = firstOtherMember.companyId
        ..userType = firstOtherMember.userType;
      model.status = firstOtherMember.status;
    } else {
      model.conversationBasicInfo.totalGroupMemebers = memberList.length;
    }

    return model;
  }

  // ChatItemModel copyWithEdited(String message) => ChatItemModel(
  //       conversationId: conversationId,
  //       numberOfUnReadMessgae: numberOfUnreadMessage.state.counter,
  //       isGroup: isGroup,
  //       senderId: senderId,
  //       message: message,
  //       messageType: messageType,
  //       totalNumberOfMessages: totalNumberOfMessages,
  //       messageDisplay: messageDisplay,
  //       typeGroup: typeGroup,
  //       adminId: adminId,
  //       adminName: adminName,
  //       browerMemberList: browerMemberList?,
  //       memberList: memberList,
  //       isFavorite: isFavorite,
  //       isHidden: false,
  //       createAt: createAt,
  //       conversationBasicInfo: conversationBasicInfo,
  //     );

  @override
  String toString() => conversationId.toString();

  @override
  List<Object?> get props => [conversationId, senderId, createAt];
}

extension on List<ChatMemberModel> {
  String get names => map((e) => e.name).join(', ');
}
