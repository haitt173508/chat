import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

LoginVerificationModel loginVerificationModelFromJson(String str) =>
    LoginVerificationModel.fromJson(json.decode(str));

String loginVerificationModelToJson(LoginVerificationModel data) =>
    json.encode(data.toJson());

class LoginVerificationModel {
  LoginVerificationModel({
    this.data,
    this.error,
  });

  final ListContactData? data;
  final ErrorResponse? error;

  factory LoginVerificationModel.fromJson(Map<String, dynamic> json) =>
      LoginVerificationModel(
        data: json["data"] == null
            ? null
            : ListContactData.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error": error,
      };
}

class ListContactData {
  ListContactData({
    required this.result,
    required this.message,
    required this.listAccount,
    this.friendlist = const [],
  });

  final bool result;
  final String message;
  final List<ApiContact> listAccount;
  final List<ApiContact> friendlist;

  factory ListContactData.fromJson(Map<String, dynamic> json) =>
      ListContactData(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        listAccount: json["listAccount"] == null
            ? []
            : List<ApiContact>.from(json["listAccount"].map((x) => ApiContact(
                  id: x["_id"] ?? 0,
                  name: x["userName"] ?? "",
                  avatar: x["avatarUser"] ?? "",
                  lastActive: DateTime.tryParse(x["listAccountFinal"] ?? ""),
                  isOnline: x["isOnline"] ?? 0,
                  companyId: null,
                ))),
        friendlist: json["friendlist"] == null
            ? []
            : List<ApiContact>.from(json["friendlist"].map((x) => ApiContact(
                  id: x["_id"] ?? 0,
                  name: x["userName"] ?? "",
                  avatar: x["avatarUser"] ?? "",
                  lastActive: DateTime.tryParse(x["listAccountFinal"] ?? ""),
                  isOnline: x["isOnline"] ?? 0,
                  companyId: null,
                ))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "listAccount": List<dynamic>.from(listAccount.map((x) => x.toJson())),
        "friendlist": List<dynamic>.from(friendlist.map((x) => x.toJson())),
      };
}

class FriendList {
  FriendList({
    required this.id,
    required this.userName,
    required this.avatarUser,
    required this.lastActive,
    required this.isOnline,
    required this.listAccountFinal,
  });

  final int id;
  final String userName;
  final String avatarUser;
  final DateTime lastActive;
  final int isOnline;
  final DateTime listAccountFinal;

  factory FriendList.fromJson(Map<String, dynamic> json) => FriendList(
        id: json["_id"] ?? 0,
        userName: json["userName"] ?? "",
        avatarUser: json["avatarUser"] ?? "",
        lastActive: DateTime.parse(json["lastActive"] ?? ""),
        isOnline: json["isOnline"] ?? 0,
        listAccountFinal: DateTime.parse(json["listAccountFinal"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userName": userName,
        "avatarUser": avatarUser,
        "lastActive": lastActive == null ? null : lastActive.toIso8601String(),
        "isOnline": isOnline,
        "listAccountFinal": listAccountFinal == null
            ? null
            : listAccountFinal.toIso8601String(),
      };
}
