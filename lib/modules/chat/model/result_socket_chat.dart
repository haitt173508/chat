import 'dart:convert';

import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/message_status.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'result_socket_chat.g.dart';

String sockeSentMessageModelToHiveObjectJson(SocketSentMessageModel model) {
  var hiveObjectMap = model.toHiveObjectMap();
  return json.encode(hiveObjectMap);
}

SocketSentMessageModel sockeSentMessageModelFromHiveObjectJson(
  String encoded, {
  CurrentUserInfoModel? currentInfo,
}) =>
    SocketSentMessageModel.fromHiveObjectMap(
      json.decode(encoded),
      currentInfo: currentInfo,
    );

@HiveType(typeId: HiveTypeId.socketSentMessageModelHiveTypeId)
class SocketSentMessageModel extends Equatable {
  SocketSentMessageModel({
    required this.conversationId,
    required this.messageId,
    required this.senderId,
    this.emotion = const {},
    this.type,
    this.message,
    this.relyMessage,
    required this.createAt,
    this.files,
    this.infoLink,
    this.contact,
    MessageStatus? messageStatus,
    this.linkNotification,
    required this.autoDeleteMessageTimeModel,
  }) : this._messageStatus = messageStatus ?? MessageStatus.normal;

  @HiveField(0)
  final int conversationId;
  @HiveField(1)
  final String messageId;
  @HiveField(2)
  final int senderId;
  @HiveField(3)
  final MessageType? type;
  @HiveField(4)
  final String? message;
  @HiveField(5)
  Map<Emoji, Emotion> emotion;
  @HiveField(6)
  final ApiRelyMessageModel? relyMessage;
  @HiveField(7)
  final DateTime createAt;
  @HiveField(8)
  final List<ApiFileModel>? files;
  @HiveField(9)
  final InfoLink? infoLink;
  @HiveField(10)
  final IUserInfo? contact;
  @HiveField(11)
  MessageStatus _messageStatus;
  @HiveField(12)
  final String? linkNotification;
  @HiveField(13)
  final AutoDeleteMessageTimeModel autoDeleteMessageTimeModel;

  MessageStatus get messageStatus => _messageStatus;

  set messageStatus(MessageStatus nextStatus) {
    if (messageStatus != MessageStatus.deleted) _messageStatus = nextStatus;
  }

  bool get hasRelyMessage => relyMessage != null;

  factory SocketSentMessageModel.fromMap(
    Map<String, dynamic> map, {
    IUserInfo? userInfo,
    UserType? userType,
  }) =>
      SocketSentMessageModel(
        conversationId: map['conversationID'],
        messageId: map['messageID'],
        senderId: map['senderID'],
        type: MessageTypeExt.valueOf(map['messageType']),
        message: map['message'],
        emotion: Emotion.mapEmojiEmotionFromJson(map['emotionMessage'] ?? []),
        relyMessage: map['quoteMessage'] == null
            ? null
            : ApiRelyMessageModel.fromMap(map['quoteMessage']),
        createAt: DateTimeExt.timeZoneParse(map['createAt']),
        files: map['listFile'] == null
            ? null
            : List.from(map['listFile'])
                .map(
                  (e) => ApiFileModel(
                    fileName: e['fullName'],
                    resolvedFileName: e['fullName'],
                    fileType: MessageTypeExt.valueOf(e['typeFile']),
                    displayFileSize: e['fileSizeInByte'],
                    fileSize: e['sizeFile'],
                    imageSource: e['imageSource'],
                    width: e['width'],
                    height: e['height'],
                    uploaded: true,
                  ),
                )
                .toList(),
        infoLink: map['infoLink'] == null
            ? null
            : InfoLink.fromMap(
                map['infoLink'],
                link: map['message'],
                currentUserInfo: userInfo,
                currentUserType: userType,
              ),
        contact: map['userProfile'] != null
            ? ApiContact.fromMyContact(map['userProfile'])
            : null,
        messageStatus: map['isEdited'] == 1 ? MessageStatus.edited : null,
        linkNotification:
            map['linkNotification'] == null ? null : map['linkNotification'],
        autoDeleteMessageTimeModel: AutoDeleteMessageTimeModel.fromJson(map),
      );

