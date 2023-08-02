import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/utils/data/enums/message_setting_type.dart';
import 'package:chat_365/utils/data/enums/message_text_size.dart';
import 'package:chat_365/utils/data/extensions/list_extension.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'message_setting_model_item.g.dart';

@HiveType(typeId: HiveTypeId.messageSettingItemModelTypeId)
class MessageSettingModelItem {
  @HiveField(0)
  dynamic _selectedValue;
  @HiveField(1)
  final MessageSettingType messageSettingType;
  final List<dynamic> values;

  MessageSettingModelItem({
    List? values,
    dynamic initSelectedValue,
    String Function(dynamic)? valueDisplay,
    required this.messageSettingType,
  })  : this.values = values.isBlank ? _boolValues : values!,
        this.valueDisplay = valueDisplay ?? _kDefaultValueDisplay {
    if (initSelectedValue != null)
      selectedValue = initSelectedValue;
    else
      _selectedValue = this.values[0];
  }

  factory MessageSettingModelItem.fromMessageSettingType(
    MessageSettingType type, {
    dynamic selectedValue,
  }) =>
      messageSettings[type]!..selectedValue = selectedValue;

  set selectedValue(dynamic newValue) {
    if (newValue.runtimeType == _selectedValue.runtimeType)
      _selectedValue = newValue;
  }

  get selectedValue => _selectedValue;

  // set setIsSelect(bool value) {
  //   isSelect = value;
  // }

  final String Function(dynamic) valueDisplay;

  static final MessageSettingModelItem seenMessage = MessageSettingModelItem(
    messageSettingType: MessageSettingType.seenMessage,
  );
  static final MessageSettingModelItem messageFontSize =
      MessageSettingModelItem(
    values: MessageTextSize.values,
    valueDisplay: (dynamic value) => (value as MessageTextSize).fontSizeName,
    messageSettingType: MessageSettingType.messageFontSize,
  );
  static final MessageSettingModelItem autoDownloadImage =
      MessageSettingModelItem(
    messageSettingType: MessageSettingType.autoDownloadImage,
  );
  static final MessageSettingModelItem autoDownloadFile =
      MessageSettingModelItem(
    messageSettingType: MessageSettingType.autoDownloadFile,
  );
  static final MessageSettingModelItem pasteCopiedMessageAsQuoteMessage =
      MessageSettingModelItem(
    messageSettingType: MessageSettingType.pasteCopiedMessageAsQuoteMessage,
  );
  static final MessageSettingModelItem previewWeb = MessageSettingModelItem(
    messageSettingType: MessageSettingType.previewWeb,
  );

  static final Map<MessageSettingType, MessageSettingModelItem>
      messageSettings = {
    MessageSettingType.seenMessage: seenMessage,
    MessageSettingType.messageFontSize: messageFontSize,
    MessageSettingType.autoDownloadImage: autoDownloadImage,
    MessageSettingType.autoDownloadFile: autoDownloadFile,
    MessageSettingType.pasteCopiedMessageAsQuoteMessage:
        pasteCopiedMessageAsQuoteMessage,
    MessageSettingType.previewWeb: previewWeb,
  };

  static String _kDefaultValueDisplay<T>(T value) => value.toString();

  static const List<bool> _boolValues = [true, false];
}
