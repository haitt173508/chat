import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

ContactVerificationModel contactVerificationModelFromJson(String str) =>
    ContactVerificationModel.fromJson(json.decode(str));

String contactVerificationModelToJson(ContactVerificationModel data) =>
    json.encode(data.toJson());

class ContactVerificationModel {
  ContactVerificationModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ContactVerificationModel.fromJson(Map<String, dynamic> json) =>
      ContactVerificationModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class Data {
  Data({
    required this.result,
    required this.status,
  });

  final bool result;
  final bool status;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        status: json["status"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "status": status,
      };
}
