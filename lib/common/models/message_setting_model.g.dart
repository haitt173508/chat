// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_setting_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSettingModelAdapter extends TypeAdapter<MessageSettingModel> {
  @override
  final int typeId = 23;

  @override
  MessageSettingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageSettingModel(
      initSettings: fields[0] != null
          ? Map<MessageSettingType, MessageSettingModelItem>.from(fields[0])
          : null,
    );
  }

  @override
  void write(BinaryWriter writer, MessageSettingModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.settings);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSettingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
