import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/text_message_display.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/blocs/chat_detail_bloc/chat_detail_bloc.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/router/app_router_helper.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({
    Key? key,
    required this.file,
    required this.messageModel,
    this.remain = 0,
    this.fit,
    this.placeholder,
    this.cachedSize,
  }) : super(key: key);

  final ApiFileModel file;
  final BoxFit? fit;
  final File? placeholder;
  final SocketSentMessageModel messageModel;
  final int remain;
  final int? cachedSize;

  clipRRect(BuildContext context) => ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ShimmerLoading(),
      );

  @override
  Widget build(BuildContext context) {
    var fileImagePlaceholder;
    if (placeholder != null)
      fileImagePlaceholder = Image.file(
        placeholder!,
        fit: fit,
        width: double.infinity,
      );
    var cachedNetworkImage = CachedNetworkImage(
      imageUrl: file.fullFilePath,
      // memCacheWidth: cachedSize,
      memCacheHeight: cachedSize,
      fit: fit,
      progressIndicatorBuilder: (context, _, __) =>
          fileImagePlaceholder ?? ShimmerLoading(dimension: double.infinity),
      errorWidget: (context, uri, error) {
        logger.log(
          Uri.parse(uri),
          name: 'ErrorMessageImage',
          color: StrColor.red,
        );
        return fileImagePlaceholder ?? clipRRect(context);
      },
    );
    return InkWell(
      onTap: () {
        var imageFiles = context.read<ChatDetailBloc>().listImageFiles;
        var initIndex = imageFiles.indexWhere(
          (e) =>
              e.messageId == messageModel.messageId &&
              e.files!.first.originFileName ==
                  messageModel.files!.first.originFileName,
        );
        AppRouterHelper.toImageSlidePage(
          context,
          imageMessages: imageFiles,
          initIndex: initIndex,
        );
      },
      child: remain == 0
          ? cachedNetworkImage
          : Stack(
              children: [
                cachedNetworkImage,
                Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: AppColors.black.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    '$remain +',
                    style: AppTextStyles.regularW500(
                      context,
                      size: 30,
                      color: AppColors.white,
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
