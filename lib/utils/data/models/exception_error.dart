import 'package:chat_365/core/constants/status_code.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:equatable/equatable.dart';

class ExceptionError extends Equatable {
  final String error;
  final String? stackTrace;
  final int? code;

  ExceptionError(
    this.error, {
    this.stackTrace,
    this.code,
  });

  @override
  String toString() => error;

  @override
  List<Object?> get props => [error, code];

  factory ExceptionError.unknown() => ExceptionError(
        StringConst.errorHappenedTryAgain,
        code: StatusCode.errorUnknownCode,
      );

  factory ExceptionError.notAllowWriteFile() => ExceptionError(
        'Chat365 không thể ghi file',
        code: StatusCode.permissionError,
      );

  factory ExceptionError.downloadFileError() => ExceptionError(
        'Tải file thất bại',
        code: StatusCode.networkError,
      );

  factory ExceptionError.openFileError() => ExceptionError(
        'Không thể mở file',
        code: StatusCode.openFileError,
      );

  bool get isExceedListConversation =>
      error == 'User không có cuộc trò chuyện nào';

  bool get isExceedListChat => error == 'Cuộc trò chuyện không có tin nhắn nào';

  bool get isNetworkException => StatusCode.networkErrors.contains(code);

  bool get isServerError => StatusCode.serverError.contains(code);

  bool get isUnknowError => code == StatusCode.errorUnknownCode;

  // factory ExceptionError.cannotChatWithYourself() => ExceptionError(
  //       'Không thể chat với chính mình',
  //       code: StatusCode.,
  //     );
}
