import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:flutter/material.dart';

import 'app_dimens.dart';

class AppTextStyles {
  static const TextStyle introDescription = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    color: AppColors.text,
  );
  static const TextStyle authTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );
  static const TextStyle appbarTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );
  static const TextStyle title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.normal,
  );

  static TextStyle button(BuildContext context) => regularW700(
        context,
        size: 16,
        fontStyle: FontStyle.normal,
      );

  static TextStyle iconButton(BuildContext context) => regularW400(
        context,
        size: 14,
        lineHeight: 20,
      );
  static const TextStyle iconWhiteBackgroundButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.tundora,
  );
  static const TextStyle iconPrimaryTextButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.primary,
  );
  static const TextStyle iconColorButton = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );

  static const TextStyle contactItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
  );
  static TextStyle contactGroupName(BuildContext context) => regularW700(
        context,
        size: 16,
        lineHeight: 20,
      );

  static const TextStyle optionsDialogItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.primary,
  );

  static const TextStyle dropdownItem = iconWhiteBackgroundButton;
  static const TextStyle selectedDropdownItem = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.text,
  );

  static const TextStyle hintText = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.normal,
  );

  static const TextStyle dialogDescription = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Colors.black,
  );

  static TextStyle mbsTitle(BuildContext context) => regularW500(
        context,
        size: 16,
        lineHeight: 19.1,
        color: context.theme.primaryColor,
      );

  static TextStyle mbsItem(BuildContext context) => regularW500(
        context,
        size: 14,
        color: context.theme.textColor,
      );

  static TextStyle titleListTileSetting(BuildContext context) => regularW700(
        context,
        size: 16,
        lineHeight: 19.1,
      );

  static TextStyle recommend(BuildContext context) => regularW500(
        context,
        size: 16,
        lineHeight: 19.1,
      );

  static const TextStyle boldTextProfile = TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w700,
      fontStyle: FontStyle.normal,
      color: AppColors.black);
  static TextStyle textMessageDisplayStyle(
    BuildContext context, {
    Color? color,
  }) =>
      TextStyle(
        color: color,
        fontSize: 16.0,
        height: 18.75 / 16.0,
      );

  static TextStyle nameCustomerProfileChat(BuildContext context) => regularW700(
        context,
        size: 18,
        lineHeight: 20,
        color: context.theme.primaryColor,
      );

  // Text style with font Normal
  static TextStyle regularW500(BuildContext context,
      {@required double? size,
      FontStyle? fontStyle,
      Color? color,
      double lineHeight = AppDimens.lineHeightXSmall}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = lineHeight / size;
    }
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w500,
          color: color,
          height: height,
        );
  }

  static TextStyle regularW700(
    BuildContext context, {
    @required double? size,
    FontStyle? fontStyle,
    Color? color,
    double lineHeight = AppDimens.lineHeightSmall,
  }) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = lineHeight / size;
    }
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: color,
          height: height,
        );
  }

  static TextStyle regularW400(BuildContext context,
      {@required double? size,
      FontStyle? fontStyle,
      Color? color,
      double lineHeight = AppDimens.lineHeightXSmall}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = lineHeight / size;
    }
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w400,
          color: color,
          height: height,
          fontStyle: fontStyle,
        );
  }

  static TextStyle regularW600(BuildContext context,
      {@required double? size,
      FontStyle? fontStyle,
      Color? color,
      double lineHeight = AppDimens.lineHeightXSmall}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = lineHeight / size;
    }
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w600,
          color: color,
          height: height,
          fontStyle: fontStyle,
        );
  }

  static TextStyle regular(BuildContext context,
      {@required double? size,
      FontWeight? fontWeight,
      Color? color,
      double lineHeight = AppDimens.lineHeightXSmall}) {
    var height = 1.0;
    if (lineHeight > size!) {
      height = lineHeight / size;
    }
    return Theme.of(context).textTheme.subtitle1!.copyWith(
          fontSize: size,
          fontWeight: FontWeight.w300,
          color: color,
          height: height,
        );
  }
}
