import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/chat_file_type.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:hive_flutter/adapters.dart';

part 'message_type.g.dart';

@HiveType(typeId: HiveTypeId.messageTypeHiveId)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  file,
  @HiveField(3)
  time,
  @HiveField(4)
  contact,
  @HiveField(5)
  notification,
  @HiveField(6)
  link,
  @HiveField(7)
  map,

  /// cuộc gọi nhỡ
  @HiveField(8)
  missVideoCall,

  /// không bắt máy.
  @HiveField(9)
  timeoutVideoCall,

  /// bị hủy
  @HiveField(10)
  rejectVideoCall,

  /// cuộc gọi đến, đi
  @HiveField(11)
  mettingVideoCall,

  ///  ứng viên ứng tuyển
  @HiveField(12)
  applying,

  ///  gửi đề xuất
  @HiveField(13)
  OfferReceive,

  /// Không xác định
  @HiveField(14)
  unknown,

  /// document
  @HiveField(15)
  document,
  // nhắc hẹn
  @HiveField(16)
  appointment,
}

extension MessageTypeExt on MessageType {
  String get name {
    switch (this) {
      case MessageType.text:
        return 'text';
      case MessageType.image:
        return 'sendPhoto';
      case MessageType.file:
        return 'sendFile';
      case MessageType.time:
        return 'date';
      case MessageType.contact:
        return 'sendProfile';
      case MessageType.notification:
        return 'notification';
      case MessageType.link:
        return 'link';
      case MessageType.map:
        return 'map';
      case MessageType.missVideoCall:
        return 'missVideoCall';
      case MessageType.timeoutVideoCall:
        return 'timeoutVideoCall';
      case MessageType.rejectVideoCall:
        return 'rejectVideoCall';
      case MessageType.mettingVideoCall:
        return 'mettingVideoCall';
      case MessageType.applying:
        return 'applying';
      case MessageType.OfferReceive:
        return 'OfferReceive';
      case MessageType.document:
        return 'document';
      case MessageType.appointment:
        return 'appointment';
      case MessageType.unknown:
        return '';
    }
  }

  String get databaseName => name;

  ChatFileType? get fileType {
    switch (this) {
      case MessageType.image:
        return ChatFileType.image;
      case MessageType.file:
        return ChatFileType.file;
      default:
        return null;
    }
  }

  String displayMessageType(
    String? message, {
    bool? isSentByCurrentUser,
  }) {
    if (isImage) return StringConst.sharedImage;
    if (isFile) return StringConst.sharedFile;
    if (isContactCard) return StringConst.sharedContact;
    if (isLink && message.isBlank) return StringConst.sharedLink;
    if (isMap) return StringConst.location;
    if (this == MessageType.missVideoCall) return 'Cuộc gọi nhỡ';
    if (this == MessageType.timeoutVideoCall) return 'Không bắt máy.';
    if (this == MessageType.rejectVideoCall) return 'Bị hủy';
    if (this == MessageType.mettingVideoCall)
      return isSentByCurrentUser == true ? 'Cuộc gọi đi' : 'Cuộc gọi đến';
    return message.isBlank ? '' : message!;
  }

  bool get isText => this == MessageType.text;

  bool get isNotText => !isText;

  bool get isFile => this == MessageType.image || this == MessageType.file;

  bool get isTime => this == MessageType.time;

  bool get isNotification => this == MessageType.notification;

  bool get isNotMessage => isTime || isNotification;

  bool get isContactCard => this == MessageType.contact;

  bool get isNotContactCard => !isContactCard;

  bool get isImage => this == MessageType.image;

  bool get isLink => this == MessageType.link;

  bool get isEditable => this == MessageType.text;

  bool get isMap => this == MessageType.map;

  bool get isVideoCall =>
      this == MessageType.mettingVideoCall ||
      this == MessageType.missVideoCall ||
      this == MessageType.rejectVideoCall ||
      this == MessageType.timeoutVideoCall;

  bool get isOfferRecieved => this == MessageType.OfferReceive;

  bool get isApplying => this == MessageType.applying;

  bool get isDocument => this == MessageType.document;
  bool get isAppointment => this == MessageType.appointment;

  bool get isSpecialType =>
      this.isApplying || this.isDocument || this.isOfferRecieved;

  static MessageType valueOf(String name) {
    try {
      return MessageType.values.firstWhere((e) => e.name == name);
    } catch (e) {
      return MessageType.unknown;
      throw DataNotFoundException(
          "MessageType.name == $name", 'MessageType.valueOf');
    }
  }

  static MessageType fromFileExtension(String ext) {
    try {
      if (AppConst.supportImageTypes.contains(ext.toLowerCase())) {
        return MessageType.image;
      }

      // if (AppConst.supportNonImageFileTypes.contains(ext)) {
      return MessageType.file;
      // }

      throw Exception();
    } catch (e) {
      logger.logError(ext);
      throw DataNotFoundException("$ext", 'MessageType.fromFileExtension');
    }
  }

  int get libraryTabIndex {
    switch (this) {
      case MessageType.image:
        return 0;
      case MessageType.link:
        return 1;
      case MessageType.file:
        return 2;
      default:
        return 0;
    }
  }

  String get libraryTabLabel {
    switch (this) {
      case MessageType.image:
        return 'Phương tiện';
      case MessageType.link:
        return 'Liên kết';
      case MessageType.file:
        return 'Tệp';
      default:
        return '';
    }
  }

  static final _videoCallDisplayMessageIconAssetPath = {
    MessageType.missVideoCall: Images.ic_camera_video_missing,
    MessageType.rejectVideoCall: Images.ic_camera_video_rejected,
    MessageType.timeoutVideoCall: Images.ic_camera_video_rejected,
  };

  String videoCallDisplayMessageIconAssetPath(
      {bool isSendByCurrentUser = false}) {
    if (this == MessageType.mettingVideoCall) {
      if (isSendByCurrentUser)
        return Images.ic_camera_video_send_success;
      else
        return Images.ic_camera_video_recieve_success;
    }
    return _videoCallDisplayMessageIconAssetPath[this]!;
  }

  static List<MessageType> get libraryType => [
        MessageType.image,
        MessageType.link,
        MessageType.file,
      ];
}
