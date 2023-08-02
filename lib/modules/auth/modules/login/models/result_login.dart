// To parse this JSON data, do
//
//     final resultLogin = resultLoginFromJson(jsonString);

import 'dart:convert';

import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/data/services/sp_utils_service/sp_utils_services.dart';
import 'package:chat_365/utils/data/clients/api_client.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/error_response.dart';

ResultLogin resultLoginFromJson(String str) =>
    ResultLogin.fromJson(json.decode(str));

String resultLoginToJson(ResultLogin data) => json.encode(data.toJson());

class ResultLogin {
  ResultLogin({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultLogin.fromJson(Map<String, dynamic> json) => ResultLogin(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );

  Map<String, dynamic> toJson() => {
        "data": data == null ? null : data!.toJson(),
        "error": error == null ? null : error!.toJson(),
      };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.userInfo,
    required this.serverSentTime,
    required this.countConversation,
    required this.warning,
  }) {
    if (serverSentTime != 0) {
      serverTicks = serverSentTime;
      serverDifferenceTickWithClient = DateTimeExt.currentTicks - serverTicks;
    } else {
      serverDifferenceTickWithClient = spService.serverDiffTickWithClient ?? 0;
    }
    spService.saveServerDiffTickWithClient(serverDifferenceTickWithClient);
  }

  final bool result;
  final String message;
  final UserInfo userInfo;
  final int serverSentTime;
  final int countConversation;
  final int warning;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? '',
        userInfo: UserInfo.fromJson(json["user_info"] ?? {}),
        serverSentTime: json["currentTime"],
        countConversation: json["countConversation"],
        warning: json["warning"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "user_info": userInfo.toJson(),
        "warning": warning,
      };
}

class UserInfo extends IUserInfo {
  UserInfo({
    required this.id,
    required this.userName,
    required this.avatarUser,
    required this.active,
    this.fromWeb = '',
    this.email,
    this.password,
    this.phone,
    String? status,
    this.isOnline,
    this.looker,
    this.statusEmotion,
    DateTime? lastActive,
    this.companyId,
    this.companyName,
    int? id365,
  })  : _status = status,
        _lastActive = lastActive,
        super(
          id: id,
          name: userName,
          companyId: companyId,
          email: email,
          status: status,
          userStatus: active,
          lastActive: lastActive,
          id365: id365,
          password: password,
        ) {
    avatarUser.isBlank
        ? ApiClient()
            .downloadImage(avatarUser)
            .then((value) => value.isNotEmpty ? avatar = value : avatarUser)
        : avatar = avatarUser;
  }

  String? get status => super.status;

  DateTime? get lastActive => super.lastActive;

  final int id;
  final String userName;
  final String avatarUser;
  final UserStatus active;
  final String? email;
  final String? password;
  final String? phone;
  final String? _status;
  final int? isOnline;
  final int? looker;
  final int? statusEmotion;
  final DateTime? _lastActive;
  final int? companyId;
  final String? companyName;
  final String fromWeb;

  @override
  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
        id: json["id"] ?? json["_id"] ?? 0,
        email: json["email"] ?? "",
        password: json["password"] ?? "",
        phone: json["phone"] ?? "",
        userName: json["userName"] ?? "",
        avatarUser: (!(json["avatarUser"] as String?).isBlank
                ? json["avatarUser"]
                : json["linkAvatar"]) is String
            ? ((!(json["avatarUser"] as String?).isBlank
                    ? json["avatarUser"]
                    : json["linkAvatar"]) ??
                "")
            : "",
        status: json["status"] ?? '',
        active: UserStatus.fromId(json["active"] ?? 0),
        isOnline: json["isOnline"] ?? 0,
        looker: json["looker"] ?? 0,
        statusEmotion: json["statusEmotion"] ?? 0,
        lastActive: NullableDateTimeExt.lastActiveFromJson(json),
        companyId: json["companyId"] ?? 0,
        companyName: json["companyName"] ?? "",
        id365: json["iD365"] ?? json["id365"],
        fromWeb: json["fromWeb"] ?? "",
      );

  @override
  factory UserInfo.fromLocalStorageJson(Map<String, dynamic> json) =>
      UserInfo.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "password": password,
        "phone": phone,
        "userName": userName,
        "avatarUser": avatarUser,
        "status": status,
        "active": active.id,
        "isOnline": isOnline,
        "looker": looker,
        "statusEmotion": statusEmotion,
        "lastActive": DateTimeExt.lastActiveServerDateFormat
            .format(lastActive ?? DateTime.now()),
        "companyId": companyId,
        "companyName": companyName,
        "iD365": id365,
        "fromWeb": fromWeb,
      };

  @override
  Map<String, dynamic> toLocalStorageJson() {
    return toJson()
      ..['avatar'] = avatar
      ..["userStatus"] = userStatus;
  }
}
