import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

ResultFaceVerificationModel resultFaceVerificationModelFromJson(String str) => ResultFaceVerificationModel.fromJson(json.decode(str));

String resultFaceVerificationModelToJson(ResultFaceVerificationModel data) => json.encode(data.toJson());

class ResultFaceVerificationModel {
  ResultFaceVerificationModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultFaceVerificationModel.fromJson(Map<String, dynamic> json) => ResultFaceVerificationModel(
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
    required this.item,
  });

  final bool result;
  final String message;
  final String item;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : json["result"],
        message: json["message"] == null ? null : json["message"],
        item: json["item"] == null ? null : json["item"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "item": item,
      };
}
