// import 'dart:_http';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/main.dart';
import 'package:chat_365/modules/get_token/repos/get_token_repo.dart';
import 'package:chat_365/utils/data/clients/interceptors/debug_log_interceptor.dart';
import 'package:chat_365/utils/data/clients/interceptors/response_interceptor.dart';
import 'package:chat_365/utils/data/extensions/num_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/api_path.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/status_code.dart';
import '../models/request_method.dart';
import '../models/request_response.dart';

const _exceptionCanResolveByReFecth = [
  'HttpException: Connection closed before full header was received',
  'HandshakeException: Connection terminated during handshake',
  'Connecting timed out',
  'Receiving data timeout',
  'OS Error: Network is unreachable',
  'SocketException: Connection',
  'HttpException: Connection reset by peer',
  'HttpException: Connection closed while receiving data',
];

final _baseOptions = BaseOptions(
  connectTimeout: 5000, //5000
  receiveTimeout: 5000, //3000
  sendTimeout: 5000, //3000
  baseUrl: ApiPath.baseUrl,
  responseType: ResponseType.json,
);

class ApiClient {
  late final Dio _dio;

  final Logger _log = Logger();

  static ApiClient? _instance;

  factory ApiClient() => _instance ??= ApiClient._();

  ApiClient._()
      : _dio = Dio(_baseOptions)
          ..interceptors.addAll([
            ResponseInterceptor(),
            // if (kReleaseMode) LogInterceptor(),
            DebugLogInterceptor(),
            // TokenInterceptor(),
          ]);

