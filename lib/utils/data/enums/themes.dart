import 'package:chat_365/core/constants/app_constants.dart';
import 'package:chat_365/core/theme/app_colors.dart';
import 'package:chat_365/core/theme/app_form_field.dart';
import 'package:chat_365/core/theme/app_text_style.dart';
import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/main.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'themes.g.dart';

@HiveType(typeId: HiveTypeId.appThemeColorHiveTypeId)
enum AppThemeColor {
  @HiveField(0)
  defaultTheme,
  @HiveField(1)
  peachTheme,
}

extension AppThemeExt on AppThemeColor {
  Gradient get gradient => this == AppThemeColor.defaultTheme
      ? AppColors.blueGradients
      : AppColors.peachGradients;

  Color get primaryColor => this == AppThemeColor.defaultTheme
      ? AppColors.primary
      : AppColors.peachGradients3;
}

@HiveType(typeId: HiveTypeId.myThemeHiveTypeId)
class MyTheme {
  final BuildContext context;
  @HiveField(0)
  AppThemeColor appTheme;
  @HiveField(1)
  ThemeMode themeMode;
  @HiveField(2)
  double messageTextSize;

  MyTheme(
    this.context, {
    this.appTheme = AppThemeColor.defaultTheme,
    this.themeMode = ThemeMode.light,
    double? messageTextSize,
  }) : this.messageTextSize =
            messageTextSize ?? AppConst.kDefaultMessageFontSize {
    themeData = Theme.of(context);
  }

  bool get isDarkTheme => themeMode == ThemeMode.dark;

  late ThemeData themeData;

  TextStyle get userListTileTextTheme => AppTextStyles.regularW500(
        context,
        size: 18,
        lineHeight: 20,
        color: textColor,
      );

