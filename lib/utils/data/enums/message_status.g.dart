// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageStatusAdapter extends TypeAdapter<MessageStatus> {
  @override
  final int typeId = 19;

  @override
  MessageStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return MessageStatus.normal;
      case 1:
        return MessageStatus.deleted;
      case 2:
        return MessageStatus.edited;
      case 3:
        return MessageStatus.sending;
      case 4:
        return MessageStatus.deleting;
      case 5:
        return MessageStatus.sendError;
      default:
        return MessageStatus.normal;
    }
  }

  @override
  void write(BinaryWriter writer, MessageStatus obj) {
    switch (obj) {
      case MessageStatus.normal:
        writer.writeByte(0);
        break;
      case MessageStatus.deleted:
        writer.writeByte(1);
        break;
      case MessageStatus.edited:
        writer.writeByte(2);
        break;
      case MessageStatus.sending:
        writer.writeByte(3);
        break;
      case MessageStatus.deleting:
        writer.writeByte(4);
        break;
      case MessageStatus.sendError:
        writer.writeByte(5);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
