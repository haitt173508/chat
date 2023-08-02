import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppBorderAndRadius {
  static const uniformBorder = Border.fromBorderSide(BorderSide(
    color: AppColors.borderColor,
    width: 1,
  ));

  static const uniformBorderSide =
      BorderSide(width: 1, color: AppColors.borderColor);

  static const tabBarBorder = Border.fromBorderSide(
    BorderSide(
      color: AppColors.borderColor,
      width: 0.5,
    ),
  );
  static const buttonBorder = Border.fromBorderSide(
    BorderSide(
      color: AppColors.primary,
      width: 1,
    ),
  );

  static const Radius defaultRadius = Radius.circular(15);

  static const Radius formRadius = Radius.circular(15);

  static const Radius multilineFormRadius = Radius.circular(20);

  static const BorderRadius defaultBorderRadius =
      BorderRadius.all(defaultRadius);

  static const BorderRadius formBorderRadius = BorderRadius.all(formRadius);

  static const BorderRadius chatInputFieldBorderRadius =
      BorderRadius.all(Radius.circular(50));

  static const BorderRadius chatMessageTopBorderRadius =
      BorderRadius.vertical(top: defaultRadius);

  static BorderRadius getChatMessageBottomBorderRadius(bool isSender) {
    return isSender
        ? const BorderRadius.only(bottomLeft: defaultRadius)
        : const BorderRadius.only(bottomRight: defaultRadius);
  }

  /*
  static BorderRadius resolveWithChatMessageBottomBorderRadius(bool isSender) =>
      chatMessageTopBorderRadius.copyWith(
        bottomLeft: isSender ? defaultRadius : null,
        bottomRight: isSender ? null : defaultRadius,
      );
  */

  static final RoundedRectangleBorder roundedRectangleBorder =
      RoundedRectangleBorder(borderRadius: defaultBorderRadius);

  static RoundedRectangleBorder checkBoxShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(4));

  static const OutlineInputBorder solidInputBorder = OutlineInputBorder(
    borderRadius: formBorderRadius,
    borderSide: BorderSide.none,
  );
  static const OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.borderColor),
    borderRadius: formBorderRadius,
  );

  static const OutlineInputBorder outlineInputDisabledBorder =
      OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.inactive),
    borderRadius: formBorderRadius,
  );

  static const OutlineInputBorder outlineInputFocusedBorder =
      OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.active),
    borderRadius: formBorderRadius,
  );

  static const OutlineInputBorder outlineInputErrorBorder = OutlineInputBorder(
    borderSide: BorderSide(color: AppColors.error),
    borderRadius: formBorderRadius,
  );

  static const double kChatBorderRadius = 15.0;

  static const Radius defaultMessageRadius = Radius.circular(2.5);

  static defaultChatBorder(
    bool isSentByCurrentUser, {
    bool cutTop = false,
    bool cutBot = false,
  }) {
    var topLeft = isSentByCurrentUser || cutTop
        ? Radius.circular(kChatBorderRadius)
        : defaultMessageRadius;
    var botLeft = isSentByCurrentUser || cutBot
        ? Radius.circular(kChatBorderRadius)
        : defaultMessageRadius;
    var topRight = !isSentByCurrentUser || cutTop
        ? Radius.circular(kChatBorderRadius)
        : defaultMessageRadius;
    var bottomRight = cutBot || !isSentByCurrentUser
        ? Radius.circular(kChatBorderRadius)
        : defaultMessageRadius;
    return BorderRadius.only(
      topLeft: topLeft,
      bottomLeft: botLeft,
      topRight: topRight,
      bottomRight: bottomRight,
    );
  }
}
