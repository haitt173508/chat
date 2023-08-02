// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';

import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';

class ResponseInterceptor extends InterceptorsWrapper {
  final Logger _log = Logger();

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    try {
      if (response.data is Map) {
        response.data = json.encode(response.data);
      }
    } catch (e, s) {
      _log.logError(e, s);
    }
  }
}
