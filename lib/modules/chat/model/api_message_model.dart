import 'dart:convert';

import 'package:chat_365/common/models/auto_delete_message_time_model.dart';
import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/num_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'api_message_model.g.dart';

/// Model gửi message lên socket
class ApiMessageModel extends Equatable {
  final String messageId;
  final int conversationId;
  final int senderId;
  final MessageType type;
  final String? message;
  final int? emotion;
  final ApiRelyMessageModel? relyMessage;
  final List<ApiFileModel>? files;
  final IUserInfo? contact;
  final DateTime? createdAt;
  final InfoLink? infoLink;
  final AutoDeleteMessageTimeModel autoDeleteMessageTimeModel;

  ApiMessageModel({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    this.type = MessageType.text,
    this.message,
    this.emotion,
    this.relyMessage,
    this.files,
    this.contact,
    this.createdAt,
    this.infoLink,
    AutoDeleteMessageTimeModel? initAutoDeleteMessageTimeModel,
  }) : autoDeleteMessageTimeModel = initAutoDeleteMessageTimeModel ??
            AutoDeleteMessageTimeModel.defaultModel();

  ApiMessageModel copyWith({
    String? messageId,
    MessageType? type,
    String? message,
    int? emotion,
    ApiRelyMessageModel? relyMessage,
    List<ApiFileModel>? files,
    IUserInfo? contact,
    int? conversationId,
  }) =>
      ApiMessageModel(
        messageId: messageId ?? GeneratorService.generateMessageId(senderId),
        conversationId: conversationId ?? this.conversationId,
        senderId: this.senderId,
        type: type ?? this.type,
        message: message,
        emotion: emotion,
        relyMessage: relyMessage ?? this.relyMessage,
        files: files ?? this.files,
        contact: contact ?? this.contact,
        createdAt: this.createdAt,
        infoLink: this.infoLink,
        initAutoDeleteMessageTimeModel: autoDeleteMessageTimeModel,
      );

  List<ApiMessageModel> copyWithSeperatedFiles() => (files ?? [])
      .map(
        (e) => ApiMessageModel(
          messageId: messageId,
          conversationId: conversationId,
          senderId: senderId,
          files: [e],
          type: type,
          initAutoDeleteMessageTimeModel: autoDeleteMessageTimeModel,
        ),
      )
      .toList();

  ApiMessageModel copyWithNewMessage({
    required MessageType type,
    String? message,
    int? emotion,
    ApiRelyMessageModel? relyMessage,
    List<ApiFileModel>? files,
    ApiContact? contact,
  }) =>
      ApiMessageModel(
        messageId: GeneratorService.generateMessageId(senderId),
        conversationId: conversationId,
        senderId: senderId,
        type: type,
        message: message,
        emotion: emotion,
        relyMessage: relyMessage,
        files: files,
        contact: contact,
        initAutoDeleteMessageTimeModel: autoDeleteMessageTimeModel,
      );

  Map<String, dynamic> toMap() => {
        'MessageID': messageId,
        'ConversationID': conversationId.toString(),
        'SenderID': senderId.toString(),
        'MessageType': type.name,
        'Message': contact != null ? contact!.id : message,
        'Emotion': (emotion ?? 0).toString(),
        // 'Quote': relyMessage?.toMap().toString(),
        'Quote': relyMessage?.toJsonString(),
        'File': files == null
            ? ''
            : files!.map((e) => e.toJsonString()).toList().toString(),
        'Profile': contact == null ? null : contact!.toJsonString(),
      }..addAll(autoDeleteMessageTimeModel.toMapOfSocket());

  Map<String, dynamic> toMapOfDeleteMessage() => {
        'MessageID': messageId,
        'ConversationID': conversationId.toString(),
        'SenderID': senderId.toString(),
        'MessageType': null,
        'Message': null,
        'Emotion': null,
        'Quote': null,
        'File': null,
        'Profile': null,
      };

  Map<String, dynamic> toMapOfEditedMessage() => {
        'ConversationID': conversationId,
        'MessageID': messageId,
        'Message': message,
      };

  SocketSentMessageModel toServerMessageModel() => SocketSentMessageModel(
        conversationId: conversationId,
        messageId: messageId,
        senderId: senderId,
        type: type,
        message: message,
        // emotion: emotion,
        relyMessage: relyMessage,
        createAt: DateTime.now(),
        infoLink: null,
        autoDeleteMessageTimeModel: autoDeleteMessageTimeModel,
      );

  @override
  List<Object?> get props => [messageId];
}

