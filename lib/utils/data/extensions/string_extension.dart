import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';

extension NullableStringExt on String? {
  String addColor(StrColor color) {
    String str;
    switch (color) {
      case StrColor.black: //   \x1B[30m
        str = '\x1B[30m';
        break;
      case StrColor.red: //     \x1B[31m
        str = '\x1B[31m';
        break;
      case StrColor.green: //   \x1B[32m
        str = '\x1B[32m';
        break;
      case StrColor.yellow: //  \x1B[33m
        str = '\x1B[33m';
        break;
      case StrColor.blue: //    \x1B[34m
        str = '\x1B[34m';
        break;
      case StrColor.magenta: // \x1B[35m
        str = '\x1B[35m';
        break;
      case StrColor.cyan: //    \x1B[36m
        str = '\x1B[36m';
        break;
      case StrColor.white: //   \x1B[37m
        str = '\x1B[37m';
        break;
      case StrColor.reset: //   \x1B[0m
        str = '\x1B[0m';
        break;
      case StrColor.darkRed:
        str = '\x1B[38;5;166m';
        break;
      default:
        str = '';
    }
    return '$str$this\x1B[m';
  }

  bool get isBlank => this == null || this!.isEmpty;
}

extension StringExt on String {
  String toTitleCase() {
    if (isNotEmpty) {
      return this[0].toUpperCase() + substring(1);
    } else {
      return this;
    }
  }

  bool get isNotImageUrl {
    final int invertLastIndex = length - lastIndexOf('.');

    // ext của ảnh thường có length == 3
    // thêm dấu . thì == 4
    return invertLastIndex == -1 || invertLastIndex > 5;
  }

  bool get isImageUrl => !isNotImageUrl;

  String toEngAlphabetString() {
    var str = this;
    str = str.toLowerCase();
    str = str.replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), "a");
    str = str.replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), "e");
    str = str.replaceAll(RegExp(r'[ìíịỉĩ]'), "i");
    str = str.replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), "o");
    str = str.replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), "u");
    str = str.replaceAll(RegExp(r'[ỳýỵỷỹ]'), "y");
    str = str.replaceAll(RegExp(r'[đ]'), "d");
    // Some system encode vietnamese combining accent as individual utf-8 characters
    // str = str.replace(/\u0300\u0301|\u0303|\u0309|\u0323, ""); // Huyền sắc hỏi ngã nặng
    // str = str.replace(/\u02C6|\u0306|\u031B, ""); // Â, Ê, Ă, Ơ, Ư
    return str;
  }

  /// Lấy ra danh sách các số từ chuỗi
  List<int> getListIntFromThis() =>
      (split(RegExp(r'\s[^\d]+\s?')).map((e) => int.tryParse(e)).toList()
            ..removeWhere((e) => e == null))
          .cast();

  static final pinRegex = RegExp(r'^(\d+) pinned a message\:?.*');

  static final unPinRegex = RegExp(r'^(\d+) unpinned a message\:?.*');

  static final disableAutoDeleteMessageRegex =
      RegExp(r'^(\d+) set delete time is off');

  static final setAutoDeleteMessageRegex =
      RegExp(r'^(\d+) set delete time is (\d+) (\w+)');

  /// Parse từ message từ api thành thông báo hiển thị
  static String getDisplayMessageFromApiMessage(
    String apiMessage,
    List<String> users,
  ) {
    var _message = 'Không thể hiển thị thông báo';

    try {
      /// set auto delete message
      if (setAutoDeleteMessageRegex.hasMatch(apiMessage)) {
        final int count = int.parse(
            setAutoDeleteMessageRegex.allMatches(apiMessage).first.group(2)!);

        _message = '${users[0]} đã đặt thời gian tự xóa là $count ngày';
      }

      /// disable auto delete message
      else if (disableAutoDeleteMessageRegex.hasMatch(apiMessage)) {
        _message = '${users[0]} đã tắt tin nhắn tự xóa';
      }

      /// add friend
      else if (apiMessage.contains('add friend'))
        _message = '${users[0]} gửi lời mời kết bạn đến ${users[1]}';

      /// add
      else if (apiMessage.contains('add')) {
        var user2;
        users.length == 1 ? user2 = users.single : user2 = users[1];
        _message = '${users[0]} đã thêm $user2 vào cuộc trò chuyện';
      }

      /// delete
      else if (apiMessage.contains('remove') || apiMessage.contains('delete')) {
        _message = '${users[0]} đã xóa ${users[1]} khỏi cuộc trò chuyện';

        /// join
      } else if (apiMessage.contains('join')) {
        _message = '${users[0]} đã tham gia vào cuộc trò chuyện';
      }

      /// unpinned
      else if (unPinRegex.hasMatch(apiMessage)) {
        _message = '${users[0]} đã gỡ một tin nhắn đã ghim';
      }

      /// edit pinned message
      else if (apiMessage.contains('edited a pin')) {
        var index = apiMessage.indexOf(':');
        _message =
            '${users[0]} đã sửa tin nhắn đã ghim thành ${apiMessage.substring(index)}';
      }

      /// pinned message
      else if (pinRegex.hasMatch(apiMessage)) {
        var index = apiMessage.indexOf(':');
        _message =
            '${users[0]} đã ghim một tin nhắn ${apiMessage.substring(index)}';
      }

      /// left conversation
      else if (apiMessage.contains('leaved')) {
        _message = '${users[0]} đã rời khỏi cuộc trò chuyện';
      }

      ///
      else {
        throw CustomException(
          ExceptionError('Không thể nhận diện thông báo: $apiMessage'),
        );
      }
    } catch (e, s) {
      logger.logError('OriginApiNotification', apiMessage);
      logger.logError(e, s);
    }
    return _message;
  }

  int get tickFromMessageId => int.parse(split('_')[0]);

  String get originFileNameFromServerUri =>
      split('/').last.replaceAll(RegExp(r'^(\d+)-'), '');
}

enum StrColor {
  black, //   \x1B[30m
  red, //     \x1B[31m
  green, //   \x1B[32m
  yellow, //  \x1B[33m
  blue, //    \x1B[34m
  magenta, // \x1B[35m
  cyan, //    \x1B[36m
  white, //   \x1B[37m
  reset, //   \x1B[0m
  darkRed,
}
