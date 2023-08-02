import 'package:chat_365/utils/data/enums/friend_status.dart';

// To parse this JSON data, do
//
//     final resultFriendModel = resultFriendModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:equatable/equatable.dart';

ResultFriendModel resultFriendModelFromJson(String str) =>
    ResultFriendModel.fromJson(json.decode(str));

class ResultFriendModel {
  ResultFriendModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultFriendModel.fromJson(Map<String, dynamic> json) =>
      ResultFriendModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json["error"]),
      );
}

class Data {
  Data({
    this.message,
    required this.result,
    required this.listRequestContact,
  });

  final bool result;
  final dynamic message;
  final List<FriendModel> listRequestContact;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : json["result"],
        message: json["message"],
        listRequestContact: List<FriendModel>.from(
            json["listRequestContact"].map((x) => FriendModel.fromJson(x))),
      );
}

class FriendModel extends Equatable {
  final int userId;
  final int contactId;
  final FriendStatus status;
  final int? type365;

  FriendModel({
    required this.userId,
    required this.contactId,
    required this.status,
    this.type365,
  });

  factory FriendModel.fromJson(Map<String, dynamic> json) => FriendModel(
        userId: json['userId'],
        contactId: json['contactId'],
        status: FriendStatusExt.fromValue(json['status']),
        type365: json['type365'],
      );

  FriendModel changeStatus(FriendStatus newStatus) => FriendModel(
        userId: userId,
        contactId: contactId,
        status: newStatus,
        type365: type365,
      );

  @override
  List<Object?> get props => [
        contactId,
        status,
      ];
}
