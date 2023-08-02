// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_contact.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ContactAdapter extends TypeAdapter<ApiContact> {
  @override
  final int typeId = 17;

  @override
  ApiContact read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiContact(
      id: fields[0] as int,
      name: fields[1] as String,
      avatar: fields[3] as String?,
      lastActive: fields[8] as DateTime?,
      companyId: fields[4] as int?,
      status: fields[7] as String?,
      active: fields[21] as int?,
      isOnline: fields[22] as int?,
      looker: fields[23] as int?,
      statusEmotion: fields[24] as int?,
    )
      ..lastConversationMessage = fields[10] as String?
      ..lastConversationMessageTime = fields[11] as DateTime?
      ..countUnreadMessage = fields[12] as int?
      ..pinMessageId = fields[13] as String?
      ..groupLastSenderId = fields[14] as int?
      ..message = fields[15] as String?
      ..userStatus = fields[2] as UserStatus;
  }

  @override
  void write(BinaryWriter writer, ApiContact obj) {
    writer
      ..writeByte(24)
      ..writeByte(18)
      ..write(obj.id)
      ..writeByte(19)
      ..write(obj.groupName)
      ..writeByte(20)
      ..write(obj.status)
      ..writeByte(21)
      ..write(obj.active)
      ..writeByte(22)
      ..write(obj.isOnline)
      ..writeByte(23)
      ..write(obj.looker)
      ..writeByte(24)
      ..write(obj.statusEmotion)
      ..writeByte(9)
      ..write(obj.isGroup)
      ..writeByte(10)
      ..write(obj.lastConversationMessage)
      ..writeByte(11)
      ..write(obj.lastConversationMessageTime)
      ..writeByte(12)
      ..write(obj.countUnreadMessage)
      ..writeByte(13)
      ..write(obj.pinMessageId)
      ..writeByte(14)
      ..write(obj.groupLastSenderId)
      ..writeByte(15)
      ..write(obj.message)
      ..writeByte(16)
      ..write(obj.conversationId)
      ..writeByte(17)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.userStatus)
      ..writeByte(3)
      ..write(obj.avatar)
      ..writeByte(4)
      ..write(obj.companyId)
      ..writeByte(5)
      ..write(obj.email)
      ..writeByte(6)
      ..write(obj.id365)
      ..writeByte(8)
      ..write(obj.lastActive);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ContactAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
