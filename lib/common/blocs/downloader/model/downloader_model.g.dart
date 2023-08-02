// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'downloader_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloaderModelAdapter extends TypeAdapter<DownloaderModel> {
  @override
  final int typeId = 1;

  @override
  DownloaderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DownloaderModel(
      fields[0] as String,
      fileName: fields[4] as String,
      status:
          fields[1] == null ? DownloadStatus.none : fields[1] as DownloadStatus,
      saveDir: fields[2] as String?,
      taskId: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DownloaderModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.messageId)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.saveDir)
      ..writeByte(3)
      ..write(obj.taskId)
      ..writeByte(4)
      ..write(obj.fileName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloaderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
