import 'dart:convert';

import 'package:chat_365/utils/data/models/error_response.dart';

ListLoginHistoryModel listLoginHistoryModelFromJson(String str) =>
    ListLoginHistoryModel.fromJson(json.decode(str));

String listLoginHistoryModelToJson(ListLoginHistoryModel data) =>
    json.encode(data.toJson());

class ListLoginHistoryModel {
  ListLoginHistoryModel({
    required this.data,
    required this.error,
  });

  final LoginHistoryData? data;
  final ErrorResponse? error;

  factory ListLoginHistoryModel.fromJson(Map<String, dynamic> json) =>
      ListLoginHistoryModel(
        data: json["data"] == null
            ? null
            : LoginHistoryData.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class LoginHistoryData {
  LoginHistoryData({
    required this.result,
    required this.message,
    required this.historyAccess,
    required this.latestDevice,
  });

  final bool result;
  final String message;
  final List<LatestDevice> historyAccess;
  final LatestDevice latestDevice;

  factory LoginHistoryData.fromJson(Map<String, dynamic> json) =>
      LoginHistoryData(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        historyAccess: List<LatestDevice>.from(
            json["HistoryAccess"].map((x) => LatestDevice.fromJson(x))),
        latestDevice: LatestDevice.fromJson(json["latestDevice"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "HistoryAccess":
            List<dynamic>.from(historyAccess.map((x) => x.toJson())),
        "latestDevice": latestDevice.toJson(),
      };
}

class LatestDevice {
  LatestDevice({
    required this.idDevice,
    required this.ipAddress,
    required this.nameDevice,
    required this.time,
    required this.accessPermision,
    required this.location,
    required this.status,
    required this.method,
  });

  final String idDevice;
  final String ipAddress;
  final String nameDevice;
  final DateTime time;
  final bool accessPermision;
  final String location;
  final bool status;
  final String method;

  factory LatestDevice.fromJson(Map<String, dynamic> json) => LatestDevice(
        idDevice: json["IdDevice"] ?? "",
        ipAddress: json["IpAddress"] ?? "",
        nameDevice: json["NameDevice"] ?? "",
        time: DateTime.parse(json["Time"] ?? ""),
        accessPermision: json["AccessPermision"] ?? false,
        location: json["location"] ?? "",
        status: json["status"] ?? false,
        method: json["method"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "IdDevice": idDevice,
        "IpAddress": ipAddress,
        "NameDevice": nameDevice,
        "Time": time.toIso8601String(),
        "AccessPermision": accessPermision,
        "location": location,
        "status": status,
        "method": method,
      };
}