  // TextStyle get textInput => AppTextStyles.regularW500(
  //       context,
  //       size: 16,
  //       lineHeight: 19.2,
  //       color: textColor,
  //     );
  TextStyle get inputStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        lineHeight: 18.75,
        color: textColor,
      );

  Color get textColor => isDarkTheme
      ? AppColors.darkThemeTextColor
      : AppColors.lightThemeTextColor;

  Color get hitnTextColor => isDarkTheme
      ? AppColors.darkThemeHintTextColor
      : AppColors.lightThemeHintTextColor;

  Color get iconColor => textColor;

  Color get backgroundColor => isDarkTheme
      ? AppColors.primaryColorDarkTheme
      : AppColors.primaryColorLightTheme;

  Color get backgroundFormFieldColor =>
      isDarkTheme ? AppColors.tundora : AppColors.primaryColorLightTheme;

  Color get disableColor => isDarkTheme
      ? AppColors.darkThemeDisableColor
      : AppColors.lightThemeDisableColor;

  TextStyle get messageTextStyle => AppTextStyles.regularW400(
        context,
        size: messageTextSize,
        color: textColor,
        lineHeight: messageTextSize * 1.2,
      );

  TextStyle get notificationMessageTextStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        color: textColor,
        lineHeight: 20,
      );

  TextStyle get replyOriginTextStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        lineHeight: 18.75,
        color: isDarkTheme ? AppColors.white : AppColors.text,
      );

  TextStyle get typingTextStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        lineHeight: 18,
        color: AppColors.dustyGray,
      );

  TextStyle get wrongUserTypeAuthDialogTextStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        lineHeight: 22,
      );

  Color get dividerDefaultColor =>
      isDarkTheme ? AppColors.white : AppColors.grayHint;

  Color get dividerHistoryColor =>
      isDarkTheme ? AppColors.white : AppColors.doveGray;

  Color get messageBoxColor =>
      isDarkTheme ? AppColors.tundora : AppColors.whiteLilac;

  Color get messageFileBoxColor =>
      isDarkTheme ? AppColors.tundora : AppColors.greyCC;

  Gradient get gradient => appTheme.gradient;

  ///Màu gradient của cuộc gọi không đổi theo theme
  Gradient get gradientPhoneCall => AppColors.blueGradients;

  IconThemeData get iconTheme => Theme.of(context).iconTheme.copyWith(
        color: textColor,
      );

  TextStyle get userStatusTextStyle => AppTextStyles.regularW400(
        context,
        size: 12,
        lineHeight: 15,
        color: isDarkTheme ? AppColors.white : AppColors.doveGray,
      );

  Color get unSelectedIconColor => textColor;

  Color get chatInputBarColor =>
      isDarkTheme ? AppColors.tundora : AppColors.grayE6E9FD;

  TextStyle get hintStyle => AppTextStyles.regularW400(
        context,
        size: 16,
        lineHeight: 18.75,
        color: hitnTextColor,
      );

  TextStyle get searchBigTextStyle => AppTextStyles.regularW700(
        context,
        size: 24,
        lineHeight: 26.4,
        color: AppColors.white,
      );

  TextStyle get locationListTileStyle => AppTextStyles.regularW500(
        context,
        size: 16,
        lineHeight: 21.6,
        color: textColor,
      );

  Color get primaryColor => appTheme.primaryColor;

  ButtonStyle get buttonStyle => ButtonStyle(
        elevation: MaterialStateProperty.all(0),
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
        fixedSize: MaterialStateProperty.all(Size.fromHeight(40)),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        overlayColor: MaterialStateProperty.all(primaryColor.withOpacity(0.15)),
      );

  ButtonStyle get outlinedButtonStyle => buttonStyle.copyWith(
        side: MaterialStateProperty.all(BorderSide(color: primaryColor)),
      );

  ButtonStyle get elevatedButtonStyle => buttonStyle.copyWith(
        backgroundColor: MaterialStateProperty.all(primaryColor),
      );

  Color get dropdownColor => isDarkTheme ? AppColors.black : AppColors.white;

  TextStyle get pinDropdownItemTextStyle => AppTextStyles.regularW400(
        context,
        size: 16,
      );

  TextStyle get sentTimeMessageTextStyle => AppTextStyles.regularW400(
        context,
        size: 13,
        color: textColor.withOpacity(0.7),
        lineHeight: 22,
      );

  TextStyle get chatConversationDropdownTextStyle => AppTextStyles.regularW400(
        context,
        size: 14,
        lineHeight: 16,
        color: isDarkTheme ? AppColors.white : AppColors.boulder,
      );

  TextStyle get diffOnlineTimeTextStyle => const TextStyle(
        fontSize: 8,
        height: 9.68 / 8,
        color: AppColors.lima,
        fontWeight: FontWeight.w500,
      );

  ThemeData get theme => ThemeData(
        primaryColor: primaryColor,
        chipTheme: Theme.of(context).chipTheme.copyWith(
              backgroundColor: backgroundColor,
              elevation: 0.0,
              disabledColor: backgroundColor,
            ),
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              buttonColor: primaryColor,
              highlightColor: primaryColor.withOpacity(0.85),
              splashColor: primaryColor.withOpacity(0.85),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              height: 40,
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    outline: primaryColor,
                    onPrimary: primaryColor,
                    primary: primaryColor,
                  ),
            ),
        tabBarTheme: Theme.of(context).tabBarTheme.copyWith(
              labelColor: primaryColor,
            ),
        colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              secondary: primaryColor,
            ),
        primaryColorLight: primaryColor,
        primaryColorDark: primaryColor,
        canvasColor: primaryColor,
        dialogBackgroundColor: backgroundColor,
        checkboxTheme: Theme.of(context).checkboxTheme.copyWith(
              checkColor: MaterialStateProperty.all<Color>(backgroundColor),
              fillColor: MaterialStateProperty.all<Color>(primaryColor),
            ),
        textSelectionTheme: Theme.of(context).textSelectionTheme.copyWith(
              cursorColor: primaryColor,
            ),
        textTheme: Theme.of(context)
            .textTheme
            .copyWith(
              subtitle1: hintStyle,
            )
            .apply(
              displayColor: textColor,
              bodyColor: textColor,
            ),
        scaffoldBackgroundColor: backgroundColor,
        elevatedButtonTheme:
            ElevatedButtonThemeData(style: elevatedButtonStyle),
        outlinedButtonTheme:
            OutlinedButtonThemeData(style: outlinedButtonStyle),
        bottomNavigationBarTheme:
            Theme.of(context).bottomNavigationBarTheme.copyWith(
                  backgroundColor: backgroundColor,
                  selectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: primaryColor,
                  ),
                  selectedItemColor: primaryColor,
                  unselectedItemColor: textColor,
                  unselectedLabelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: iconTheme.color,
                  ),
                  unselectedIconTheme: iconTheme,
                  selectedIconTheme: IconThemeData(
                    color: primaryColor,
                    size: 26,
                  ),
                  showSelectedLabels: true,
                  showUnselectedLabels: true,
                  type: BottomNavigationBarType.fixed,
                  elevation: 10,
                ),
        shadowColor: isDarkTheme
            ? AppColors.black.withOpacity(0.15)
            : AppColors.white.withOpacity(0.15),
        iconTheme: iconTheme,
        appBarTheme: AppBarTheme(
          backgroundColor: backgroundColor,
          centerTitle: false,
          titleTextStyle: AppTextStyles.regularW700(
            context,
            size: 18,
            lineHeight: 21.6,
            color: textColor,
          ),
          actionsIconTheme: iconTheme,
          iconTheme: iconTheme,
        ),
        primaryIconTheme: iconTheme,
        backgroundColor: backgroundColor,
        inputDecorationTheme: Theme.of(context).inputDecorationTheme.copyWith(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 13, bottom: 13, left: 20),
              hintStyle: hintStyle,
              filled: true,
              fillColor: Colors.transparent,
            ),
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
          ),
        ),
        cardTheme: Theme.of(context).cardTheme.copyWith(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        dialogTheme: Theme.of(context).dialogTheme.copyWith(
            backgroundColor: backgroundColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15))),
        timePickerTheme: Theme.of(context).timePickerTheme.copyWith(
              backgroundColor: backgroundColor,
              dialBackgroundColor: primaryColor,
            ),
        popupMenuTheme: Theme.of(context).popupMenuTheme.copyWith(
              color: isDarkTheme ? AppColors.black : AppColors.white,
              elevation: 10.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
        listTileTheme: Theme.of(context).listTileTheme.copyWith(
              iconColor: iconColor,
              minVerticalPadding: 0,
              textColor: textColor,
              dense: true,
              horizontalTitleGap: 0,
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
            ),
      );

  InputDecoration get inputDecoration => isDarkTheme
      ? AppFormField.inputDecorationDark
      : AppFormField.inputDecorationLight;
}
