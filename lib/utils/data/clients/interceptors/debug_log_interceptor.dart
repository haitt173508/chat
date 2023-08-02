// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class DebugLogInterceptor extends InterceptorsWrapper {
  static List<Map> sHttpResponses = [];
  static List<String> sResponsesHttpUrl = [];

  static List<Map<String, dynamic>> sHttpRequest = [];
  static List<String> sRequestHttpUrl = [];

  static List<Map<String, dynamic>> sHttpError = [];

  static List<String> sHttpErrorUrl = [];

  Logger _log = Logger();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

    var data = options.data;
    var body = data;

    if (kDebugMode) {
      if (data is FormData) {
        body = <String, dynamic>{};
        // _log.appLog(data.fields);
        for (var e in data.fields) {
          (body as Map<String, dynamic>).putIfAbsent(e.key, () => e.value);
        }
      }

      var logString =
          "URL: ${options.path} \nMethod: ${options.method} \nheader: ${options.headers} \nparams: ${options.queryParameters}\nbody/query: $body";
      _log.log(logString, color: StrColor.yellow);
    }

    try {
      var map = {
        "header": {...options.headers},
      };

      if (options.method == "POST") map["data"] = options.data;
    } catch (e) {
      // _log.log(e);
    }
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);

    _log.log('Error URL: ' + err.requestOptions.path, color: StrColor.red);
    _log.log('Error: ' + err.toString(), color: StrColor.darkRed);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    var data;
    _log.log('Response: ${response.requestOptions.path}',
        color: StrColor.magenta);
    // if (kDebugMode) {
    //   var string = response.toString();
    //   try {
    //     // string = json.encode(json.decode(string));
    //     //   _log.log(string, color: StrColor.green);
    //     // }
    //   } catch (_) {}
    // }

    try {
      if (response.data is Map ||
          response.data is List ||
          response.data is String) {
        data = <String, dynamic>{};
        data["data"] = response.data;
      } else if (response.data != null) {
        data = response.data.toRecruiterJson(); // type String
      }
    } catch (e) {
      // _log.log(e);
    }
  }
}
