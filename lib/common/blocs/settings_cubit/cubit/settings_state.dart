import 'package:chat_365/common/models/message_setting_model.dart';
import 'package:chat_365/common/models/message_setting_model_item.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/enums/message_setting_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'settings_state.g.dart';

@HiveType(typeId: HiveTypeId.settingStateHiveTypeId)
class SettingState {
  // SettingState({
  //   this.seenMessage = false,
  //   this.autoDownloadImage = false,
  //   this.autoDownloadFile = false,
  //   this.pasteCopiedMessageAsQuoteMessage = false,
  //   this.previewWeb = false,
  //   double? messageSize,
  // }) : this.messageSize = messageSize ?? AppConst.kDefaultMessageFontSize;

  SettingState({
    MessageSettingModel? settingsModel,
  }) : this.settingsModel = settingsModel ?? MessageSettingModel();

  /// Message settings
  // @HiveField(0)
  // bool seenMessage;
  // @HiveField(1)
  // double messageSize;
  // @HiveField(2)
  // bool autoDownloadImage;
  // @HiveField(3)
  // bool autoDownloadFile;
  // @HiveField(4)
  // bool pasteCopiedMessageAsQuoteMessage;
  // @HiveField(5)
  // bool previewWeb;

  @HiveField(0)
  final MessageSettingModel settingsModel;

  SettingState updateMessageSetting(MessageSettingModelItem item) => SettingState(
        settingsModel: settingsModel..update(item),
      );

  copyWith({
    bool? seenMessage,
    double? messageSize,
    bool? autoDownloadImage,
    bool? autoDownloadFile,
    bool? pasteCopiedMessageAsQuoteMessage,
    bool? previewWeb,
  }) {
    final settings = settingsModel.settings;
    if (seenMessage != null)
      (settings[MessageSettingType.seenMessage] as MessageSettingModelItem)
          .selectedValue = seenMessage;
    if (messageSize != null)
      (settings[MessageSettingType.messageFontSize] as MessageSettingModelItem)
          .selectedValue = messageSize;
    if (autoDownloadImage != null)
      (settings[MessageSettingType.autoDownloadImage]
              as MessageSettingModelItem)
          .selectedValue = autoDownloadImage;
    if (autoDownloadFile != null)
      (settings[MessageSettingType.autoDownloadFile] as MessageSettingModelItem)
          .selectedValue = autoDownloadFile;
    if (pasteCopiedMessageAsQuoteMessage != null)
      (settings[MessageSettingType.pasteCopiedMessageAsQuoteMessage]
              as MessageSettingModelItem)
          .selectedValue = pasteCopiedMessageAsQuoteMessage;
    if (previewWeb != null)
      (settings[MessageSettingType.previewWeb] as MessageSettingModelItem)
          .selectedValue = previewWeb;
  }
}
