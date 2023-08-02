// To parse this JSON data, do
//
//     final resultNotificationModel = resultNotificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/utils/data/models/error_response.dart';

ResultNotificationModel resultNotificationModelFromJson(String str) =>
    ResultNotificationModel.fromJson(json.decode(str));

class ResultNotificationModel {
  ResultNotificationModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultNotificationModel.fromJson(Map<String, dynamic> json) =>
      ResultNotificationModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"],
      );
}

class Data {
  Data({
    required this.result,
    this.message,
    required this.listNotification,
  });

  final bool result;
  final String? message;
  final List<NotificationModel> listNotification;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : json["result"],
        message: json["message"] == null ? null : json["message"],
        listNotification: List<NotificationModel>.from(
            json["listNotification"].map((x) => NotificationModel.fromJson(x))),
      );
}

class NotificationModel {
  NotificationModel({
    required this.idNotification,
    required this.userId,
    required this.participant,
    required this.message,
    required this.isUnreader,
    required this.type,
    required this.createAt,
    required this.time,
    this.title,
    this.messageId,
    this.conversationId,
  });

  final String idNotification;
  final int userId;
  final IUserInfo participant;
  final String? title;
  final String message;
  final int isUnreader;
  final NotificationType type;
  final String? messageId;
  final int? conversationId;
  final DateTime createAt;
  final String time;

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        idNotification:
            json["idNotification"] == null ? null : json["idNotification"],
        userId: json["userID"] == null ? null : json["userID"],
        participant: UserInfo.fromJson(json["participant"]),
        title: json["title"],
        message: json["message"],
        isUnreader: json["isUnreader"] == null ? null : json["isUnreader"],
        type: NotificationTypeExt.fromValue(json["type"]),
        messageId: json["messageId"],
        conversationId:
            json["conversationId"] == null ? null : json["conversationId"],
        createAt: DateTime.parse(json["createAt"]),
        time: json["time"] == null ? null : json["time"],
      );
}

enum NotificationType { TIMEKEEING, UNKNOWN }

extension NotificationTypeExt on NotificationType {
  String get value {
    switch (this) {
      case NotificationType.TIMEKEEING:
        return 'Timekeeing';
      default:
        return '';
    }
  }

  static NotificationType fromValue(String value) =>
      NotificationType.values.singleWhere(
        (e) => e.value == value,
        orElse: () => NotificationType.UNKNOWN,
      );
}
