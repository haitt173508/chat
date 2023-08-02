import 'package:flutter/material.dart';

class AppColors {
  static const Color white = Colors.white;

  static const Color indigo = Color(0xFF4C5BD4);

  static const Color black = Colors.black;

  static const Color black50 = Color(0x80000000);

  static const Color tundora = Color(0xFF474747);

  static const Color mineShaft = Color(0xFF333333);

  static const black99 = Color(0xFF999999);

  static const Color dustyGray = Color(0xFF999999);

  static const Color gray7777777 = Color(0xFF777777);

  static const Color gray = Color(0xFF808080);

  static const Color grayDCDCDC = Color(0xFFDCDCDC);

  static const Color grayE6E9FD = Color(0xFFE6E9FD);

  static const Color red = Color(0xFFFF3333);

  static const Color boulder = Color(0xFF757575);

  static const Color ghostWhite = Color(0xFFF1F1F4);

  static const Color lima = Color(0xFF76B51B);

  static const Color lawnGreen = Color(0xFF83DD00);

  static const Color greenF4FCE9 = Color(0xFFF4FCE9);

  static const Color orange = Color(0xFFFFA800);

  static const Color whiteLilac = Color(0xFFF7F8FC);

  static final Color dialogBarrier = Colors.black.withOpacity(0.50);

  static const Color doveGray = Color(0xFF666666);
  static const Color grayHint = Color(0xFF999999);
  static const Color lightGray = Color(0xFFE4E4E4);

  static const Color grayC4C4C4 = Color(0xFFC4C4C4);

  /// Colors.black.withOpacity(0.1);
  static const Color shadow10 = Color(0x1A000000);

  /// Colors.black.withOpacity(0.2);
  static const Color shadow20 = Color(0x33000000);

  /// Colors.black.withOpacity(0.25);
  static const Color shadow25 = Color(0x40000000);

  ///Không xóa màu đơn của gradient vì dùng cho màn cài đặt chung
  static const Color blueGradients1 = Color(0xff0086DA);
  static const Color blueGradients2 = Color(0xff00A9E9);
  static const Color blueD4E7F7 = Color(0xffD4E7F7);

  static const LinearGradient blueGradients = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [blueGradients1, blueGradients2]);

  static const Color peachGradients1 = Color(0xffFC9C80);
  static const Color peachGradients2 = Color(0xffFDB187);
  static const Color peachGradients3 = Color(0xffFDB187);

  static const LinearGradient peachGradients = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [peachGradients1, peachGradients2, peachGradients3]);

  //

  static const Color primary = Color(0xFF4C5BD4);
  static const Color blueEDF8FD = Color(0xFFEDF8FD);

  static const Color borderColor = doveGray;

  static const Color text = doveGray;

  // static const Color inactive = doveGray;
  static const Color inactive = lightGray;

  static const Color active = primary;

  static const Color error = red;

  static const Color primaryColorLightTheme = white;

  static const Color primaryColorDarkTheme = mineShaft;

  static const Color online = lima;

  static const Color offline = orange;

  static const Color colorIconLight = boulder;

  static const Color colorIconDark = Colors.white;

  static const Color dividerColorLightTheme = dustyGray;

  static const Color fillColor = whiteLilac;

  static const Color divider = doveGray;

  static const greyCC = Color(0xFFCCCCCC);
  static const greyCACA = Color(0xFFCACACA);

  static final Color shimmerBaseColor = Colors.grey.shade300;

  static final Color shimmerHighlightColor = Colors.grey.shade100;

  static final Color lightThemeTextColor = AppColors.tundora;

  static final Color darkThemeTextColor = AppColors.white;

  static final Color lightThemeDisableColor = AppColors.ghostWhite;
  static final Color darkThemeDisableColor = AppColors.tundora;

  static final Color lightThemeHintTextColor = AppColors.grayHint;
  static final Color darkThemeHintTextColor = AppColors.boulder;

  static final Color buttonCallScreenColor = AppColors.tundora;
  static final Color buttonDisableCallScreenColor =
      AppColors.tundora.withOpacity(0.4);
  static final Color iconDisableCallScreenColor =
      AppColors.white.withOpacity(0.4);
  static final Color iconCallScreenColor = AppColors.white;
  static final Color timeCallColor = AppColors.lawnGreen;
}
