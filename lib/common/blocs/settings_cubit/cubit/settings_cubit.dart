import 'package:chat_365/common/blocs/settings_cubit/cubit/settings_state.dart';
import 'package:chat_365/common/models/message_setting_model_item.dart';
import 'package:chat_365/data/services/hive_service/hive_service.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SettingsCubit extends Cubit<SettingState> {
  static const String settingKey = 'settingKey';

  SettingsCubit() : super(SettingState()) {
    try {
      settingsStateBox = HiveService().settingStateBox;
      var setting = settingsStateBox!.get(settingKey);
      if (setting != null) emit(setting);
    } catch (e, s) {
      logger.logError(e, s);
    }
  }

  Box<SettingState>? settingsStateBox;

  updateMessageSetting(MessageSettingModelItem item) =>
      emit(state.updateMessageSetting(item));

  @override
  void onChange(Change<SettingState> change) {
    settingsStateBox?.put(settingKey, change.nextState);
    super.onChange(change);
  }
}
