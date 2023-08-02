import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:flutter/material.dart';

class LinkDisplay extends StatelessWidget {
  LinkDisplay({
    Key? key,
    required this.infoLink,
    required String? link,
  })  : _link = getLink(infoLink, link),
        super(key: key);

  final InfoLink infoLink;
  final String _link;

  static String getLink(InfoLink infoLink, String? link) {
    if (link != null) {
      if (infoLink.isNotification) return GeneratorService.generate365Link(link);
      return link;
    }
    return infoLink.fullLink;
  }

  _onTapLink() async {
    if (_link.contains('www.google.com/maps')) _link.replaceAll('www', '');
    return openUrl(_link);
  }

  @override
  Widget build(BuildContext context) {
    final MyTheme _theme = context.theme;
    final textSize = _theme.messageTextSize;
    return InkWell(
      onTap: _onTapLink,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (infoLink.haveImage)
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 120,
                minHeight: 0,
              ),
              child: CachedNetworkImage(
                imageUrl: infoLink.image?.replaceAll('amp;', '') ?? '',
                errorWidget: (_, __, ___) => const SizedBox(),
                fit: BoxFit.cover,
                width: double.infinity,
                // height: double.infinity,
              ),
            ),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12),
            color: AppColors.greyCC,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  infoLink.title ?? '',
                  style: AppTextStyles.regularW600(
                    context,
                    size: textSize,
                    color: AppColors.black,
                  ),
                ),
                Text(
                  infoLink.description ?? '',
                  style: AppTextStyles.regularW400(
                    context,
                    size: textSize - 2,
                    color: AppColors.boulder,
                  ),
                ),
                Text(
                  infoLink.linkHome ?? '',
                  style: AppTextStyles.regularW400(
                    context,
                    size: textSize - 2,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
