// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'emoji.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmojiAdapter extends TypeAdapter<Emoji> {
  @override
  final int typeId = 12;

  @override
  Emoji read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Emoji(
      id: fields[0] as int,
      assetPath: fields[1] as String,
      linkEmotion: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Emoji obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.assetPath)
      ..writeByte(2)
      ..write(obj.linkEmotion);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmojiAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
