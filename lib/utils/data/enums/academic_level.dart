import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';

class AcademicLevel {
  static final Map<String, String> _values = {
    '0': 'Chọn trình độ học vấn',
    '1': 'Trên Đại học',
    '2': 'Đại học',
    '3': 'Cao đẳng',
    '4': 'Trung cấp',
    '5': 'Đào tạo nghề',
    '6': 'Trung học phổ thông',
    '7': 'Trung học cơ sở',
    '8': 'Tiểu học',
  };

  static int idOf(String value) {
    try {
      return int.parse(_values.entries.firstWhere((e) => e.value == value).key);
    } catch (e) {
      throw DataNotFoundException(
          "AcademicLevel.value == $value", 'AcademicLevel.idOf');
    }
  }

  static String valueOf(String id) {
    if (id.isEmpty || id == '0') return 'Chưa cập nhật';

    try {
      String value = _values[id]!;
      return value;
    } catch (e) {
      throw DataNotFoundException(
          "AcademicLevel.id == $id", 'AcademicLevel.valueOf');
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
