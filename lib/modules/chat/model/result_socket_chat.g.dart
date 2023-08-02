// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'result_socket_chat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SocketSentMessageModelAdapter
    extends TypeAdapter<SocketSentMessageModel> {
  @override
  final int typeId = 11;

  @override
  SocketSentMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SocketSentMessageModel(
      conversationId: fields[0] as int,
      messageId: fields[1] as String,
      senderId: fields[2] as int,
      emotion: (fields[5] as Map).cast<Emoji, Emotion>(),
      type: fields[3] as MessageType?,
      message: fields[4] as String?,
      relyMessage: fields[6] as ApiRelyMessageModel?,
      createAt: fields[7] as DateTime,
      files: (fields[8] as List?)?.cast<ApiFileModel>(),
      infoLink: fields[9] as InfoLink?,
      contact: fields[10] as IUserInfo?,
      linkNotification: fields[12] as String?,
      autoDeleteMessageTimeModel: fields[13] as AutoDeleteMessageTimeModel,
    ).._messageStatus = fields[11] as MessageStatus;
  }

  @override
  void write(BinaryWriter writer, SocketSentMessageModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.conversationId)
      ..writeByte(1)
      ..write(obj.messageId)
      ..writeByte(2)
      ..write(obj.senderId)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.emotion)
      ..writeByte(6)
      ..write(obj.relyMessage)
      ..writeByte(7)
      ..write(obj.createAt)
      ..writeByte(8)
      ..write(obj.files)
      ..writeByte(9)
      ..write(obj.infoLink)
      ..writeByte(10)
      ..write(obj.contact)
      ..writeByte(11)
      ..write(obj._messageStatus)
      ..writeByte(12)
      ..write(obj.linkNotification)
      ..writeByte(13)
      ..write(obj.autoDeleteMessageTimeModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SocketSentMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class InfoLinkAdapter extends TypeAdapter<InfoLink> {
  @override
  final int typeId = 16;

  @override
  InfoLink read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InfoLink(
      messageId: fields[0] as String?,
      description: fields[1] as String?,
      title: fields[2] as String?,
      linkHome: fields[3] as String?,
      image: fields[4] as String?,
      haveImage: fields[5] as bool,
      isNotification: fields[7] as bool,
      link: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, InfoLink obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.title)
      ..writeByte(3)
      ..write(obj.linkHome)
      ..writeByte(4)
      ..write(obj.image)
      ..writeByte(5)
      ..write(obj.haveImage)
      ..writeByte(6)
      ..write(obj.link)
      ..writeByte(7)
      ..write(obj.isNotification);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InfoLinkAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class EmotionAdapter extends TypeAdapter<Emotion> {
  @override
  final int typeId = 13;

  @override
  Emotion read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Emotion(
      type: fields[0] as Emoji,
      listUserId: (fields[1] as List).cast<int>(),
      isChecked: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Emotion obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.listUserId)
      ..writeByte(2)
      ..write(obj.isChecked);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmotionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
