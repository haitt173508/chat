import 'dart:ui' as ui;

import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:flutter/material.dart';

class AppDecoration {
  static const defaultGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    stops: const [0, 1],
    colors: const [
      AppColors.primary,
      Color(0xFF978ECF),
    ],
  );

  static final shimmerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.shimmerBaseColor,
      AppColors.shimmerBaseColor,
      AppColors.shimmerHighlightColor,
      AppColors.shimmerBaseColor,
      AppColors.shimmerBaseColor,
    ],
    stops: const [0.0, 0.35, 0.5, 0.65, 1.0],
  );

  static ui.Gradient getIconGradientShader(Size size) => ui.Gradient.linear(
        Offset(size.width * 7.443397e-7, size.height * 0.4972973),
        Offset(size.width, size.height * 0.4972973),
        const [Color(0xff4C5BD4), Color(0xff978ECF)],
        const [0, 1],
      );

  static const defaultShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      blurRadius: 4,
      color: AppColors.shadow20,
    )
  ];

  static const formShadow = [
    BoxShadow(
      offset: const Offset(0, 3),
      blurRadius: 4,
      color: AppColors.shadow25,
    )
  ];

  static const buttonShadow = formShadow;

  static final BoxDecoration cardBoxDecoration = const BoxDecoration(
    color: Colors.white,
    border: AppBorderAndRadius.uniformBorder,
    boxShadow: defaultShadow,
  );

  static const BoxDecoration tabBarDecoration = const BoxDecoration(
    border: AppBorderAndRadius.tabBarBorder,
    borderRadius: AppBorderAndRadius.defaultBorderRadius,
  );

  static const BoxDecoration chatMessageItemDecoration = const BoxDecoration(
    color: AppColors.whiteLilac,
    borderRadius: AppBorderAndRadius.chatMessageTopBorderRadius,
  );

  static BoxDecoration emojiDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: AppColors.white,
    boxShadow: [
      const BoxShadow(
        offset: Offset(0, 2),
        blurRadius: 4,
        color: AppColors.shadow10,
      ),
    ],
  );
}
