import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';

class WorkExperience {
  static final Map<String, String> _values = {
    '1': 'Chưa có kinh nghiệm',
    '2': 'Dưới 1 năm',
    '3': '1 năm',
    '4': '2 năm',
    '5': '3 năm',
    '6': '4 năm',
    '7': '5 năm',
    '8': 'Trên 5 năm',
  };

  static int idOf(String value) {
    try {
      return int.parse(_values.entries.firstWhere((e) => e.value == value).key);
    } catch (e) {
      throw DataNotFoundException(
          "WorkExperience.value == $value", 'WorkExperience.idOf');
    }
  }

  static String valueOf(String id) {
    if (id.isEmpty || id == '0') return 'Chưa cập nhật';

    try {
      String value = _values[id]!;
      return value;
    } catch (e) {
      throw DataNotFoundException(
          "WorkExperience.id == $id", 'WorkExperience.valueOf');
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
