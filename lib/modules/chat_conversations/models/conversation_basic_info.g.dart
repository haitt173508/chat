// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conversation_basic_info.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConversationBasicInfoAdapter extends TypeAdapter<ConversationBasicInfo> {
  @override
  final int typeId = 8;

  @override
  ConversationBasicInfo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConversationBasicInfo(
      conversationId: fields[19] as int,
      isGroup: fields[12] as bool,
      userId: fields[20] as int,
      pinMessageId: fields[16] as String?,
      groupLastSenderId: fields[17] as int?,
      lastConversationMessageTime: fields[14] as DateTime?,
      lastConversationMessage: fields[13] as String?,
      countUnreadMessage: fields[15] as int?,
      totalGroupMemebers: fields[21] as int?,
      lastMessasgeId: fields[22] as String?,
      name: fields[1] as String,
      avatar: fields[3] as String?,
      userStatus: fields[2] as UserStatus,
      lastActive: fields[8] as DateTime?,
      companyId: fields[4] as int?,
      email: fields[5] as String?,
      friendStatus: fields[10] as FriendStatus?,
    )
      ..message = fields[18] as String?
      ..id = fields[0] as int
      ..status = fields[7] as String?
      ..password = fields[9] as String?
      ..userType = (fields[11] as int?) != null ? UserType.fromId(fields[11]) : null;
  }

  @override
  void write(BinaryWriter writer, ConversationBasicInfo obj) {
    writer
      ..writeByte(23)
      ..writeByte(12)
      ..write(obj.isGroup)
      ..writeByte(13)
      ..write(obj.lastConversationMessage)
      ..writeByte(14)
      ..write(obj.lastConversationMessageTime)
      ..writeByte(15)
      ..write(obj.countUnreadMessage)
      ..writeByte(16)
      ..write(obj.pinMessageId)
      ..writeByte(17)
      ..write(obj.groupLastSenderId)
      ..writeByte(18)
      ..write(obj.message)
      ..writeByte(19)
      ..write(obj.conversationId)
      ..writeByte(20)
      ..write(obj.userId)
      ..writeByte(21)
      ..write(obj.totalGroupMemebers)
      ..writeByte(22)
      ..write(obj.lastMessasgeId)
      ..writeByte(0)
      ..write(obj.id)
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
      ..writeByte(7)
      ..write(obj.status)
      ..writeByte(8)
      ..write(obj.lastActive)
      ..writeByte(9)
      ..write(obj.password)
      ..writeByte(10)
      ..write(obj.friendStatus)
      ..writeByte(11)
      ..write(obj.userType?.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConversationBasicInfoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
