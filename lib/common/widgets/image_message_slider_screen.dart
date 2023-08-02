import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/widgets/button/my_entry.dart';
import 'package:chat_365/common/widgets/widget_slider.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/router/app_router.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/permission_extension.dart';
import 'package:chat_365/utils/helpers/system_utils.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageMessageSliderScreen extends StatelessWidget {
  const ImageMessageSliderScreen({
    Key? key,
    required this.images,
    required this.initIndex,
  }) : super(key: key);

  final List<SocketSentMessageModel> images;
  final int initIndex;

  static const String initIndexArg = 'initIndexArg';
  static const String imagesArg = 'imagesArg';

  @override
  Widget build(BuildContext context) {
    final GlobalKey<WidgetSliderState> _sliderKey =
        GlobalKey<WidgetSliderState>();
    return Scaffold(
      backgroundColor: AppColors.mineShaft,
      appBar: AppBar(
        backgroundColor: AppColors.mineShaft,
        leading: BackButton(
          color: AppColors.white,
        ),
        elevation: 0,
        actions: [
          PopupMenuButton(
            child: Icon(
              Icons.more_horiz_rounded,
              color: AppColors.white,
            ),
            itemBuilder: (_) {
              return [
                MyEntry(
                  child: Text('Tải xuống'),
                  onTap: () async {
                    var imageFile = images[_sliderKey.currentState!.tabIndex];
                    var file = imageFile.files!.first;
                    var savePath = await SystemUtils.prepareSaveDir();
                    if (savePath == null)
                      return AppDialogs.toast(
                        'Tạo đường dẫn tải file thất bại',
                      );
                    SystemUtils.permissionCallback(
                      PermissionExt.downloadPermission,
                      () => SystemUtils.downloadFile(
                        file.downloadPath,
                        savePath,
                        fileName: file.fileName,
                      ),
                    );
                  },
                ),
                MyEntry(
                  child: Text('Chuyển tiếp'),
                  onTap: () {
                    var file = images[_sliderKey.currentState!.tabIndex];
                    AppRouterHelper.toForwardMessagePage(
                      context,
                      message: file,
                      senderInfo: context.userInfo(),
                    );
                  },
                )
              ];
            },
          ),
          const SizedBox(width: 15),
        ],
      ),
      body: WidgetSlider(
        key: _sliderKey,
        initIndex: initIndex,
        tabBarImages: images
            .map((e) => CachedNetworkImage(
                  imageUrl: e.files!.first.fullFilePath,
                  errorWidget: (_, __, ___) => Placeholder(),
                  height: 60,
                  width: 60,
                  memCacheHeight: 60,
                  memCacheWidth: 60,
                ))
            .toList(),
        images: images
            .map(
              (e) => PhotoView(
                imageProvider: CachedNetworkImageProvider(
                  e.files!.first.fullFilePath,
                ),
                errorBuilder: (_, __, ___) => Placeholder(),
                scaleStateChangedCallback: (value) {
                  if (value == PhotoViewScaleState.zoomedIn &&
                      _sliderKey.currentState!.isScrollable) {
                    _sliderKey.currentState!.changePhysics(
                      const NeverScrollableScrollPhysics(),
                    );
                  } else if (value == PhotoViewScaleState.zoomedOut)
                    AppRouter.back(context);
                  else if (!_sliderKey.currentState!.isScrollable) {
                    _sliderKey.currentState!.changePhysics(
                      const AlwaysScrollableScrollPhysics(),
                    );
                  }
                },
              ),
            )
            .toList(),
      ),
    );
  }
}