@HiveType(typeId: HiveTypeId.apiFileModelHiveTypeId)
class ApiFileModel extends Equatable {
  @HiveField(0)
  final String _fileName;
  @HiveField(1)
  final String resolvedFileName;
  @HiveField(2)
  final MessageType fileType;
  @HiveField(3)
  final int fileSize;
  @HiveField(4)
  final String displayFileSize;
  @HiveField(5)
  final String? imageSource;
  @HiveField(6)
  final num width;
  @HiveField(7)
  final num height;

  /// Check file đã upload trên server chưa,
  /// - trường hợp chuyển tiếp file, giá trị [true]
  /// - chọn file từ local, giá trị bằng [false]
  @HiveField(8)
  final bool uploaded;

  @HiveField(9)
  final String? filePath;

  late final String originFileName;

  ApiFileModel({
    required String fileName,
    String? resolvedFileName,
    required this.fileType,
    required this.fileSize,
    String? displayFileSize,
    this.imageSource,
    this.width = 0,
    this.height = 0,
    this.filePath,
    this.uploaded = false,
  })  : _fileName = fileName.replaceAll(RegExp(r'^(\d+-)+'), ''),
        resolvedFileName =
            resolvedFileName ?? GeneratorService.generateFileName(fileName),
        displayFileSize = displayFileSize ?? fileSize.fizeSizeString() {
    originFileName = this.resolvedFileName.originFileNameFromServerUri;
  }

  String get fileName => _fileName;

  String get fullFilePath {
    if (fileType.isImage) {
      return ApiPath.imageDomain + resolvedFileName;
    }
    if (fileType.isFile) {
      return ApiPath.fileDomain + resolvedFileName;
    }
    logger.logError('Unimplement fullFilePath $fileType');
    return '';
  }

  String get downloadPath => ApiPath.downloadDomain + resolvedFileName;

  // ApiFileModel copyWith({
  //   String fileName,
  //   int fileSize,
  // }) =>
  //     ApiFileModel(
  //       conversationId: conversationId,
  //       senderId: senderId,
  //       type: type,
  //       message: message,
  //       emotion: emotion,
  //       relyMessage: relyMessage,
  //       fileName: fileName,
  //       fileSize: fileSize,
  //     );

  Map<String, dynamic> toMap() => {
        'FullName': resolvedFileName,
        'NameDisplay': fileName,
        'TypeFile': fileType.databaseName,
        'SizeFile': fileSize,
        'ImageSource': imageSource,
        'FileSizeInByte': displayFileSize,
        'Width': width,
        'Height': height,
      };

  String toJsonString() => '''{
        "FullName": "$resolvedFileName",
        "NameDisplay": "$fileName",
        "TypeFile": "${fileType.databaseName}",
        "SizeFile": $fileSize,
        "ImageSource": $imageSource,
        "FileSizeInByte": "${fileSize.fizeSizeString()}",
        "Width": $width,
        "Height": $height,
        "isDownnLoad": "False",
      }''';

  @override
  List<Object?> get props => [resolvedFileName];
}

@HiveType(typeId: HiveTypeId.apiRelyMessageModelHiveTypeId)
class ApiRelyMessageModel {
  @HiveField(0)
  final String messageId;
  @HiveField(1)
  final int senderId;
  @HiveField(2)
  final String? senderName;
  @HiveField(3)
  final MessageType? type;
  @HiveField(4)
  final String? message;
  @HiveField(5)
  final DateTime createAt;

  ApiRelyMessageModel({
    required this.messageId,
    required this.senderId,
    required this.senderName,
    this.type,
    this.message,
    required this.createAt,
  });

  factory ApiRelyMessageModel.fromMap(Map<String, dynamic> map) =>
      ApiRelyMessageModel(
        messageId: map['messageID'],
        senderId: map['senderID'],
        senderName: map['senderName'],
        type: MessageTypeExt.valueOf(map['messageType']),
        message: map['message'],
        createAt: DateTime.parse(map['createAt']),
      );

  factory ApiRelyMessageModel.fromMapOfSocket(Map<String, dynamic> map) =>
      ApiRelyMessageModel(
        messageId: map['MessageID'],
        senderId: map['SenderID'],
        senderName: map['senderName'],
        type: MessageTypeExt.valueOf(map['MessageType']),
        message: map['Message'],
        createAt: DateTime.parse(map['CreateAt']),
      );

  Map<String, dynamic> toMap() => {
        'MessageID': messageId,
        'SenderID': senderId.toString(),
        'SenderName': senderName,
        'MessageType': type!.databaseName,
        'Message': message,
        'CreateAt': createAt.toString(),
      };

  String toJsonString() => '''{
        "MessageID": "$messageId",
        "SenderID": "${senderId.toString()}",
        "SenderName": "$senderName",
        "MessageType": "${(type ?? MessageType.text).databaseName}",
        "Message": ${json.encode(message)},
        "CreateAt": "${createAt.toString()}",
      }''';
}
