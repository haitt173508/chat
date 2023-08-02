import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/blocs/downloader/cubit/downloader_cubit.dart';
import 'package:chat_365/common/blocs/downloader/model/downloader_model.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/ellipsized_text.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/utils/data/enums/download_status.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:open_file/open_file.dart';

class FileDisplay extends StatelessWidget {
  const FileDisplay({
    Key? key,
    required this.file,
    required this.messageId,
  }) : super(key: key);
  final ApiFileModel file;
  final String messageId;

  _onOpenFile(BuildContext context) async {
    // openUrl(file.fullFilePath);
    // AppRouterHelper.toPreviewFile(context, link: file.fullFilePath);
    var openRes = await SystemUtils.launchUrlInAppWebView(file.fullFilePath);
    if (openRes != null) AppDialogs.toast(openRes);
  }

  _downloadFunction(
    BuildContext context,
    ValueNotifier<String?> taskIdNotifier,
  ) =>
      () async {
        try {
          var savePath = await SystemUtils.prepareSaveDir();
          if (savePath == null) {
            return AppDialogs.toast('Tạo đường dẫn download thất bại');
          }
          var taskId = await SystemUtils.downloadFile(
            file.downloadPath,
            savePath,
            fileName: file.fileName,
            messageId: messageId,
          );

          if (taskId != null) {
            taskIdNotifier.value = taskId;
          } else
            AppDialogs.toast('Tạo task download thất bại\nVui lòng thử lại');
        } catch (e, s) {
          logger.logError(e, s);
          AppDialogs.toast(
            'Lỗi khi tải file\n$e',
            toast: Toast.LENGTH_SHORT,
          );
        }
      };

  _openFile(
    BuildContext context, {
    required DownloaderModel model,
  }) async {
    if (!(await FlutterDownloader.open(taskId: model.taskId!))) {
      var openRes = await OpenFile.open(model.saveDir);

      logger.log(openRes.message);

      var message = openRes.message;
      switch (openRes.type) {
        case ResultType.error:
          AppDialogs.toast(message);
          break;
        case ResultType.fileNotFound:
          AppDialogs.toast(message);
          HiveService().downloadBox?.delete(model.messageId);
          context.read<DownloaderCubit>().updateTask(
                model.copyWith(
                  status: DownloadStatus.none,
                ),
              );
          break;
        case ResultType.noAppToOpen:
          AppDialogs.toast(message);
          break;
        case ResultType.permissionDenied:
          AppDialogs.toast(message);
          break;
        default:
      }
    }
  }

  _builder(
    BuildContext context,
    DownloaderModel? model,
    ValueNotifier<String?> taskIdNotifier,
  ) {
    var status = model?.status;
    Function()? function = _downloadFunction(context, taskIdNotifier);
    Widget? textWidget;
    String text = 'Download';

    if (model != null) {
      if (status == DownloadStatus.progress) {
        text = model.progress.value.toString();
        textWidget = ValueListenableBuilder(
          valueListenable: model.progress,
          builder: (_, value, __) => Text(
            value.toString() + ' %',
          ),
        );
        function = null;
      } else if (status == DownloadStatus.paused) {
        text = 'Paused';
        function = null;
      } else if (status == DownloadStatus.downloaded) {
        text = 'Open';
        function = () {
          logger.log(
            model.saveDir,
            name: 'SavedDir',
          );
          SystemUtils.permissionCallback(
            PermissionExt.openFilePermission,
            () => _openFile(
              context,
              model: model,
            ),
          );
        };
      }
    }

    return [function, text, textWidget];
  }

  @override
  Widget build(BuildContext context) {
    bool isSvg = file.fileName.split('.').last == 'svg';
    bool isGif = file.fileName.split('.').last.toLowerCase() == 'gif';

    var downloaderCubit = context.read<DownloaderCubit>();

    final ValueNotifier<String?> taskIdNotifier =
        ValueNotifier(downloaderCubit.tasks[messageId]?.taskId);
    Widget? textWidget = null;
    String text = 'Download';
    Function()? function;

    var model = downloaderCubit.tasks[messageId];
    if (model?.fileName != file.fileName) model = null;
    // if (model != null) {
    var res = _builder(context, model, taskIdNotifier);
    function = res[0];
    text = res[1];
    textWidget = res[2];
    // }

    return InkWell(
      onTap: () => _onOpenFile(context),
      child: Container(
        height: 150,
        width: context.mediaQuerySize.width / 1.5,
        color: context.theme.messageFileBoxColor,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: EllipsizedText(
                file.fileName,
                // maxLines: 3,
                style: AppTextStyles.regularW500(
                  context,
                  size: 16,
                  lineHeight: 21,
                ),
                ellipsis: Ellipsis.middle,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Text(file.displayFileSize),
            ),
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (isSvg)
                    SvgPicture.network(
                      file.fullFilePath,
                      fit: BoxFit.contain,
                    ),
                  if (isGif)
                    CachedNetworkImage(
                      imageUrl: file.fullFilePath,
                      progressIndicatorBuilder: (context, _, __) =>
                          ShimmerLoading(dimension: double.infinity),
                      fit: BoxFit.contain,
                    ),
                ],
              ),
            ),
            Divider(),
            const SizedBox(height: 4),
            BlocBuilder<DownloaderCubit, DownloaderState>(
              bloc: downloaderCubit,
              buildWhen: (_, state) {
                var needBuild = state is DownloaderStateUpdateTask &&
                    (state.downloaderModel.messageId == messageId &&
                        (taskIdNotifier.value != null &&
                            state.downloaderModel.taskId ==
                                taskIdNotifier.value &&
                            state.downloaderModel.fileName == file.fileName));
                // logger.log('NeedBuild $messageId: $needBuild');
                return needBuild;
              },
              builder: (context, state) {
                if (state is DownloaderStateUpdateTask &&
                    (state.downloaderModel.messageId == messageId ||
                        (taskIdNotifier.value != null &&
                            state.downloaderModel.taskId ==
                                taskIdNotifier.value &&
                            state.downloaderModel.fileName == file.fileName))) {
                  var res = _builder(
                    context,
                    state.downloaderModel,
                    taskIdNotifier,
                  );
                  function = res[0];
                  text = res[1];
                  textWidget = res[2];
                }
                // logger.log(file);
                return InkWell(
                  onTap: function != null
                      ? () => SystemUtils.permissionCallback(
                            PermissionExt.downloadPermission,
                            function!,
                          )
                      : null,
                  child: SizedBox(
                    width: double.infinity,
                    child: Center(child: textWidget ?? Text(text)),
                  ),
                );
              },
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}
