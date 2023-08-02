import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';

class MaritalStatus {
  static final Map<String, String> _values = {
    '1': 'Độc thân',
    '2': 'Đã kết hôn',
  };

  static int idOf(String value) {
    try {
      return int.parse(_values.entries.firstWhere((e) => e.value == value).key);
    } catch (e) {
      throw DataNotFoundException(
          "MaritalStatus.value == $value", 'MaritalStatus.idOf');
    }
  }

  static String valueOf(String id) {
    if (id.isEmpty || id == '0') return 'Chưa cập nhật';

    try {
      String value = _values[id]!;
      return value;
    } catch (e) {
      throw DataNotFoundException(
          "MaritalStatus.id == $id", 'MaritalStatus.valueOf');
    }
  }

  static List<SelectableItem> get selectableItemList => _values.entries
      .map(
        (e) => SelectableItem(
          id: e.key,
          name: e.value,
        ),
      )
      .toList();

  static List<String> get values =>
      _values.entries.map((e) => e.value).toList();
}
