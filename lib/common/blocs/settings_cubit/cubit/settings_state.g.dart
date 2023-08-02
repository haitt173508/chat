// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_state.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingStateAdapter extends TypeAdapter<SettingState> {
  @override
  final int typeId = 22;

  @override
  SettingState read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SettingState(
      settingsModel: fields[0] as MessageSettingModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SettingState obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.settingsModel);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingStateAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
