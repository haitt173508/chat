import 'package:bloc/bloc.dart';
import 'package:chat_365/common/blocs/downloader/model/downloader_model.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'downloader_state.dart';

class DownloaderCubit extends Cubit<DownloaderState> {
  DownloaderCubit() : super(DownloaderState()) {
    try {
      downloadBox = _hiveService.downloadBox;
    } catch (e) {
      downloadBox = null;
    }
    _loadTask();
  }

  final HiveService _hiveService = HiveService();

  /// messageId - downloaderModel
  late final Map<String, DownloaderModel> tasks;

  late final Box<DownloaderModel>? downloadBox;

  _loadTask() {
    var task = downloadBox?.values ?? {};

    tasks = Map.fromIterable(
      task,
      key: (e) => (e as DownloaderModel).messageId,
    );
  }

  updateTask(DownloaderModel model) {
    tasks[model.messageId] = model;

    // if (model.status == DownloadStatus.none) {
    //   downloadBox.put(model.messageId, model);
    // }

    emit(DownloaderStateUpdateTask(model));
  }

  @override
  void onChange(Change<DownloaderState> change) {
    if (change.nextState is DownloaderStateUpdateTask) {
      var model =
          (change.nextState as DownloaderStateUpdateTask).downloaderModel;
      if (model.status == DownloadStatus.downloaded) {
        downloadBox?.put(model.messageId, model);
      }
    }
    super.onChange(change);
  }
}