  Future<RequestResponse> fetch(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? searchParams,
    Map<String, dynamic>? headers,
    Options? options,
    String? token,
    RequestMethod method = RequestMethod.post,
    BaseOptions? baseOptions,
    int retryTime = AppConst.refecthApiThreshold,
    bool? isFormData,
  }) async {
    headers ??= HashMap();

    bool isExpriedToken = false;
    String? _token = token;

    if (options == null)
      options = method.options;
    else
      options.method = method.name;

    if (token != null) headers.putIfAbsent('Authorization', () => "$_token");

    options.headers = headers;
    options.contentType ??= headers.containsKey('Authorization')
        ? ContentType('application', 'x-www-form-urlencoded', charset: "utf-8")
            .mimeType
        : ContentType.json.mimeType;

    Response response;
    int retryTimes = 1;

    if (baseOptions != null) _dio.options = baseOptions;

    final bool useFormData =
        isFormData ?? (method == RequestMethod.post && data != null);

    while (true) {
      try {
        response = await _dio.request(
          url,
          data: useFormData ? FormData.fromMap(data ?? {}) : data,
          queryParameters: searchParams,
          options: options,
        );
        break;
      } on DioError catch (e) {
        if (_exceptionCanResolveByReFecth.any((el) => e.message.contains(el)) &&
            retryTimes <= retryTime) {
          retryTimes++;
          continue;
        }
        final errorRes = _dioErrorHandle(e);
        if (errorRes.code == StatusCode.errorCode401 && !isExpriedToken) {
          isExpriedToken = true;
          try {
            _token = await navigatorKey.currentContext!
                .read<GetTokenRepo>()
                .getToken();
            headers.update('Authorization', (_) => _token);
            retryTimes--;
            continue;
          } catch (e, s) {
            if (e is CustomException)
              logger.logError(e, s, 'RefreshTokenError: ');
          }
        }

        return errorRes;
      } catch (e) {
        return _unknowErrorHandle(e);
      }
    }

    try {
      json.decode(response.data);
    } catch (e, s) {
      _log.log(
        '=================DATA EXCEPTION===================',
        color: StrColor.red,
      );
      _log.logError(e, s);
      _log.logError(response.data);
      _log.log(
        '====================================',
        color: StrColor.red,
      );
      var error = ErrorResponse(message: 'Lỗi, vui lòng thử lại sau');
      return RequestResponse(
        '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
        false,
        0,
        error: error,
      );
    }

    return RequestResponse(
      response.data,
      true,
      response.statusCode ?? StatusCode.ok,
    );
  }

  /*
  Future<Response> fetchWithRequestOptions(RequestOptions options) =>
      _dio.request(
        options.path,
        data: options.data,
        options: Options(
          method: options.method,
          headers: options.headers,
        ),
      );
  */

  Future<RequestResponse> upload(
    url,
    List<MultipartFile> data, {
    Map<String, dynamic> mapData = const {},
    Map<String, dynamic>? headers,
    Options? options,
    ValueNotifier<double>? progressListener,
  }) async {
    Response? response;

    logger.log('SendFileDioLogger');

    final d = FormData()..files.addAll(data.map((e) => MapEntry('', e)));

    var fileTimeout = Duration(minutes: 15).inMilliseconds;

    var uploadOptions =
        (options == null ? RequestMethod.post.options : options).copyWith(
      sendTimeout: fileTimeout,
    );

    var uploadDio = _dio
      ..options = BaseOptions(
        sendTimeout: fileTimeout,
      );

    var listener = progressListener ?? ValueNotifier(0);

    try {
      response = await uploadDio.request(
        url,
        data: d,
        options: uploadOptions,
        onSendProgress: (count, total) {
          listener.value = (count / total).toPrecision(2);
        },
      );
    } on DioError catch (e) {
      // throw _requestFailure(e, retryTimes);
      return _dioErrorHandle(e);
    }

    // try {
    //   json.decode(response.data);
    // } catch (e, s) {
    //   logger.logError(e, s);
    //   return _unknowErrorHandle(e);
    //   // var error = ErrorResponse(message: 'Lỗi, vui lòng thử lại sau');
    //   // return RequestResponse(
    //   //   '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
    //   //   false,
    //   //   0,
    //   //   error: error,
    //   // );
    // }

    return RequestResponse(
      response.data,
      true,
      response.statusCode!,
    );
  }

  Future<dynamic> download(
    String url, {
    String? savePath,
    ProgressCallback? onReceiveProgress,
  }) async {
    Response response;
    int retryTimes = 1;

    while (true) {
      try {
        response = await _dio.download(
          url,
          savePath,
          onReceiveProgress: onReceiveProgress,
        );
        break;
      } on DioError catch (e) {
        if (_exceptionCanResolveByReFecth.any((el) => e.message.contains(el)) &&
            retryTimes <= AppConst.refecthApiThreshold) {
          retryTimes++;
          continue;
        }

        // throw await _requestFailure(e, retryTimes);
      }
    }

    return response.data;
  }

  Future<List<int>> downloadImage(String url) async {
    var bytes = <int>[];
    try {
      var res = await Dio(
        _baseOptions.copyWith(
          responseType: ResponseType.bytes,
          connectTimeout: 5 * 60 * 1000,
          receiveTimeout: 5 * 60 * 1000,
          sendTimeout: 5 * 60 * 1000,
        ),
      ).get(url);
      if (res.statusCode == 200) {
        bytes.addAll(res.data as List<int>);
      }
    } catch (e) {
      _log.logError('Download ảnh thất bại');
    }
    return bytes;
  }

  // Future<dynamic> _requestFailure(DioError e, int retryTimes) async {
  //   if (e.message.contains('Failed host lookup')) {
  //     if ((await ConnectivityService.canConnectToNetwork()) == false)
  //       return NoConnectionException();
  //     else
  //       return InternalServerException();
  //   }

  //   if (retryTimes == AppConst.refecthApiThreshold)
  //     return PoorConnectionException();

  //   return e;
  // }
}

_dioErrorHandle(DioError e) {
  Response? errorResponse = e.response;

  var errorCode = errorResponse?.statusCode ?? StatusCode.errorUnknownCode;
  var errorMsg = 'Đã có lỗi xảy ra khi tải dữ liệu, vui lòng thử lại';

  if (_exceptionCanResolveByReFecth.any((el) => e.message.contains(el))) {
    errorCode = StatusCode.networkError;
    errorMsg = 'Vui lòng kiểm tra kết nối internet và thử lại';
  } else if (StatusCode.serverError.contains(errorCode)) {
    errorMsg = 'Hệ thống đã xảy ra lỗi, vui lòng thử lại sau ! \n[$errorCode]';
  } else if (errorCode == StatusCode.errorCode401) {
    errorMsg = 'Phiên đăng nhập hết hạn !';
  }

  var error = ErrorResponse(
    code: errorCode,
    message: errorMsg,
  );

  return RequestResponse(
    '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
    false,
    error.code,
    error: error,
  );
}

_unknowErrorHandle(e) {
  // _log.appLog('=================DATA EXCEPTION===================',
  //     color: StrColor.red);
  // _log.appLog(response.data);
  // _log.appLog(e.toString(), color: StrColor.red);
  var error = ErrorResponse(message: 'Lỗi, vui lòng thử lại sau');
  return RequestResponse(
    '{"result":false,"code":${error.code},"error": ${json.encode(error.toJson())}}',
    false,
    0,
    error: error,
  );
}
