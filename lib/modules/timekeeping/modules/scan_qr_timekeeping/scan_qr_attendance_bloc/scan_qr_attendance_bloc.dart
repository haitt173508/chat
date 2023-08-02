import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';
import 'package:sp_util/sp_util.dart';

import '../../../../../utils/helpers/logger.dart';
import '../../scan_face_timekeeping/repo/scan_face_repo.dart';
import '../models/decode_qr_model.dart';
import '../models/time_keeping_qr_model.dart';
import '../repo/scan_qr_attendance_repo.dart';
import 'package:flutter/src/foundation/change_notifier.dart';
part 'scan_qr_attendance_event.dart';
part 'scan_qr_attendance_state.dart';

class ScanQrAttendanceBloc extends Cubit<ScanQrAttendanceState> {
  ScanQrAttendanceRepo scanQrAttendanceRepo = ScanQrAttendanceRepo();
  ScanFaceRepo scanFaceRepo = ScanFaceRepo();

  ScanQrAttendanceBloc() : super(ScanQrAttendanceInitial());

  TimeKeepingQrModel? timekeepingModel;
  bool check = false;

  DecodeQR(
    String? qrCode,
  ) async {
    emit(ScanQrAttendanceLoadingState());
    var res = await scanQrAttendanceRepo.getDeCodeQrData(qrCode);
    var model = await decodeQrAttendanceFromJson(res.data);
    try {
      if (res.error == null) {
        var apiDeviceInfo = model.data!.info.device;
        // lan dau quet device tra ve null
        log(SpUtil.getString("uuid_device")!);

        if (apiDeviceInfo == null ||
            apiDeviceInfo.currentDevice == SpUtil.getString("uuid_device")) {
          idShift = model.data!.info.allShift[0].shiftId;
          nameShift = model.data!.info.allShift[0].shiftName;
          return emit(ScanQRAttendanceSuccessState(model: model.data!.info));
        } else if (apiDeviceInfo.currentDevice !=
                SpUtil.getString("uuid_device") &&
            SpUtil.getString("uuid_device") != null) {
          idShift = model.data!.info.allShift[0].shiftId;
          nameShift = model.data!.info.allShift[0].shiftName;
          emit(ScanQRAttendanceChangeDeviceState(model: model.data!.info));
        } else if (qrCode.toString().contains('timviec365.vn')) {
          emit(ScanQRAttendanceErrorState("Mã QR không hợp lệ"));
        }
      } else {
        emit(ScanQRAttendanceErrorState(res.error!.messages));
      }
      // if (res.error == null && apiDeviceInfo == null) {
      //   // return model;
      // } else if (res.error == null &&
      //     apiDeviceInfo != null &&
      //     apiDeviceInfo!.currentDevice !=
      //         SpUtil.getString("uuid_device")) {
      //   emit(ScanQRAttendanceErrorState(
      //       "Bạn đang điểm danh trên thiết bị khác"));
      // } else {
      //   print('00000: ${res.error?.messages}');

      //   emit(ScanQRAttendanceErrorState(res.error.toString()));
      //   // throw CustomException(res.error);
      // }
    } catch (e, s) {
      logger.logError(e, s);
      emit(ScanQRAttendanceErrorState(e.toString()));
    }
  }

  // ResultListShiftModel? listShiftModel;
  // List<> listShift = [];
  String? idShift;
  String? nameShift;
  double? numberOfShift;
  // Future<void> getListShift(int? idUser, int? idCom) async {
  //   var res = await scanFaceRepo.getListShift(
  //     idUser,
  //     idCom,
  //   );
  //   try {
  //     if (res.error == null) {
  //       listShiftModel = await resultListShiftModelFromJson(res.data);
  //       listShift = listShiftModel!.data!.shift;
  //       numberOfShift = double.parse(listShift.length.toString());
  //       idShift = listShift[0].  ;
  //       nameShift = listShift[0].shiftName;
  //     } else {
  //       throw CustomException(res.error);
  //     }
  //   } catch (e, s) {
  //     emit(ScanQRAttendanceErrorState(e.toString()));
  //   }
  // }

  String? logo;
  ValueNotifier<bool> attendanceResults = ValueNotifier(false);
  String? time;
  String? month;
  String? day;
  String? noteTimekeeping;
  // diem danh
  Future<bool?> timekeeping({
    String? device,
    String? uuid_device,
    double? tsLat,
    double? tsLong,
    String? tsLocationName,
    // String? wifiName,
    // String? wifiIp,
    // String? wifiMac,
    String? shiftId,
    // String? note,
    // String? isWifiValid,
    String? isLocationValid,
    String? phoneName,
    // dynamic image,
    String? from,
  }) async {
    emit(ScanQRTimeKeepingLoadingState());
    var res = await scanQrAttendanceRepo.timeKeepingQR(
        uuid_device,
        tsLat,
        tsLong,
        tsLocationName,
        shiftId,
        isLocationValid,
        device,
        phoneName,
        from);
    try {
      if (res.error == null) {
        timekeepingModel = await timeKeepingQrModelFromJson(res.data);
        attendanceResults.value = timekeepingModel!.data.isSuccess;
        time = DateFormat('HH:mm').format(timekeepingModel!.data.atTime);
        month = DateFormat('M').format(timekeepingModel!.data.atTime);
        day = DateFormat('dd').format(timekeepingModel!.data.atTime);

        noteTimekeeping = timekeepingModel!.data.note;

        // AppDialogs.toast(timekeepingModel!.data.message);
        emit(ScanQRTimeKeepingSuccessState());
      } else {
        // AppDialogs.toast(json.decode(timekeepingModel!.error)['message)']);
        return false;
      }
    } catch (e, s) {
      emit(ScanQRTimeKeepingErrorState(e.toString()));
    }
    return false;
  }
}
