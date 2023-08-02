// To parse this JSON data, do
//
//     final resultNotificationModel = resultNotificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:chat_365/main.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/contact/model/api_contact.dart';
import 'package:chat_365/utils/data/extensions/context_extension.dart';
import 'package:chat_365/utils/data/models/error_response.dart';

ResultSearchAllModel resultSearchAllModelFromJson(String str) =>
    ResultSearchAllModel.fromJson(json.decode(str));

// String resultNotificationModelToJson(ResultNotificationModel data) =>
//     json.encode(data.toJson());

class ResultSearchAllModel {
  ResultSearchAllModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory ResultSearchAllModel.fromJson(Map<String, dynamic> json) =>
      ResultSearchAllModel(
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        error: json["error"] == null
            ? null
            : ErrorResponse.fromJson(json['error']),
      );

  // Map<String, dynamic> toJson() => {
  //       "data": data == null ? null : data.toJson(),
  //       "error": error,
  //     };
}

class Data {
  Data({
    required this.result,
    this.message = '',
    this.listContactInCompany = const [],
    this.listGroup = const [],
    this.listEveryone = const [],
  });

  final bool result;
  final String message;
  final List<ApiContact> listContactInCompany;
  final List<ConversationBasicInfo> listGroup;
  final List<ApiContact> listEveryone;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"] == null ? null : json["result"],
        message: json["message"] == null ? null : json["message"],
        listContactInCompany: json["listContactInCompany"] == null
            ? []
            : List<ApiContact>.from(json["listContactInCompany"]
                .map((x) => ApiContact.fromMyContact(x))),
        listGroup: json["listGroup"] == null
            ? []
            : List<ConversationBasicInfo>.from(
                json["listGroup"].map(
                  (x) => ChatItemModel.fromConversationInfoJsonOfUser(
                    navigatorKey.currentContext!.userInfo().id,
                    conversationInfoJson: x,
                  ).conversationBasicInfo,
                ),
              ),
        listEveryone: json["listEveryone"] == null
            ? []
            : List<ApiContact>.from(
                json["listEveryone"].map((x) => ApiContact.fromMyContact(x))),
      );

  // Map<String, dynamic> toJson() => {
  //       "result": result == null ? null : result,
  //       "message": message == null ? null : message,
  //       "listContactInCompany": listContactInCompany == null
  //           ? null
  //           : List<dynamic>.from(listContactInCompany.map((x) => x.toJson())),
  //       "listGroup": listGroup == null
  //           ? null
  //           : List<dynamic>.from(listGroup.map((x) => x.toJson())),
  //       "listEveryone": listEveryone == null
  //           ? null
  //           : List<dynamic>.from(listEveryone.map((x) => x.toJson())),
  //     };
}
