// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_setting_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSettingTypeAdapter extends TypeAdapter<MessageSettingType> {
  @override
  final int typeId = 25;

  @override
  MessageSettingType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageSettingType.seenMessage;
      case 1:
        return MessageSettingType.messageFontSize;
      case 2:
        return MessageSettingType.autoDownloadImage;
      case 3:
        return MessageSettingType.autoDownloadFile;
      case 4:
        return MessageSettingType.pasteCopiedMessageAsQuoteMessage;
      case 5:
        return MessageSettingType.previewWeb;
      default:
        return MessageSettingType.seenMessage;
    }
  }

  @override
  void write(BinaryWriter writer, MessageSettingType obj) {
    switch (obj) {
      case MessageSettingType.seenMessage:
        writer.writeByte(0);
        break;
      case MessageSettingType.messageFontSize:
        writer.writeByte(1);
        break;
      case MessageSettingType.autoDownloadImage:
        writer.writeByte(2);
        break;
      case MessageSettingType.autoDownloadFile:
        writer.writeByte(3);
        break;
      case MessageSettingType.pasteCopiedMessageAsQuoteMessage:
        writer.writeByte(4);
        break;
      case MessageSettingType.previewWeb:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSettingTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
