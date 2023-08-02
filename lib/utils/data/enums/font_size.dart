import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';

class FontSized {
  static final Map<String, String> _values = {
    '1': 'Nhỏ',
    '2': 'Bình thường',
    '3': 'Lớn',
    '4': 'Rất lớn',
  };

  static int idOf(String value) {
    try {
      return int.parse(_values.entries.firstWhere((e) => e.value == value).key);
    } catch (e) {
      throw DataNotFoundException(
          "FontSized.value == $value", 'FontSized.idOf');
    }
  }

  static String valueOf(String id) {
    if (id.isEmpty || id == '0') return 'Chưa cập nhật';

    try {
      String value = _values[id]!;
      return value;
    } catch (e) {
      throw DataNotFoundException(
          "FontSized.id == $id", 'AcademicLevel.valueOf');
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
