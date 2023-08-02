import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class TimekeepingRepo {
  final int comId;

  TimekeepingRepo(this.comId);

  final ApiClient _apiClient = ApiClient();

  Future<RequestResponse> getInfoCom() => _apiClient.fetch(
        ApiPath.timekeeping_configuration,
        token: SpUtil.getString(LocalStorageKey.token),
        method: RequestMethod.get,
        baseOptions: BaseOptions(
          receiveTimeout: 10000,
          sendTimeout: 10000,
        ),
      );
}
