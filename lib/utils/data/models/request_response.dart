import 'dart:async';
import 'dart:convert';

import 'package:chat_365/core/constants/status_code.dart';
import 'package:chat_365/core/constants/string_constants.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:flutter/foundation.dart';

Logger _log = Logger();

class RequestResponse {
  final String data;
  int? code;
  bool? result;
  ErrorResponse? error;

  RequestResponse(this.data, this.result, this.code, {this.error}) {
    setError(data.toString());
  }

  void setError(String strResponse) {
    try {
      var res = json.decode(strResponse);
      error =
          res['error'] != null ? ErrorResponse.fromJson(res["error"]) : null;
    } catch (e, s) {
      _log.logError(e, s);
      ErrorResponse error = ErrorResponse(
        code: StatusCode.errorUnknownCode,
        message: StringConst.errorHappenedTryAgain,
      );
      this.error = error;
    }
  }

  bool get hasError => !(this.result == true && this.error == null);

  /// Handle response [this] khi trả về
  ///
  /// [callBack]: thường là chuyển đổi từ [response] => model
  ///
  /// Trả về [CustomException] nếu [this].hasError = true hoặc [callBack] có lỗi
  ///
  /// Nếu [predicate] = true => return [callBack]
  FutureOr<T> onCallBack<T>(
    FutureOr<T> Function(RequestResponse) callBack, {
    bool Function()? predicate,
    bool multiThread = false,
  }) async {
    if (predicate?.call() ?? !this.hasError) {
      try {
        return !multiThread
            ? await callBack(this)
            : await compute(_compute, [this, callBack]);
      } catch (e, s) {
        logger.logError(e, s);
        throw CustomException();
      }
    } else {
      logger.logError(error);
      throw CustomException(this.error);
    }
  }

  static FutureOr<T> _compute<T>(List param) =>
      (param[1] as FutureOr<T> Function(RequestResponse)).call(param[0]);
}
