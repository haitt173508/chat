import 'package:chat_365/utils/data/models/error_response.dart';
import 'dart:convert';

ResultNotifyModel resultNotifyModelFromJson(String str) => ResultNotifyModel.fromJson(json.decode(str));

String resultNotifyModelToJson(ResultNotifyModel data) => json.encode(data.toJson());

class ResultNotifyModel {
  ResultNotifyModel({
    required this.data,
    required this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultNotifyModel.fromJson(Map<String, dynamic> json) => ResultNotifyModel(
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
    required this.listNotification,
  });

  final bool result;
  final String message;
  final List<ListNotification> listNotification;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] ?? false,
        message: json["message"] ?? "",
        listNotification:
            json["listNotification"] == null ? [] : List<ListNotification>.from(json["listNotification"].map((x) => ListNotification.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "listNotification": List<dynamic>.from(listNotification.map((x) => x.toJson())),
      };
}

class ListNotification {
  ListNotification({
    required this.idNotification,
    required this.userId,
    required this.participant,
    required this.title,
    required this.message,
    required this.isUnreader,
    required this.type,
    required this.messageId,
    required this.conversationId,
    required this.createAt,
    required this.time,
    required this.link,
  });

  final String idNotification;
  final int userId;
  final Participant participant;
  final String title;
  final String message;
  final int isUnreader;
  final String type;
  final dynamic messageId;
  final int conversationId;
  final DateTime createAt;
  final String time;
  final String link;

  factory ListNotification.fromJson(Map<String, dynamic> json) => ListNotification(
        idNotification: json["idNotification"] ?? "",
        userId: json["userID"] ?? 0,
        participant: Participant.fromJson(json["participant"] ?? {}),
        title: json["title"] ?? "",
        message: json["message"] ?? "",
        isUnreader: json["isUnreader"] ?? 0,
        type: json["type"] ?? "",
        messageId: json["messageId"],
        conversationId: json["conversationId"] ?? 0,
        createAt: DateTime.parse(json["createAt"] ?? ""),
        time: json["time"] ?? "",
        link: json["link"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "idNotification": idNotification,
        "userID": userId,
        "participant": participant.toJson(),
        "title": title,
        "message": message,
        "isUnreader": isUnreader,
        "type": type,
        "messageId": messageId,
        "conversationId": conversationId,
        "createAt": createAt.toIso8601String(),
        "time": time,
        "link": link,
      };
}

class Participant {
  Participant({
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
    required this.notificationMissMessage,
    required this.notificationCommentFromTimViec,
    required this.notificationCommentFromRaoNhanh,
    required this.notificationTag,
    required this.notificationSendCandidate,
    required this.notificationChangeSalary,
    required this.notificationAllocationRecall,
    required this.notificationAcceptOffer,
    required this.notificationDecilineOffer,
    required this.notificationNtdPoint,
    required this.notificationNtdExpiredPin,
    required this.notificationNtdExpiredRecruit,
    required this.fromWeb,
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
  final dynamic password;
  final dynamic phone;
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
  final dynamic companyName;
  final dynamic secretCode;
  final int notificationMissMessage;
  final int notificationCommentFromTimViec;
  final int notificationCommentFromRaoNhanh;
  final int notificationTag;
  final int notificationSendCandidate;
  final int notificationChangeSalary;
  final int notificationAllocationRecall;
  final int notificationAcceptOffer;
  final int notificationDecilineOffer;
  final int notificationNtdPoint;
  final int notificationNtdExpiredPin;
  final int notificationNtdExpiredRecruit;
  final dynamic fromWeb;
  final int id;
  final dynamic email;
  final String userName;
  final String avatarUser;
  final dynamic status;
  final int active;
  final int isOnline;
  final int looker;
  final int statusEmotion;
  final DateTime lastActive;
  final String linkAvatar;
  final int companyId;
  final dynamic friendStatus;

  factory Participant.fromJson(Map<String, dynamic> json) => Participant(
        iD365: json["iD365"] ?? 0,
        idTimViec: json["idTimViec"] ?? 0,
        type365: json["type365"] ?? 0,
        password: json["password"],
        phone: json["phone"],
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
        companyName: json["companyName"],
        secretCode: json["secretCode"],
        notificationMissMessage: json["notificationMissMessage"] ?? 0,
        notificationCommentFromTimViec: json["notificationCommentFromTimViec"] ?? 0,
        notificationCommentFromRaoNhanh: json["notificationCommentFromRaoNhanh"] ?? 0,
        notificationTag: json["notificationTag"] ?? 0,
        notificationSendCandidate: json["notificationSendCandidate"] ?? 0,
        notificationChangeSalary: json["notificationChangeSalary"] ?? 0,
        notificationAllocationRecall: json["notificationAllocationRecall"] ?? 0,
        notificationAcceptOffer: json["notificationAcceptOffer"] ?? 0,
        notificationDecilineOffer: json["notificationDecilineOffer"] ?? 0,
        notificationNtdPoint: json["notificationNTDPoint"] ?? 0,
        notificationNtdExpiredPin: json["notificationNTDExpiredPin"] ?? 0,
        notificationNtdExpiredRecruit: json["notificationNTDExpiredRecruit"] ?? 0,
        fromWeb: json["fromWeb"],
        id: json["id"] ?? 0,
        email: json["email"],
        userName: json["userName"] ?? "",
        avatarUser: json["avatarUser"] ?? "",
        status: json["status"],
        active: json["active"] ?? 0,
        isOnline: json["isOnline"] ?? 0,
        looker: json["looker"] ?? 0,
        statusEmotion: json["statusEmotion"] ?? 0,
        lastActive: DateTime.parse(json["lastActive"] ?? ""),
        linkAvatar: json["linkAvatar"] ?? "",
        companyId: json["companyId"] ?? 0,
        friendStatus: json["friendStatus"],
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
        "notificationMissMessage": notificationMissMessage,
        "notificationCommentFromTimViec": notificationCommentFromTimViec,
        "notificationCommentFromRaoNhanh": notificationCommentFromRaoNhanh,
        "notificationTag": notificationTag,
        "notificationSendCandidate": notificationSendCandidate,
        "notificationChangeSalary": notificationChangeSalary,
        "notificationAllocationRecall": notificationAllocationRecall,
        "notificationAcceptOffer": notificationAcceptOffer,
        "notificationDecilineOffer": notificationDecilineOffer,
        "notificationNTDPoint": notificationNtdPoint,
        "notificationNTDExpiredPin": notificationNtdExpiredPin,
        "notificationNTDExpiredRecruit": notificationNtdExpiredRecruit,
        "fromWeb": fromWeb,
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
