// To parse this JSON data, do
//
//     final loginInfoQrModel = loginInfoQrModelFromJson(jsonString);

import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

LoginInfoQrModel loginInfoQrModelFromJson(String str) => LoginInfoQrModel.fromJson(json.decode(str));

String loginInfoQrModelToJson(LoginInfoQrModel data) => json.encode(data.toJson());

class LoginInfoQrModel {
  LoginInfoQrModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory LoginInfoQrModel.fromJson(Map<String, dynamic> json) => LoginInfoQrModel(
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
    required this.userName,
    required this.countConversation,
    required this.conversationId,
    required this.total,
    required this.currentTime,
    required this.listUserOnline,
    required this.userInfo,
    required this.userList,
  });

  final bool result;
  final String message;
  final dynamic userName;
  final int countConversation;
  final int conversationId;
  final int total;
  final int currentTime;
  final dynamic listUserOnline;
  final UserInfo userInfo;
  final dynamic userList;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        userName: json["userName"] ?? "",
        countConversation: json["countConversation"] ?? 0,
        conversationId: json["conversationId"] ?? 0,
        total: json["total"] ?? 0,
        currentTime: json["currentTime"] ?? 0,
        listUserOnline: json["listUserOnline"] == null ? null : json["listUserOnline"],
        userInfo: UserInfo.fromJson(json["user_info"] ?? {}),
        userList: json["user_list"] == null ? null : json["user_list"],
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "userName": userName,
        "countConversation": countConversation,
        "conversationId": conversationId,
        "total": total,
        "currentTime": currentTime,
        "listUserOnline": listUserOnline,
        "user_info": userInfo.toJson(),
        "user_list": userList,
      };
}

class UserInfo {
  UserInfo({
    required this.iD365,
    required this.idTimViec,
    required this.type365,
    required this.password,
    required this.phone,
    required this.notificationPayoff,
    required this.notificationCalendar,
    required this.notificationReport,
    required this.notificationOffer,
    required this.notificationPersonnelChange,
    required this.notificationRewardDiscipline,
    required this.notificationNewPersonnel,
    required this.notificationChangeProfile,
    required this.notificationTransferAsset,
    required this.acceptMessStranger,
    required this.typePass,
    required this.companyName,
    required this.secretCode,
    required this.id,
    required this.email,
    required this.userName,
    required this.avatarUser,
    required this.status,
    required this.active,
    required this.isOnline,
    required this.looker,
    required this.statusEmotion,
    required this.lastActive,
    required this.linkAvatar,
    required this.companyId,
    required this.friendStatus,
  });

  final int iD365;
  final int idTimViec;
  final int type365;
  final String password;
  final String phone;
  final int notificationPayoff;
  final int notificationCalendar;
  final int notificationReport;
  final int notificationOffer;
  final int notificationPersonnelChange;
  final int notificationRewardDiscipline;
  final int notificationNewPersonnel;
  final int notificationChangeProfile;
  final int notificationTransferAsset;
  final int acceptMessStranger;
  final int typePass;
  final String companyName;
  final dynamic secretCode;
  final int id;
  final String email;
  final String userName;
  final String avatarUser;
  final String status;
  final int active;
  final int isOnline;
  final int looker;
  final int statusEmotion;
  final DateTime lastActive;
  final String linkAvatar;
  final int companyId;
  final String friendStatus;

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        iD365: json["iD365"] ?? 0,
        idTimViec: json["idTimViec"] ?? 0,
        type365: json["type365"] ?? 0,
        password: json["password"] ?? "",
        phone: json["phone"] ?? "",
        notificationPayoff: json["notificationPayoff"] ?? 0,
        notificationCalendar: json["notificationCalendar"] ?? 0,
        notificationReport: json["notificationReport"] ?? 0,
        notificationOffer: json["notificationOffer"] ?? 0,
        notificationPersonnelChange: json["notificationPersonnelChange"] ?? 0,
        notificationRewardDiscipline: json["notificationRewardDiscipline"] ?? 0,
        notificationNewPersonnel: json["notificationNewPersonnel"] ?? 0,
        notificationChangeProfile: json["notificationChangeProfile"] ?? 0,
        notificationTransferAsset: json["notificationTransferAsset"] ?? 0,
        acceptMessStranger: json["acceptMessStranger"] ?? 0,
        typePass: json["type_Pass"] ?? 0,
        companyName: json["companyName"] ?? "",
        secretCode: json["secretCode"] == null ? null : json["secretCode"],
        id: json["id"] ?? 0,
        email: json["email"] ?? "",
        userName: json["userName"] ?? "",
        avatarUser: json["avatarUser"] ?? "",
        status: json["status"] ?? "",
        active: json["active"] ?? 0,
        isOnline: json["isOnline"] ?? 0,
        looker: json["looker"] ?? 0,
        statusEmotion: json["statusEmotion"] ?? 0,
        lastActive: DateTime.parse(json["lastActive"] ?? ""),
        linkAvatar: json["linkAvatar"] ?? "",
        companyId: json["companyId"] ?? 0,
        friendStatus: json["friendStatus"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "iD365": iD365,
        "idTimViec": idTimViec,
        "type365": type365,
        "password": password,
        "phone": phone,
        "notificationPayoff": notificationPayoff,
        "notificationCalendar": notificationCalendar,
        "notificationReport": notificationReport,
        "notificationOffer": notificationOffer,
        "notificationPersonnelChange": notificationPersonnelChange,
        "notificationRewardDiscipline": notificationRewardDiscipline,
        "notificationNewPersonnel": notificationNewPersonnel,
        "notificationChangeProfile": notificationChangeProfile,
        "notificationTransferAsset": notificationTransferAsset,
        "acceptMessStranger": acceptMessStranger,
        "type_Pass": typePass,
        "companyName": companyName,
        "secretCode": secretCode,
        "id": id,
        "email": email,
        "userName": userName,
        "avatarUser": avatarUser,
        "status": status,
        "active": active,
        "isOnline": isOnline,
        "looker": looker,
        "statusEmotion": statusEmotion,
        "lastActive": lastActive.toIso8601String(),
        "linkAvatar": linkAvatar,
        "companyId": companyId,
        "friendStatus": friendStatus,
      };
}
