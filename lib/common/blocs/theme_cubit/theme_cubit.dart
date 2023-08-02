import 'package:bloc/bloc.dart';
import 'package:chat_365/utils/data/enums/themes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'theme_state.dart';

class ThemeCubit extends Cubit<ThemeState> {
  static const String themeKey = 'themeKey';

  ThemeCubit(
    this.context,
  ) : super(ThemeState(MyTheme(context)));

  final BuildContext context;

  Box<MyTheme>? themeBox;

  setThemeBox(Box<MyTheme> box) => themeBox = box;

  changeThemeMode(ThemeMode themeMode) => emit(
        ThemeState(state.theme..themeMode = themeMode),
      );

  changeThemeColor(AppThemeColor appThemeColor) =>
      emit(ThemeState(state.theme..appTheme = appThemeColor));

  /// Thay đổi cỡ chữ nhắn tin
  changeThemeMessageTextSize(double fontSize) =>
      emit(ThemeState(state.theme..messageTextSize = fontSize));

  @override
  void onChange(Change<ThemeState> change) {
    themeBox?.put(themeKey, change.nextState.theme);
    super.onChange(change);
  }
}
