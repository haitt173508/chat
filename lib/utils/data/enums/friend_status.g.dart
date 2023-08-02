// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FriendStatusAdapter extends TypeAdapter<FriendStatus> {
  @override
  final int typeId = 18;

  @override
  FriendStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FriendStatus.decline;
      case 1:
        return FriendStatus.send;
      case 2:
        return FriendStatus.request;
      case 3:
        return FriendStatus.accept;
      case 4:
        return FriendStatus.unknown;
      default:
        return FriendStatus.decline;
    }
  }

  @override
  void write(BinaryWriter writer, FriendStatus obj) {
    switch (obj) {
      case FriendStatus.decline:
        writer.writeByte(0);
        break;
      case FriendStatus.send:
        writer.writeByte(1);
        break;
      case FriendStatus.request:
        writer.writeByte(2);
        break;
      case FriendStatus.accept:
        writer.writeByte(3);
        break;
      case FriendStatus.unknown:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FriendStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
