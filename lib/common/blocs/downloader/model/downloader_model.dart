import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_flutter/adapters.dart';
part 'downloader_model.g.dart';

@HiveType(typeId: HiveTypeId.downloaderModelHiveTypeId)
class DownloaderModel {
  @HiveField(0)
  final String messageId;
  @HiveField(1, defaultValue: DownloadStatus.none)
  final DownloadStatus status;
  @HiveField(2)
  final String? saveDir;
  @HiveField(3)
  final String? taskId;
  @HiveField(4)
  final String fileName;
  final ValueNotifier<int?> progress;

  DownloaderModel(
    this.messageId, {
    required this.fileName,
    this.status = DownloadStatus.none,
    this.saveDir,
    this.taskId,
    int? progress,
  }) : progress = ValueNotifier(progress);

  copyWith({DownloadStatus? status}) => DownloaderModel(
        messageId,
        fileName: this.fileName,
        status: status ?? this.status,
        progress: this.progress.value,
        saveDir: this.saveDir,
        taskId: this.taskId,
      );

  // toJson() => {
  //       'messageId': messageId,
  //       'status': status.value.id,
  //       'saveDir': saveDir.value,
  //       'progress': progress.value,
  //       'taskId': taskId.value,
  //       'fileName': fileName.value,
  //     };

  // factory DownloaderModel.fromJson(Map<String, dynamic> json) =>
  //     DownloaderModel(
  //       json['messageId'],
  //       status: DownloadStatusExt.fromId(json['status']),
  //       saveDir: json['saveDir'],
  //       progress: json['progress'],
  //       taskId: json['taskId'],
  //     );

  @override
  String toString() => 'DownloaderModel(${taskId.toString()})';

  @override
  int get hashCode => messageId.hashCode;
}
