
import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

ResultGetTokensModel resultGetTokensModelFromJson(String str) => ResultGetTokensModel.fromJson(json.decode(str));

String resultGetTokensModelToJson(ResultGetTokensModel data) => json.encode(data.toJson());

class ResultGetTokensModel {
  ResultGetTokensModel({
    required this.data,
    required this.error,
  });

  final DataToken? data;
  final ErrorResponse? error;

  factory ResultGetTokensModel.fromJson(Map<String, dynamic> json) => ResultGetTokensModel(
        data: json["data"] == null ? null : DataToken.fromJson(json["data"]),
        error: json["error"] == null ? null : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class DataToken {
  DataToken({
    required this.result,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  final bool result;
  final String message;
  final String accessToken;
  final String refreshToken;

  factory DataToken.fromJson(Map<String, dynamic> json) => DataToken(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        accessToken: json["access_token"] ?? "",
        refreshToken: json["refresh_token"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "access_token": accessToken,
        "refresh_token": refreshToken,
      };
}
