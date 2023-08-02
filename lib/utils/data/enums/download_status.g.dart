// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'download_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DownloadStatusAdapter extends TypeAdapter<DownloadStatus> {
  @override
  final int typeId = 2;

  @override
  DownloadStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return DownloadStatus.none;
      case 1:
        return DownloadStatus.downloaded;
      case 2:
        return DownloadStatus.progress;
      case 3:
        return DownloadStatus.paused;
      default:
        return DownloadStatus.none;
    }
  }

  @override
  void write(BinaryWriter writer, DownloadStatus obj) {
    switch (obj) {
      case DownloadStatus.none:
        writer.writeByte(0);
        break;
      case DownloadStatus.downloaded:
        writer.writeByte(1);
        break;
      case DownloadStatus.progress:
        writer.writeByte(2);
        break;
      case DownloadStatus.paused:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DownloadStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
