// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_chat_conversation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ChatItemModelAdapter extends TypeAdapter<ChatItemModel> {
  @override
  final int typeId = 3;

  @override
  ChatItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ChatItemModel(
      conversationId: fields[0] as int,
      numberOfUnReadMessgae: fields[1] as int,
      isGroup: fields[2] as bool,
      senderId: fields[3] as int,
      message: fields[4] as String?,
      messageType: fields[5] as MessageType?,
      totalNumberOfMessages: fields[6] as int,
      messageDisplay: fields[7] as int,
      typeGroup: fields[8] as String,
      adminId: fields[9] as int,
      adminName: fields[10] as String?,
      browerMemberList: (fields[11] as List?)?.cast<ChatMemberModel>(),
      memberList: (fields[12] as List).cast<ChatMemberModel>(),
      isFavorite: fields[13] as bool,
      isHidden: fields[14] as bool,
      createAt: fields[15] as DateTime,
      conversationBasicInfo: fields[16] as ConversationBasicInfo,
      status: fields[17] as String?,
    )..autoDeleteMessageTimeModel = fields[18] as AutoDeleteMessageTimeModel;
  }

  @override
  void write(BinaryWriter writer, ChatItemModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.conversationId)
      ..writeByte(1)
      ..write(obj.numberOfUnreadMessage)
      ..writeByte(2)
      ..write(obj.isGroup)
      ..writeByte(3)
      ..write(obj.senderId)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.messageType)
      ..writeByte(6)
      ..write(obj.totalNumberOfMessages)
      ..writeByte(7)
      ..write(obj.messageDisplay)
      ..writeByte(8)
      ..write(obj.typeGroup)
      ..writeByte(9)
      ..write(obj.adminId)
      ..writeByte(10)
      ..write(obj.adminName)
      ..writeByte(11)
      ..write(obj.browerMemberList)
      ..writeByte(12)
      ..write(obj.memberList)
      ..writeByte(13)
      ..write(obj.isFavorite)
      ..writeByte(14)
      ..write(obj.isHidden)
      ..writeByte(15)
      ..write(obj.createAt)
      ..writeByte(16)
      ..write(obj.conversationBasicInfo)
      ..writeByte(17)
      ..write(obj.status)
      ..writeByte(18)
      ..write(obj.autoDeleteMessageTimeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChatItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
