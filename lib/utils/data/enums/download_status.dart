import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:hive/hive.dart';
part 'download_status.g.dart';

@HiveType(typeId: HiveTypeId.downloadStatusHiveTypeId)
enum DownloadStatus {
  @HiveField(0)
  none,
  @HiveField(1)
  downloaded,
  @HiveField(2)
  progress,
  @HiveField(3)
  paused,
}

extension DownloadStatusExt on DownloadStatus {
  int get id {
    switch (this) {
      case DownloadStatus.none:
        return 0;
      case DownloadStatus.downloaded:
        return 1;
      case DownloadStatus.progress:
        return 2;
      case DownloadStatus.paused:
        return 3;
      default:
        return 0;
    }
  }

  static DownloadStatus fromId(int id) => DownloadStatus.values[id];
}
