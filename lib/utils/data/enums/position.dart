import 'package:chat_365/common/models/selectable_Item.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';

class Position {
  static final Map<String, String> _values = {
    // '0': "Tất cả chức vụ",
    '1': "Sinh viên thực tập",
    '2': "Nhân viên thử việc",
    '9': "Nhân viên part time",
    '3': "Nhân viên chính thức",
    '20': "Nhóm phó",
    '4': "Trưởng nhóm",
    '12': "Phó tổ trưởng",
    '13': "Tổ trưởng",
    '10': "Phó ban dự án",
    '11': "Trưởng ban dự án",
    '5': "Phó trưởng phòng",
    '6': "Trưởng phòng",
    '7': "Phó giám đốc",
    '8': "Giám đốc",
    '14': "Phó Tổng Giám đốc",
    // '15': "Phó Tổng Giám đốc thường trực",
    '16': "Tổng Giám đốc",
    '17': "Thành viên Hội đồng quản trị",
    '21': "Tổng Giám Đốc Tập Đoàn",
    '18': "Phó Chủ tịch Hội đồng quản trị",
    '19': "Chủ tịch hội đồng quản trị",
    '22': "Phó Tổng Giám Đốc Tập Đoàn",
  };

  static int idOf(String value) {
    try {
      return int.parse(_values.entries.firstWhere((e) => e.value == value).key);
    } catch (e) {
      throw DataNotFoundException("Position.value == $value", 'Position.idOf');
    }
  }

  static String valueOf(String id) {
    if (id.isEmpty || id == '0') return 'Chưa cập nhật';

    try {
      String value = _values[id]!;
      return value;
    } catch (e) {
      throw DataNotFoundException("Position.id == $id", 'Position.valueOf');
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
