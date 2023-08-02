// To parse this JSON data, do
//
//     final resultRollCallModel = resultRollCallModelFromJson(jsonString);

import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

ResultRollCallModel resultRollCallModelFromJson(String str) => ResultRollCallModel.fromJson(json.decode(str));

// String resultRollCallModelToJson(ResultRollCallModel data) => json.encode(data.toJson());

class ResultRollCallModel {
  ResultRollCallModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultRollCallModel.fromJson(Map<String, dynamic> json) => ResultRollCallModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null ? null : ErrorResponse.fromJson(json["error"]),
      );

  // Map<String, dynamic> toJson() => {
  //       "data": data.toJson(),
  //       "error": error,
  //     };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.id,
    required this.isSuccess,
    required this.atTime,
    required this.image,
    required this.note,
  });

  final bool result;
  final String message;
  final String id;
  final bool isSuccess;
  final DateTime atTime;
  final String image;
  final String note;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        id: json["id"] ?? "",
        isSuccess: json["is_success"] ?? false,
        atTime: DateTime.parse(json["at_time"] ?? ""),
        image: json["image"] ?? "",
        note: json["note"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "id": id,
        "is_success": isSuccess,
        "at_time": atTime.toIso8601String(),
        "image": image,
        "note": note,
      };
}
