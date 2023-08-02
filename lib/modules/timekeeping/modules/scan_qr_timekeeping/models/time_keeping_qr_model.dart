// To parse this JSON data, do
//
//     final timeKeepingQrModel = timeKeepingQrModelFromJson(jsonString);

import 'dart:convert';

TimeKeepingQrModel timeKeepingQrModelFromJson(String str) =>
    TimeKeepingQrModel.fromJson(json.decode(str));

String timeKeepingQrModelToJson(TimeKeepingQrModel data) =>
    json.encode(data.toJson());

class TimeKeepingQrModel {
  TimeKeepingQrModel({
    required this.data,
    required this.error,
  });

  final Data data;
  final dynamic error;

  factory TimeKeepingQrModel.fromJson(Map<String, dynamic> json) =>
      TimeKeepingQrModel(
        data: Data.fromJson(json["data"]),
        error: json["error"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "error": error,
      };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.isSuccess,
    required this.atTime,
    required this.image,
    required this.note,
  });

  final bool result;
  final String message;
  final bool isSuccess;
  final DateTime atTime;
  final String image;
  final String note;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"],
        message: json["message"],
        isSuccess: json["is_success"],
        atTime: DateTime.parse(json["at_time"]),
        image: json["image"],
        note: json["note"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "is_success": isSuccess,
        "at_time": atTime.toIso8601String(),
        "image": image,
        "note": note,
      };
}
