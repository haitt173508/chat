import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/utils/ui/app_border_and_radius.dart';
import 'package:chat_365/utils/ui/app_padding.dart';
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_style.dart';

class AppFormField {
  static const InputDecorationTheme inputDecorationDarkTheme =
      InputDecorationTheme(
    fillColor: AppColors.primaryColorDarkTheme,
    border: AppBorderAndRadius.solidInputBorder,
    disabledBorder: AppBorderAndRadius.solidInputBorder,
    enabledBorder: AppBorderAndRadius.solidInputBorder,
    errorBorder: AppBorderAndRadius.solidInputBorder,
    focusedBorder: AppBorderAndRadius.solidInputBorder,
    focusedErrorBorder: AppBorderAndRadius.solidInputBorder,
    contentPadding: AppPadding.formFieldContentPadding,
    filled: true,
    constraints: BoxConstraints(),
    isDense: true,
    hintStyle: AppTextStyles.hintText,
  );
  static const InputDecorationTheme inputDecorationLightTheme =
      InputDecorationTheme(
    fillColor: AppColors.white,
    errorMaxLines: 2,
    helperMaxLines: 2,
    enabledBorder: AppBorderAndRadius.outlineInputBorder,
    disabledBorder: AppBorderAndRadius.outlineInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.outlineInputFocusedBorder,
    errorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    contentPadding: AppPadding.formFieldContentPadding,
    isDense: true,
    filled: true,
    constraints: BoxConstraints(),
    hintStyle: AppTextStyles.hintText,
  );

  static InputDecoration inputDecorationDark = InputDecoration(
    fillColor: AppColors.primaryColorDarkTheme,
    errorMaxLines: 2,
    helperMaxLines: 2,
    enabledBorder: AppBorderAndRadius.outlineInputBorder,
    disabledBorder: AppBorderAndRadius.outlineInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.outlineInputFocusedBorder,
    errorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    contentPadding: AppPadding.formFieldContentPadding,
    isDense: true,
    filled: true,
    constraints: BoxConstraints(),
    hintStyle: AppTextStyles.hintText.copyWith(color: AppColors.white),
    prefix: Padding(padding: EdgeInsets.only(left: 10)),
    prefixIconConstraints: BoxConstraints(),
    suffixIconConstraints: BoxConstraints(),
  );

  static const InputDecoration inputDecorationLight = InputDecoration(
    fillColor: AppColors.white,
    errorMaxLines: 2,
    helperMaxLines: 2,
    // helperText: '',
    // helperStyle: TextStyle(height: 0.6),
    // errorStyle: TextStyle(height: 0.6),
    enabledBorder: AppBorderAndRadius.outlineInputBorder,
    disabledBorder: AppBorderAndRadius.outlineInputDisabledBorder,
    focusedBorder: AppBorderAndRadius.outlineInputFocusedBorder,
    errorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    focusedErrorBorder: AppBorderAndRadius.outlineInputErrorBorder,
    contentPadding: AppPadding.formFieldContentPadding,
    isDense: true,
    filled: true,

    constraints: BoxConstraints(),
    prefix: Padding(padding: EdgeInsets.only(left: 10)),
    prefixIconConstraints: BoxConstraints(),
    suffixIconConstraints: BoxConstraints(),
  );
  static const InputDecoration inputDecoration = InputDecoration(
    contentPadding: AppPadding.formFieldContentPadding,
    isDense: true,
    filled: true,
    constraints: BoxConstraints(),
    prefix: Padding(padding: EdgeInsets.only(left: 10)),
    prefixIconConstraints: BoxConstraints(),
    suffixIconConstraints: BoxConstraints(),
  );

  static const chatInputFieldDecoration = InputDecoration(
    border: InputBorder.none,
    enabledBorder: InputBorder.none,
    focusedBorder: InputBorder.none,
    contentPadding: EdgeInsets.only(top: 16, bottom: 13, left: 20),
    hintText: StringConst.inputMessage,
    hintStyle: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 14,
      color: AppColors.doveGray,
    ),
    filled: true,
    fillColor: Colors.transparent,
  );
}
