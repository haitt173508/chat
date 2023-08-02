import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_setting_type.g.dart';

@HiveType(typeId: HiveTypeId.messageSettingTypeTypeId)
enum MessageSettingType {
  @HiveField(0)
  seenMessage,
  @HiveField(1)
  messageFontSize,
  @HiveField(2)
  autoDownloadImage,
  @HiveField(3)
  autoDownloadFile,
  @HiveField(4)
  pasteCopiedMessageAsQuoteMessage,
  @HiveField(5)
  previewWeb,
}
