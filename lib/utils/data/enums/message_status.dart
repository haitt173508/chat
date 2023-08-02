import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_status.g.dart';

/// Trạng thái của [SocketSentMessageModel] hiện tại
@HiveType(typeId: HiveTypeId.messageStatusHiveTypeId)
enum MessageStatus {
  @HiveField(0)
  normal,
  @HiveField(1)
  deleted,
  @HiveField(2)
  edited,
  @HiveField(3)
  sending,
  @HiveField(4)
  deleting,
  @HiveField(5)
  sendError,
}

extension MessageStatusExt on MessageStatus {
  String get name {
    switch (this) {
      case MessageStatus.sending:
        return StringConst.sending;
      case MessageStatus.deleting:
        return StringConst.deleting;
      default:
        return '';
    }
  }

  static final _enableInteractive = {
    MessageStatus.normal: true,
    MessageStatus.deleted: false,
    MessageStatus.edited: true,
    MessageStatus.sending: false,
    MessageStatus.deleting: false,
    MessageStatus.sendError: false,
  };

  bool get enableInteractive => _enableInteractive[this]!;
}