  factory SocketSentMessageModel.fromMapOfSocket(
    Map<String, dynamic> map, {
    CurrentUserInfoModel? currentInfo,
  }) {
    final messageType = MessageTypeExt.valueOf(map['MessageType']);

    final String? message = map['Message'];
    return SocketSentMessageModel(
      conversationId: map['ConversationID'] is String
          ? int.parse(map['ConversationID'])
          : map['ConversationID'],
      messageId: map['MessageID'],
      senderId: map['SenderID'] is String
          ? int.parse(map['SenderID'])
          : map['SenderID'],
      type: messageType,
      message: messageType.displayMessageType(message),
      emotion: Emotion.mapEmojiEmotionFromJson(map["Emotion"] ?? []),
      relyMessage: map['QuoteMessage'] == null ||
              map['QuoteMessage']?['MessageID']?.isEmpty == true
          ? null
          : ApiRelyMessageModel.fromMapOfSocket(map['QuoteMessage']),
      createAt: map['CreateAt'] == null
          ? DateTime.now()
          : DateTimeExt.timeZoneParse(map['CreateAt']),
      files: map['ListFile'] == null || map['ListFile']?.isEmpty == true
          ? null
          : List.from(map['ListFile'])
              .map(
                (e) => ApiFileModel(
                  fileName: e['FullName'],
                  resolvedFileName: e['FullName'],
                  fileType: MessageTypeExt.valueOf(e['TypeFile']),
                  displayFileSize: e['FileSizeInByte'],
                  fileSize: e['SizeFile'],
                  imageSource: e['ImageSource'],
                  width: e['Width'] is int
                      ? double.parse(e['Width'].toString())
                      : e['Width'],
                  height: e['Height'] is int
                      ? double.parse(e['Height'].toString())
                      : e['Height'],
                  uploaded: true,
                ),
              )
              .toList(),
      infoLink: map['InfoLink'] == null
          ? null
          : InfoLink.fromMapOfSocket(
              map['InfoLink'],
              link: map['Message'],
              currentUserInfo: currentInfo?.userInfo,
              currentUserType: currentInfo?.userType,
            ),
      contact: messageType.isNotContactCard || map["UserProfile"] == null
          ? null
          : ApiContact.fromSocketContact(map["UserProfile"]),
      messageStatus: map['MessageStatus'] != null
          ? MessageStatus.values.elementAt(map['MessageStatus'])
          : null,
      autoDeleteMessageTimeModel: AutoDeleteMessageTimeModel.fromJson(map),
    );
  }

  /// Thay đổi
  /// - [files]
  /// - [type]
  /// - [message]: edit tin nhắn
  SocketSentMessageModel copyWith({
    MessageType? type,
    String? message,
    MessageStatus? status,
    // String? messageId,
    // int? emotion,
    // ApiRelyMessageModel? relyMessage,
    // DateTime? createAt,
    // String? fileName,
    // int? fileSize,
    List<ApiFileModel>? files,
    InfoLink? infoLink,
  }) =>
      SocketSentMessageModel(
        files: files,
        conversationId: this.conversationId,
        senderId: this.senderId,
        messageId: this.messageId,
        type: type ?? this.type,
        message: message ?? this.message,
        contact: this.contact,
        infoLink: infoLink ?? this.infoLink,
        createAt: this.createAt,
        relyMessage: this.relyMessage,
        messageStatus: status ?? this.messageStatus,
        autoDeleteMessageTimeModel: this.autoDeleteMessageTimeModel,
      );

  Map<String, dynamic> toMap() => {
        'MessageID': messageId,
        'ConversationID': conversationId,
        'SenderID': senderId,
        'MessageType': type!.databaseName,
        'Message': message,
        'Emotion': emotion,
        'Quote': relyMessage?.toMap(),
        'CreateAt': DateTimeExt.serverDateFormat.format(createAt),
        'InfoLink': infoLink?.toMap(),
        'Profile': contact == null ? null : contact!.toJsonString(),
        'ListFile': files?.map((e) => e.toMap()),
      }..addAll(autoDeleteMessageTimeModel.toMapOfSocket());

  Map<String, dynamic> toHiveObjectMap() {
    List<Map<String, dynamic>> emotionMapObject =
        emotion.values.map((e) => e.toMap()).toList();
    return {
      'MessageID': messageId,
      'ConversationID': conversationId,
      'SenderID': senderId,
      'MessageType': type!.databaseName,
      'Message': message,
      'Emotion': emotionMapObject,
      'Quote': relyMessage?.toMap(),
      'CreateAt': createAt.toTimezoneFormatString(),
      'InfoLink': infoLink?.toMap(),
      'UserProfile': contact != null
          ? ApiContact(
              name: contact!.name,
              avatar: contact!.avatar,
              id: contact!.id,
              companyId: contact!.companyId,
              lastActive: contact!.lastActive,
            ).toHiveObjectMap()
          : null,
      'ListFile': files?.map((e) => e.toMap()).toList(),
      'MessageStatus': messageStatus.index,
    };
  }

