import 'package:chat_365/common/models/message_setting_model_item.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/enums/message_setting_type.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_setting_model.g.dart';

@HiveType(typeId: HiveTypeId.messageSettingModelTypeId)
class MessageSettingModel {
  MessageSettingModel({
    Map<MessageSettingType, MessageSettingModelItem>? initSettings,
  }) : this.settings = initSettings ?? _defaultSetting;

  @HiveField(0)
  final Map<MessageSettingType, MessageSettingModelItem> settings;

  MessageSettingModelItem update(MessageSettingModelItem item) {
    return settings.update(
      item.messageSettingType,
      (value) => value..selectedValue = item.selectedValue,
      ifAbsent: () => item,
    );
  }

  static final Map<MessageSettingType, String> _titles = {
    MessageSettingType.seenMessage: 'Thư đã đọc',
    MessageSettingType.messageFontSize: 'Cỡ chữ',
    MessageSettingType.autoDownloadImage: 'Tự động tải ảnh xuống',
    MessageSettingType.autoDownloadFile: 'Tự động tải xuống tệp',
    MessageSettingType.pasteCopiedMessageAsQuoteMessage:
        'Dán tin nhắn đã sao chép dưới dạng trích dẫn',
    MessageSettingType.previewWeb: 'Bản xem trước liên kết web',
  };

  static final Map<MessageSettingType, String?> _contents = {
    MessageSettingType.seenMessage:
        'Gửi và nhận thư báo đã đọc trong cuộc trò chuyện có 20 người tham gia trở xuống',
    MessageSettingType.autoDownloadFile:
        'Các tệp mới nhận được trong cuộc trò chuyện sẽ tự động được tải xuống thiết bị này',
  };

  static String title(MessageSettingType type) => _titles[type]!;
  static String? content(MessageSettingType type) => _contents[type];

  static final Map<MessageSettingType, MessageSettingModelItem>
      _defaultSetting = {
    MessageSettingType.seenMessage: MessageSettingModelItem.seenMessage,
    MessageSettingType.messageFontSize: MessageSettingModelItem.messageFontSize,
    MessageSettingType.autoDownloadImage:
        MessageSettingModelItem.autoDownloadImage,
    MessageSettingType.autoDownloadFile:
        MessageSettingModelItem.autoDownloadFile,
    MessageSettingType.pasteCopiedMessageAsQuoteMessage:
        MessageSettingModelItem.pasteCopiedMessageAsQuoteMessage,
    MessageSettingType.previewWeb: MessageSettingModelItem.previewWeb,
  };
}
