import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:dio/dio.dart';

class HomeQRCodeRepo {
  final ApiClient _apiClient = ApiClient();

  ///QR app => Login pc
  Future<RequestResponse> appLoginPC(
    String? idQR,
    String? email,
    String? password,
  ) {
    return _apiClient.fetch(
      ApiPath.app_login_pc,
      data: {
        'QrId': idQR,
        'Email': email,
        'Password': password,
      },
      options: Options(
        receiveTimeout: 5000,
      ),
    );
  }
  ///QR Add Group
  Future<RequestResponse> addGroup(
    int? idUser,
    String? data,
  ) {
    return _apiClient.fetch(
      ApiPath.add_group,
      data: {
        'id': idUser,
        'data': data,
      },
      options: Options(
        receiveTimeout: 5000,
      ),
    );
  }
}