  factory SocketSentMessageModel.fromHiveObjectMap(
    Map<String, dynamic> map, {
    CurrentUserInfoModel? currentInfo,
  }) =>
      SocketSentMessageModel.fromMapOfSocket(map, currentInfo: currentInfo);

  Map<String, dynamic> toMapOfEditedMessage() => {
        'MessageID': messageId,
        'Message': message,
      };

  @override
  String toString() => (toMap()..remove('Emotion')).toString();

  @override
  List<Object?> get props => [conversationId, messageId];
}

@HiveType(typeId: HiveTypeId.infoLinkHiveTypeId)
class InfoLink {
  InfoLink({
    this.messageId,
    this.description,
    this.title,
    this.linkHome,
    this.image,
    this.haveImage = false,
    this.isNotification = false,
    this.link,
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) : fullLink = !link.isBlank && isNotification
            ? GeneratorService.generate365Link(
                link!,
                currentUserInfo: currentUserInfo,
                currentUserType: currentUserType,
              )
            : (linkHome ?? '');

  @HiveField(0)
  final String? messageId;
  @HiveField(1)
  final String? description;
  @HiveField(2)
  final String? title;
  @HiveField(3)
  final String? linkHome;
  @HiveField(4)
  final String? image;
  @HiveField(5)
  final bool haveImage;
  @HiveField(6)
  final String? link;
  @HiveField(7)
  final bool isNotification;

  late final String fullLink;

  factory InfoLink.fromMap(
    Map<String, dynamic> map, {
    required String? link,
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) =>
      InfoLink(
        messageId: map['messageID'],
        description: map['description'],
        title: map['title'],
        linkHome: map['linkHome'] ?? "",
        image: map['image'],
        haveImage: map['haveImage'] == "True",
        link: (link.isBlank ? null : link) ?? map['linkHome'],
        isNotification: map['isNotification'] == 1,
        currentUserInfo: currentUserInfo,
        currentUserType: currentUserType,
      );

  factory InfoLink.fromMapOfSocket(
    Map<String, dynamic> map, {
    required String? link,
    IUserInfo? currentUserInfo,
    UserType? currentUserType,
  }) =>
      InfoLink(
        messageId: map['MessageID'],
        description: map['Description'],
        title: map['Title'],
        linkHome: map['LinkHome'],
        image: map['Image'],
        haveImage: map['HaveImage'] == "True",
        link: (link.isBlank ? null : link) ?? map['LinkHome'],
        isNotification: map['IsNotification'] == 1,
        currentUserInfo: currentUserInfo,
        currentUserType: currentUserType,
      );

  Map<String, dynamic> toMap() => {
        'MessageID': messageId,
        'Description': description,
        'Title': title,
        'LinkHome': linkHome,
        'Image': image,
        'HaveImage': haveImage,
        'IsNotification': isNotification ? 1 : 0,
      };
}

/// Gồm [Emoji] và ds userId
@HiveType(typeId: HiveTypeId.emotionHiveTypeId)
class Emotion extends Equatable {
  Emotion({
    required this.type,
    required List<int> listUserId,
    required this.isChecked,
  }) : listUserId = [...listUserId];

  @HiveField(0)
  final Emoji type;
  @HiveField(1)
  final List<int> listUserId;
  @HiveField(2)
  final bool isChecked;

  factory Emotion.fromMap(Map<String, dynamic> json) {
    // List<int>.from((json["listUserId"] as List).map((e) => int.tryParse(e))),
    List<int> listUserIds = ((json["listUserId"] as List)
            .map((e) => int.tryParse(e.toString()))
            .toList()
          ..removeWhere((e) => e == null))
        .cast();
    return Emotion(
      type: Emoji.fromId(json["type"]),
      listUserId: listUserIds,
      isChecked: json["isChecked"] ?? false,
    );
  }

  static Map<Emoji, Emotion> emptyEmojiEmotion() => mapEmojiEmotionFromJson([]);

  toHiveObjectMap() => toMap();

  Map<String, dynamic> toMap() => {
        "type": type.id,
        "listUserId": listUserId,
        "isChecked": isChecked,
      };

  static Map<Emoji, Emotion> mapEmojiEmotionFromJson(List json) {
    var map = Map<Emoji, Emotion>.fromIterable(
      Emoji.values,
      value: (emotion) => Emotion(
        type: emotion,
        listUserId: [],
        isChecked: false,
      ),
    );
    json.forEach((element) {
      var emotion = Emotion.fromMap(element);
      map[emotion.type] = emotion;
    });
    return map;
  }

  didReact(int userId) => listUserId.contains(userId);

  @override
  List<Object?> get props => [type, ...listUserId];
}
