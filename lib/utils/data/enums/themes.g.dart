// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'themes.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MyThemeAdapter extends TypeAdapter<MyTheme> {
  @override
  final int typeId = 20;

  @override
  MyTheme read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MyTheme(
      navigatorKey.currentContext!,
      appTheme: fields[0] as AppThemeColor,
      themeMode: fields[1] as ThemeMode,
      messageTextSize: fields[2] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, MyTheme obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.appTheme)
      ..writeByte(1)
      ..write(obj.themeMode)
      ..writeByte(2)
      ..write(obj.messageTextSize);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MyThemeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class AppThemeColorAdapter extends TypeAdapter<AppThemeColor> {
  @override
  final int typeId = 21;

  @override
  AppThemeColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return AppThemeColor.defaultTheme;
      case 1:
        return AppThemeColor.peachTheme;
      default:
        return AppThemeColor.defaultTheme;
    }
  }

  @override
  void write(BinaryWriter writer, AppThemeColor obj) {
    switch (obj) {
      case AppThemeColor.defaultTheme:
        writer.writeByte(0);
        break;
      case AppThemeColor.peachTheme:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppThemeColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
