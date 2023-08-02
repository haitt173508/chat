import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:flutter/material.dart';

class TextDisplay extends StatelessWidget {
  const TextDisplay({
    Key? key,
    required this.isSentByCurrentUser,
    required this.message,
    this.sentTime,
  }) : super(key: key);

  final bool isSentByCurrentUser;
  final String? message;
  final DateTime? sentTime;

  @override
  Widget build(BuildContext context) {
    var themeData = context.theme;
    var backgroundColor =
        isSentByCurrentUser ? null : themeData.messageBoxColor;
    var textStyle = themeData.messageTextStyle.copyWith(
      color: isSentByCurrentUser ? AppColors.white : null,
    );
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: isSentByCurrentUser ? themeData.gradient : null,
      ),
      child: Text.rich(
        TextSpan(
          text: message!,
          children: [
            if (sentTime != null)
              TextSpan(
                text: '\n${sentTime!.toHmString()}',
                style: themeData.sentTimeMessageTextStyle.copyWith(
                  color: isSentByCurrentUser
                      ? AppColors.white.withOpacity(0.7)
                      : null,
                ),
              ),
          ],
        ),
        style: textStyle,
      ),
      // child: Text(
      //   message!,
      //   style: context.theme.messageTextStyle.copyWith(
      //     color: isSentByCurrentUser ? AppColors.white : null,
      //   ),
      // ),
    );
  }
}
