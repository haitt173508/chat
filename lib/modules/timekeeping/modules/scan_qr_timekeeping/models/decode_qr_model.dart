// To parse this JSON data, do
//
//     final decodeQrAttendance = decodeQrAttendanceFromJson(jsonString);

import 'dart:convert';

import 'package:chat_365/utils/data/models/error_response.dart';

DecodeQrAttendanceModel decodeQrAttendanceFromJson(String str) =>
    DecodeQrAttendanceModel.fromJson(json.decode(str));

String decodeQrAttendanceToJson(DecodeQrAttendanceModel data) =>
    json.encode(data.toJson());

class DecodeQrAttendanceModel {
  DecodeQrAttendanceModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory DecodeQrAttendanceModel.fromJson(Map<String, dynamic> json) =>
      DecodeQrAttendanceModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
        "error": error == null ? null : error!.toJson(),
      };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.info,
  });

  final bool result;
  final String message;
  final Info info;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"],
        message: json["message"],
        info: Info.fromJson(json["info"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "info": info.toJson(),
      };
}

class Info {
  Info({
    required this.detailCor,
    required this.allShift,
    required this.device,
    required this.listBluetooth,
  });

  final DetailCor detailCor;
  final List<AllShift> allShift;
  final Device? device;
  final String listBluetooth;

  factory Info.fromJson(Map<String, dynamic> json) => Info(
        detailCor: DetailCor.fromJson(json["detail_cor"]),
        allShift: List<AllShift>.from(
            json["all_shift"].map((x) => AllShift.fromJson(x))),
        device: json["device"] != null ? Device.fromJson(json["device"]) : null,
        listBluetooth: json["list_bluetooth"],
      );

  Map<String, dynamic> toJson() => {
        "detail_cor": detailCor.toJson(),
        "all_shift": List<dynamic>.from(allShift.map((x) => x.toJson())),
        "device": device?.toJson() ?? "",
        "list_bluetooth": listBluetooth,
      };
}

class AllShift {
  AllShift({
    required this.shiftId,
    required this.shiftName,
    required this.startTime,
    required this.endTime,
    required this.overNight,
    required this.status,
  });

  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String overNight;
  final String status;

  factory AllShift.fromJson(Map<String, dynamic> json) => AllShift(
        shiftId: json["shift_id"],
        shiftName: json["shift_name"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        overNight: json["over_night"],
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "shift_id": shiftId,
        "shift_name": shiftName,
        "start_time": startTime,
        "end_time": endTime,
        "over_night": overNight,
        "status": status,
      };
}

class DetailCor {
  DetailCor({
    required this.corId,
    required this.comId,
    required this.corLocationName,
    required this.corLat,
    required this.corLong,
    required this.corRadius,
    required this.corCreateTime,
    required this.isDefault,
    required this.status,
    required this.qrLogo,
    required this.qrStatus,
  });

  final String corId;
  final String comId;
  final String corLocationName;
  final String corLat;
  final String corLong;
  final String corRadius;
  final DateTime corCreateTime;
  final String isDefault;
  final String status;
  final String qrLogo;
  final String qrStatus;

  factory DetailCor.fromJson(Map<String, dynamic> json) => DetailCor(
        corId: json["cor_id"],
        comId: json["com_id"],
        corLocationName: json["cor_location_name"],
        corLat: json["cor_lat"],
        corLong: json["cor_long"],
        corRadius: json["cor_radius"],
        corCreateTime: DateTime.parse(json["cor_create_time"]),
        isDefault: json["is_default"],
        status: json["status"],
        qrLogo: json["qr_logo"],
        qrStatus: json["qr_status"],
      );

  Map<String, dynamic> toJson() => {
        "cor_id": corId,
        "com_id": comId,
        "cor_location_name": corLocationName,
        "cor_lat": corLat,
        "cor_long": corLong,
        "cor_radius": corRadius,
        "cor_create_time": corCreateTime.toIso8601String(),
        "is_default": isDefault,
        "status": status,
        "qr_logo": qrLogo,
        "qr_status": qrStatus,
      };
}

class Device {
  Device({
    required this.edId,
    required this.currentDevice,
  });

  final String? edId;
  final String? currentDevice;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        edId: json["ed_id"] ?? "",
        currentDevice: json["current_device"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "ed_id": edId,
        "current_device": currentDevice,
      };
}
