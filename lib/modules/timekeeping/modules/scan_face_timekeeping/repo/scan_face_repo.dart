import 'dart:io';
import 'dart:typed_data';

import 'package:chat_365/core/constants/api_path.dart';
import 'package:chat_365/core/constants/local_storage_key.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/models/request_method.dart';
import 'package:chat_365/utils/data/models/request_response.dart';
import 'package:dio/dio.dart';
import 'package:sp_util/sp_util.dart';

class ScanFaceRepo {
  final ApiClient _apiClient = ApiClient();

  //api chấm công
  Future<RequestResponse> scanFaceTimekeeping(
    int? idCom,
    int? idUser,
    String? imageData,
  ) =>
      _apiClient.fetch(
        ApiPath.scan_face_timekeeping,
        data: {
          'comapny_id': idCom,
          'company_id': idCom,
          'user_id': idUser,
          'isAndroid': Platform.isAndroid ? 'false' : 'false',
          'image': imageData,
        },
        method: RequestMethod.post,
      );

//Danh sách lịch làm việc
  Future<RequestResponse> getListShift(
    int? idUser,
    int? idCom,
  ) =>
      _apiClient.fetch(
        ApiPath.list_shift + 'info_shift_user2.php?u_id=$idUser&c_id=$idCom',
        // token: SpUtil.getString(LocalStorageKey.token),
        searchParams: {
          'u_id': idUser,
          'c_id': idCom,
        },
        method: RequestMethod.get,
      );

  // CHấm công
  Future<RequestResponse> timeKeeping(
    String? device,
    double? tsLat,
    double? tsLong,
    String? tsLocationName,
    String? wifiName,
    String? wifiIp,
    String? wifiMac,
    String? shiftId,
    String? note,
    isWifiValid,
    isLocationValid,
    dynamic image,
  ) async {
    final MultipartFile? multipartFile;

    if (image is Uint8List)
      multipartFile = MultipartFile.fromBytes(
        image,
        filename: 'file_name_${DateTimeExt.currentTicks}.jpg',
      );
    else if (image is File)
      multipartFile = await MultipartFile.fromFile(
        image.path,
        filename: image.path.split('/').last,
      );
    else
      multipartFile = null;

    return _apiClient.fetch(
      ApiPath.timekeeping,
      token: SpUtil.getString(LocalStorageKey.token),
      data: {
        'device': device,
        'ts_lat': tsLat ?? 0.0,
        'ts_long': tsLong ?? 0.0,
        'ts_location_name': tsLocationName,
        'wifi_name': wifiName,
        'wifi_ip': wifiIp,
        'wifi_mac': wifiMac,
        'shift_id': shiftId,
        'note': note,
        'is_wifi_valid': isWifiValid,
        'is_location_valid': isLocationValid,
        'image': multipartFile,
      },
    );
  }
}
