import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/bloc/scan_face_state.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_face_verification_model.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_list_shift_model.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_roll_call_model.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/repo/scan_face_repo.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:chat_365/utils/ui/app_dialogs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class ScanFaceBloc extends Cubit<ScanFaceState> {
  ScanFaceRepo scanFaceRepo = ScanFaceRepo();

  ScanFaceBloc() : super(ApiCameraAttendanceInitial());
  ResultFaceVerificationModel? model;
  bool? checkScan;

  Future ScanFaceTimekeeping(
    int? idCom,
    int? idUser,
    String img,
  ) async {
    logo = null;
    emit(ApiCameraAttendanceLoading());
    var res = await scanFaceRepo.scanFaceTimekeeping(
      idCom,
      idUser,
      img,
    );
    try {
      if (res.error == null) {
        model = await resultFaceVerificationModelFromJson(res.data);
        AppDialogs.toast(model!.data!.message);
        emit(ApiCameraAttendanceSuccess(
          model!,
          base64ImageString: model!.data!.item,
        ));
      } else {
        AppDialogs.toast(res.error!.messages!);
        emit(ScanFaceError(res.error.toString()));
        // throw CustomException(res.error);
      }
    } catch (e, s) {
      logger.logError(e, s);
      emit(ScanFaceError(e.toString()));
    }
  }

  ResultListShiftModel? listShiftModel;
  List<Shift> listShift = [];
  String? idShift;
  String? nameShift;
  double? numberOfShift;
  Shift? itemShift;

  Future<void> getListShift(int? idUser, int? idCom) async {
    var res = await scanFaceRepo.getListShift(
      idUser,
      idCom,
    );
    try {
      if (res.error == null) {
        listShiftModel = await resultListShiftModelFromJson(res.data);
        listShift = listShiftModel!.data!.shift;
        numberOfShift = double.parse(listShift.length.toString());
        idShift = listShift[0].shiftId;
        nameShift = listShift[0].shiftName;
        emit(ScanFaceAttendanceSuccessState(model: listShiftModel!.data!));
      } else {
        throw CustomException(res.error);
      }
    } catch (e, s) {
      emit(ScanFaceError(e.toString()));
    }
  }

  Shift shift = Shift.fromJson({});

  ///Lấy ca làm việc gần nhất
  void getDefaultShift(List<Shift> listShift) {
    // print('listShift: ${listShift.length}');
    final f = new DateFormat('HH:mm');
    var tempDate = new DateFormat("HH:mm").parse(f.format(new DateTime.now()));
    List<int> list = [];
    listShift.forEach((element) {
      list.add(tempDate.difference(DateFormat("HH:mm").parse(element.startTime)).inSeconds.abs());
      list.add(tempDate.difference(DateFormat("HH:mm").parse(element.endTime)).inSeconds.abs());
      if (tempDate.difference(DateFormat("HH:mm").parse(element.startTime)).inSeconds.abs() <= list.reduce(min) ||
          tempDate.difference(DateFormat("HH:mm").parse(element.endTime)).inSeconds.abs() <= list.reduce(min)) {
        shift = element;
      }
    });
  }

  Shift getShiftSelected() => shift;

  void setShiftSelected(Shift selectedShift) {
    shift = selectedShift;

    // add(ReloadSelectedShift());
  }

  String? logo;
  String? error;
  ValueNotifier<bool> attendanceResults = ValueNotifier(false);
  ResultRollCallModel? timekeepingModel;
  String? time;
  String? month;
  String? day;
  String? noteTimekeeping;

  Future timekeeping(
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
    attendanceResults.value = false;
    emit(ApiCameraAttendanceLoading());
    var res = await scanFaceRepo.timeKeeping(
      device,
      tsLat,
      tsLong,
      tsLocationName,
      wifiName,
      wifiIp,
      wifiMac,
      shiftId,
      note,
      isWifiValid,
      isLocationValid,
      image,
    );
    try {
      timekeepingModel = await resultRollCallModelFromJson(res.data);
      if (res.error == null) {
        final modelData = timekeepingModel!.data!;
        logo = modelData.image;
        attendanceResults.value = modelData.isSuccess;
        time = DateFormat('HH:mm').format(modelData.atTime);
        month = DateFormat('M').format(modelData.atTime);
        day = DateFormat('dd').format(modelData.atTime);
        noteTimekeeping = modelData.note;
        AppDialogs.toast(modelData.message);
        error = modelData.message;
      } else {
        emit(ScanFaceError(res.error.toString()));
      }
    } catch (e, s) {
      logger.logError(e, s);
      emit(ScanFaceError(e.toString()));
    }
  }
}
