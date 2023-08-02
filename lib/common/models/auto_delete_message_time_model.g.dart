// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auto_delete_message_time_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AutoDeleteMessageTimeModelAdapter
    extends TypeAdapter<AutoDeleteMessageTimeModel> {
  @override
  final int typeId = 27;

  @override
  AutoDeleteMessageTimeModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AutoDeleteMessageTimeModel(
      deleteType: fields[0] as int,
      deleteTime: fields[1] as int,
      deleteDate: fields[2] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, AutoDeleteMessageTimeModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.deleteType)
      ..writeByte(1)
      ..write(obj.deleteTime)
      ..writeByte(2)
      ..write(obj.deleteDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AutoDeleteMessageTimeModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
