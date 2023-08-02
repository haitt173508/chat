// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_text_size.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageTextSizeAdapter extends TypeAdapter<MessageTextSize> {
  @override
  final int typeId = 26;

  @override
  MessageTextSize read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageTextSize.small;
      case 1:
        return MessageTextSize.normal;
      case 2:
        return MessageTextSize.large;
      case 3:
        return MessageTextSize.superLarge;
      default:
        return MessageTextSize.small;
    }
  }

  @override
  void write(BinaryWriter writer, MessageTextSize obj) {
    switch (obj) {
      case MessageTextSize.small:
        writer.writeByte(0);
        break;
      case MessageTextSize.normal:
        writer.writeByte(1);
        break;
      case MessageTextSize.large:
        writer.writeByte(2);
        break;
      case MessageTextSize.superLarge:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageTextSizeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
