import 'package:chat_365/common/images.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/modules/chat/model/api_message_model.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ReplyMessageBuilder extends StatelessWidget {
  const ReplyMessageBuilder({
    Key? key,
    this.originMessageTextColor,
    this.replyInfoTextColor,
    // required this.replyMessage,
    required this.replyModel,
    this.originMessageMaxLines,
  }) : super(key: key);

  final Color? originMessageTextColor;
  final Color? replyInfoTextColor;
  final ApiRelyMessageModel replyModel;
  final int? originMessageMaxLines;

  @override
  Widget build(BuildContext context) {
    final replyColor = originMessageTextColor ?? AppColors.white;
    final replyInfoColor = replyInfoTextColor ?? AppColors.white;
    final originMessageTimeTextSize = context.theme.messageTextSize - 2;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        QuoteMessageWidget(
          replyColor: replyColor,
          message: replyModel.message ?? StringConst.canNotDisplayMessage,
          originMessageMaxLines: originMessageMaxLines,
        ),
        const SizedBox(height: 5),
        Text(
          '${replyModel.senderName}, ${replyModel.createAt.diffWith(
            showSpecialTime: true,
            showTimeStamp: false,
          )} lúc ${replyModel.createAt.toHmString()}',
          maxLines: 2,
          style: AppTextStyles.regularW400(
            context,
            size: originMessageTimeTextSize,
            color: replyInfoColor,
            lineHeight: originMessageTimeTextSize * 1.2,
          ),
        ),
      ],
    );
  }
}

class QuoteMessageWidget extends StatelessWidget {
  const QuoteMessageWidget({
    Key? key,
    required this.replyColor,
    required this.originMessageMaxLines,
    required this.message,
  }) : super(key: key);

  final Color replyColor;
  final String message;
  final int? originMessageMaxLines;

  @override
  Widget build(BuildContext context) {
    var textSize = context.theme.messageTextSize - 1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgPicture.asset(
          Images.ic_quote,
          color: replyColor,
          height: 16,
          width: 18,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: SelectableText(
            message,
            maxLines: originMessageMaxLines,
            minLines: 1,
            style: AppTextStyles.regularW400(
              context,
              size: textSize,
              color: replyColor,
              lineHeight: textSize * 1.2,
            ),
            // overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
