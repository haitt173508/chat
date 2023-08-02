import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

ResultTimekeepingConfigurationModel resultTimekeepingConfigurationModelFromJson(String str) =>
    ResultTimekeepingConfigurationModel.fromJson(json.decode(str));

String resultTimekeepingConfigurationModelToJson(ResultTimekeepingConfigurationModel data) => json.encode(data.toJson());

class ResultTimekeepingConfigurationModel {
  ResultTimekeepingConfigurationModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultTimekeepingConfigurationModel.fromJson(Map<String, dynamic> json) => ResultTimekeepingConfigurationModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null ? null : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.config,
  });

  final bool result;
  final String message;
  final Config config;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        config: Config.fromJson(json["config"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "config": config.toJson(),
      };
}

class Config {
  Config({
    required this.idWay,
    required this.typeTimekeeping,
    required this.listWifi,
    required this.listCoordinate,
    required this.allShift,
    required this.listBluetooth,
  });

  final String idWay;
  final String typeTimekeeping;
  final List<ListWifi> listWifi;
  final List<ListCoordinate> listCoordinate;
  final List<AllShift> allShift;
  final String listBluetooth;

  factory Config.fromJson(Map<String, dynamic> json) => Config(
        idWay: json["id_way"] ?? "",
        typeTimekeeping: json["type_timekeeping"] ?? "",
        listWifi: json["list_wifi"] == null ? [] : List<ListWifi>.from(json["list_wifi"].map((x) => ListWifi.fromJson(x))),
        listCoordinate:
            json["list_coordinate"] == null ? [] : List<ListCoordinate>.from(json["list_coordinate"].map((x) => ListCoordinate.fromJson(x))),
        allShift: json["all_shift"] == null ? [] : List<AllShift>.from(json["all_shift"].map((x) => AllShift.fromJson(x))),
        listBluetooth: json["list_bluetooth"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "id_way": idWay,
        "type_timekeeping": typeTimekeeping,
        "list_wifi": List<dynamic>.from(listWifi.map((x) => x.toJson())),
        "list_coordinate": List<dynamic>.from(listCoordinate.map((x) => x.toJson())),
        "all_shift": List<dynamic>.from(allShift.map((x) => x.toJson())),
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
    required this.startTimeLatest,
    required this.endTimeEarliest,
  });

  final String shiftId;
  final String shiftName;
  final String startTime;
  final String endTime;
  final String overNight;
  final String status;
  final String startTimeLatest;
  final String endTimeEarliest;

  factory AllShift.fromJson(Map<String, dynamic> json) => AllShift(
        shiftId: json["shift_id"] ?? "",
        shiftName: json["shift_name"] ?? "",
        startTime: json["start_time"] ?? "",
        endTime: json["end_time"] ?? "",
        overNight: json["over_night"] ?? "",
        status: json["status"] ?? "",
        startTimeLatest: json["start_time_latest"] ?? "",
        endTimeEarliest: json["end_time_earliest"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "shift_id": shiftId,
        "shift_name": shiftName,
        "start_time": startTime,
        "end_time": endTime,
        "over_night": overNight,
        "status": status,
        "start_time_latest": startTimeLatest,
        "end_time_earliest": endTimeEarliest,
      };
}

class ListCoordinate {
  ListCoordinate({
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

  factory ListCoordinate.fromJson(Map<String, dynamic> json) => ListCoordinate(
        corId: json["cor_id"] ?? "",
        comId: json["com_id"] ?? "",
        corLocationName: json["cor_location_name"] ?? "",
        corLat: json["cor_lat"] ?? "",
        corLong: json["cor_long"] ?? "",
        corRadius: json["cor_radius"] ?? "",
        corCreateTime: json["cor_create_time"] == null? DateTime.now(): DateTime.parse(json["cor_create_time"]),
        isDefault: json["is_default"] ?? "",
        status: json["status"] ?? "",
        qrLogo: json["qr_logo"] ?? "",
        qrStatus: json["qr_status"] ?? "",
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

class ListWifi {
  ListWifi({
    required this.wifiId,
    required this.comId,
    required this.nameWifi,
    required this.macAddress,
    required this.ipAddress,
    required this.createTime,
    required this.isDefault,
    required this.status,
  });

  final String wifiId;
  final String comId;
  final String nameWifi;
  final String macAddress;
  final String ipAddress;
  final DateTime createTime;
  final String isDefault;
  final String status;

  factory ListWifi.fromJson(Map<String, dynamic> json) => ListWifi(
        wifiId: json["wifi_id"] ?? "",
        comId: json["com_id"] ?? "",
        nameWifi: json["name_wifi"] ?? "",
        macAddress: json["mac_address"] ?? "",
        ipAddress: json["ip_address"] ?? "",
        createTime: DateTime.parse(json["create_time"] ?? ""),
        isDefault: json["is_default"] ?? "",
        status: json["status"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "wifi_id": wifiId,
        "com_id": comId,
        "name_wifi": nameWifi,
        "mac_address": macAddress,
        "ip_address": ipAddress,
        "create_time": createTime.toIso8601String(),
        "is_default": isDefault,
        "status": status,
      };
}
