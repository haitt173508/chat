import 'dart:convert';

import 'package:chat_365/utils/data/models/error_response.dart';

DetailCompanyModel detailCompanyModelFromJson(String str) =>
    DetailCompanyModel.fromJson(json.decode(str));

String detailCompanyModelToJson(DetailCompanyModel data) =>
    json.encode(data.toJson());

class DetailCompanyModel {
  DetailCompanyModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory DetailCompanyModel.fromJson(Map<String, dynamic> json) =>
      DetailCompanyModel(
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
    required this.message,
    required this.item,
  });

  final bool result;
  final String message;
  final DetailModel item;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        item: DetailModel.fromJson(json["item"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "item": item.toJson(),
      };
}

class DetailModel {
  DetailModel({
    required this.username,
    required this.title,
    required this.cate,
    required this.money,
    required this.city,
    required this.link,
  });

  final String username;
  final String title;
  final String cate;
  final String money;
  final String city;
  final String link;

  factory DetailModel.fromJson(Map<String, dynamic> json) => DetailModel(
        username: json["username"] ?? "",
        title: json["title"] ?? "",
        cate: json["cate"] ?? "",
        money: json["money"] ?? "",
        city: json["city"] ?? "",
        link: json["link"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "title": title,
        "cate": cate,
        "money": money,
        "city": city,
        "link": link,
      };
}
