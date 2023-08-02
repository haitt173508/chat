// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_setting_model_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageSettingModelItemAdapter
    extends TypeAdapter<MessageSettingModelItem> {
  @override
  final int typeId = 24;

  @override
  MessageSettingModelItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MessageSettingModelItem.fromMessageSettingType(
      fields[1] as MessageSettingType,
      selectedValue: fields[0] as dynamic,
    );
  }

  @override
  void write(BinaryWriter writer, MessageSettingModelItem obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj._selectedValue)
      ..writeByte(1)
      ..write(obj.messageSettingType);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageSettingModelItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
