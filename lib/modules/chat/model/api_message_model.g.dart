// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_message_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ApiFileModelAdapter extends TypeAdapter<ApiFileModel> {
  @override
  final int typeId = 15;

  @override
  ApiFileModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiFileModel(
      fileName: fields[0] as String,
      resolvedFileName: fields[1] as String?,
      fileType: fields[2] as MessageType,
      fileSize: fields[3] as int,
      displayFileSize: fields[4] as String?,
      imageSource: fields[5] as String?,
      width: fields[6] as num,
      height: fields[7] as num,
      filePath: fields[9] as String?,
      uploaded: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ApiFileModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.fileName)
      ..writeByte(1)
      ..write(obj.resolvedFileName)
      ..writeByte(2)
      ..write(obj.fileType)
      ..writeByte(3)
      ..write(obj.fileSize)
      ..writeByte(4)
      ..write(obj.displayFileSize)
      ..writeByte(5)
      ..write(obj.imageSource)
      ..writeByte(6)
      ..write(obj.width)
      ..writeByte(7)
      ..write(obj.height)
      ..writeByte(8)
      ..write(obj.uploaded)
      ..writeByte(9)
      ..write(obj.filePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiFileModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ApiRelyMessageModelAdapter extends TypeAdapter<ApiRelyMessageModel> {
  @override
  final int typeId = 14;

  @override
  ApiRelyMessageModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ApiRelyMessageModel(
      messageId: fields[0] as String,
      senderId: fields[1] as int,
      senderName: fields[2] as String?,
      type: fields[3] as MessageType?,
      message: fields[4] as String?,
      createAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ApiRelyMessageModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.senderId)
      ..writeByte(2)
      ..write(obj.senderName)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.message)
      ..writeByte(5)
      ..write(obj.createAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApiRelyMessageModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
