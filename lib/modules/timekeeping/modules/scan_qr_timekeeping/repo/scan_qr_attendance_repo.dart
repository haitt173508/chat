import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:sp_util/sp_util.dart';

import '../../../../../core/constants/api_path.dart';
import '../../../../../core/constants/local_storage_key.dart';
import '../../../../../utils/data/clients/api_client.dart';
import '../../../../../utils/data/models/request_method.dart';
import '../../../../../utils/data/models/request_response.dart';

class ScanQrAttendanceRepo {
  final ApiClient _apiClient = ApiClient();

  //api chấm công
  // Future<RequestResponse> scanQRTimekeeping(
  //   int? idCom,
  //   int? idUser,
  //   String? imageData,
  // ) =>
  //     _apiClient.fetch(
  //       ApiPath.scan_face_timekeeping,
  //       data: {
  //         'comapny_id': idCom,
  //         'user_id': idUser,
  //         // 'isAndroid': Platform.isAndroid ? 'true' : 'false',
  //         'image': imageData,
  //       },
  //       method: RequestMethod.post,
  //     );
  // get qr code
  Future<RequestResponse> getDeCodeQrData(
    String? qrBarCode,
  ) =>
      _apiClient.fetch(
        ApiPath.decode_qr_attendance,
        data: {
          'data_qr': qrBarCode,
        },
        token: spService.token,
        method: RequestMethod.post,
      );

  // cham cong
  Future<RequestResponse> timeKeepingQR(
    String? uuid_device,
    double? tsLat,
    double? tsLong,
    String? tsLocationName,
    String? shiftId,
    String? isLocationValid,
    String? device,
    String? phoneName,
    String? from,
  ) async {
    return _apiClient.fetch(
      ApiPath.timekeepingQR,
      token: SpUtil.getString(LocalStorageKey.token),
      data: {
        'device': device,
        'ts_lat': tsLat,
        'ts_long': tsLong,
        'ts_location_name': tsLocationName,
        'shift_id': shiftId,
        'is_location_valid': isLocationValid,
        'uuid_device': uuid_device,
        'name_device': phoneName,
        'from': from,
      },
    );
  }
}
