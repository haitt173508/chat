import 'package:chat_365/common/icons/no_internet_icon_painter.dart';
import 'package:chat_365/common/icons/warning_icon_painter.dart';
import 'package:flutter/material.dart';

import '../../common/icons/email_icon_painter.dart';
import '../../common/icons/password_icon_painter.dart';
import '../../common/icons/visibility_icon_painter.dart';

class IconUtils {
  static const dataItemIconSize = Size(20, 20);
  static const defaultIconSize = Size(24, 24);
  static const navIconSize = Size(25, 25);
  static const homeBtnIconSize = Size(73, 73);
  static const sectionIconSize = Size(153, 153);
  static const dialogIconSize = Size(70, 70);
  static const chatOptionIconSize = Size(50, 50);
  static const inlineTextIconSize = Size(13, 13);

  static CustomPaint authFormIconEmail = CustomPaint(
    size: defaultIconSize,
    painter: EmailIconPainter(),
  );
  static CustomPaint authFormIconPassword = CustomPaint(
    size: defaultIconSize,
    painter: PasswordIconPainter(),
  );
  static CustomPaint authFormIconVisibility = CustomPaint(
    size: defaultIconSize,
    painter: VisibilityIconPainter(),
  );

  static const no_internet_icon = CustomPaint(
    size: sectionIconSize,
    painter: NoInternetIconPainter(),
  );

  static const warning_icon = CustomPaint(
    size: sectionIconSize,
    painter: WarningIconPainter(),
  );
}
