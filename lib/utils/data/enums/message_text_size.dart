import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_text_size.g.dart';

@HiveType(typeId: HiveTypeId.messageTextSizeTypeId)
enum MessageTextSize {
  @HiveField(0)
  small,
  @HiveField(1)
  normal,
  @HiveField(2)
  large,
  @HiveField(3)
  superLarge,
}

extension MessageTextSizeExt on MessageTextSize {
  double get fontSize {
    switch (this) {
      case MessageTextSize.small:
        return 14;
      case MessageTextSize.normal:
        return 16;
      case MessageTextSize.large:
        return 18;
      case MessageTextSize.superLarge:
        return 20;
    }
  }

  String get fontSizeName {
    switch (this) {
      case MessageTextSize.small:
        return 'Nhỏ';
      case MessageTextSize.normal:
        return 'Bình thường';
      case MessageTextSize.large:
        return 'Lớn';
      case MessageTextSize.superLarge:
        return 'Rất lớn';
    }
  }
}
