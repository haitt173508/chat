import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/generator_service.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/helpers/open_url.dart';
import 'package:chat_365/utils/ui/widget_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ApplyMessageDisplay extends StatelessWidget {
  ApplyMessageDisplay({
    Key? key,
    required this.isSentByCurrentUser,
    this.infoLink,
    required String? link,
    required this.content,
  })  : _link = getLink(infoLink, link),
        super(key: key);

  final InfoLink? infoLink;
  final String _link;
  final String content;

  static String getLink(InfoLink? infoLink, String? link) {
    if (link != null) {
      return GeneratorService.generate365Link(link);
    }
    return infoLink?.fullLink ?? "";
  }

  _onTapLink() async {
    if (_link.contains('www.google.com/maps')) _link.replaceAll('www', '');
    print('link đâu: ${_link}');
    return openUrl(_link);
  }

  final bool isSentByCurrentUser;

  @override
  Widget build(BuildContext context) {
    var themeData = context.theme;
    var backgroundColor =
        isSentByCurrentUser ? null : themeData.messageBoxColor;
    var textStyle = themeData.messageTextStyle.copyWith(
      color: isSentByCurrentUser ? AppColors.white : null,
    );
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: backgroundColor,
          gradient: isSentByCurrentUser ? themeData.gradient : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              content,
              style: textStyle,
            ),
            const SizedBox(height: 5),
            InkWell(
              onTap: _onTapLink,
              child: Container(
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: !isSentByCurrentUser
                        ? AppColors.blueGradients1
                        : AppColors.white,
                  ),
                  // color: context.theme.primaryColor,
                  gradient: themeData.gradient,
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 11),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "XEM NGAY",
                      style: AppTextStyles.regularW600(
                        context,
                        size: 13,
                        color: AppColors.white,
                      ),
                    ),
                    SizedBoxExt.w5,
                    SvgPicture.asset(Images.ic_play_message)
                  ],
                ),
              ),
            )
          ],
        ));
  }
}
