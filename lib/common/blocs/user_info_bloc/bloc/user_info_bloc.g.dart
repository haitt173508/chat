// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info_bloc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserInfoBlocAdapter extends TypeAdapter<UserInfoBloc> {
  @override
  final int typeId = 10;

  @override
  UserInfoBloc read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserInfoBloc(
      fields[0] as IUserInfo,
      conversationoId: fields[1] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserInfoBloc obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.userInfo)
      ..writeByte(1)
      ..write(obj.conversationoId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserInfoBlocAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
