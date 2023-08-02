import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/common/components/display/display_avatar.dart';
import 'package:chat_365/common/widgets/ellipsized_text.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LibraryDisplayMessageContent extends StatelessWidget {
  const LibraryDisplayMessageContent({
    Key? key,
    required this.fileMessage,
  }) : super(key: key);

  final SocketSentMessageModel fileMessage;

  @override
  Widget build(BuildContext context) {
    final MessageType messageType = fileMessage.type!;

    if (messageType.isImage) {
      return CachedNetworkImage(
        imageUrl: fileMessage.files!.first.fullFilePath,
        placeholder: (_, __) => ShimmerLoading(dimension: double.maxFinite),
        fit: BoxFit.cover,
        memCacheHeight: 200,
        memCacheWidth: 200,
      );
    }

    if (messageType.isFile) {
      final file = fileMessage.files!.first;
      bool isSvg = file.fileName.split('.').last == 'svg';
      bool isGif = file.fileName.split('.').last.toLowerCase() == 'gif';
      return Container(
        color: context.theme.messageFileBoxColor,
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
                file.fileName,
                maxLines: 3,
                style: AppTextStyles.regularW500(
                  context,
                  size: 16,
                  lineHeight: 21,
                ),
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
          ],
        ),
      );
    }

    if (messageType.isLink) {
      var infoLink = fileMessage.infoLink;
      return Column(
        children: [
          Expanded(
            child: Stack(
              alignment: Alignment.center,
              children: [
                CachedNetworkImage(
                  imageUrl: infoLink?.image ?? '',
                  errorWidget: (_, __, ___) => const SizedBox(),
                  fit: BoxFit.contain,
                ),
                Icon(
                  Icons.link,
                  color: AppColors.black,
                  size: 50,
                ),
              ],
            ),
          ),
          EllipsizedText(
            infoLink?.description ?? infoLink?.link ?? infoLink?.linkHome ?? '',
            maxLines: 2,
            style: context.theme.messageTextStyle,
          ),
        ],
      );
    }

    return const SizedBox();
  }
}
