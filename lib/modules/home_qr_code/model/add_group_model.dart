import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:meta/meta.dart';
import 'dart:convert';

AddGroupModel addGroupModelFromJson(String str) => AddGroupModel.fromJson(json.decode(str));

String addGroupModelToJson(AddGroupModel data) => json.encode(data.toJson());

class AddGroupModel {
  AddGroupModel({
    this.data,
    this.error,
  });

  final Data? data;
  final ErrorResponse? error;

  factory AddGroupModel.fromJson(Map<String, dynamic> json) => AddGroupModel(
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
    required this.listNameFile,
    required this.conversationId,
    required this.conversationInfo,
  });

  final bool result;
  final String message;
  final dynamic listNameFile;
  final int conversationId;
  final ConversationInfo conversationInfo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        result: json["result"],
        message: json["message"],
        listNameFile: json["listNameFile"],
        conversationId: json["conversationId"],
        conversationInfo: ConversationInfo.fromJson(json["conversationInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "result": result,
        "message": message,
        "listNameFile": listNameFile,
        "conversationId": conversationId,
        "conversationInfo": conversationInfo.toJson(),
      };
}

class ConversationInfo {
  ConversationInfo({
    required this.conversationId,
    required this.companyId,
    required this.conversationName,
    required this.avatarConversation,
    required this.unReader,
    required this.isGroup,
    required this.senderId,
    required this.pinMessageId,
    required this.message,
    required this.messageType,
    required this.createAt,
    required this.countMessage,
    required this.messageDisplay,
    required this.typeGroup,
    required this.adminId,
    required this.shareGroupFromLink,
    required this.memberList,
    required this.browseMember,
    required this.isFavorite,
    required this.notification,
    required this.isHidden,
    required this.deleteTime,
    required this.deleteType,
    required this.listMess,
    required this.linkAvatar,
    required this.listBrowerMember,
    required this.listMember,
    required this.listMessage,
  });

  final int conversationId;
  final int companyId;
  final String conversationName;
  final String avatarConversation;
  final int unReader;
  final int isGroup;
  final int senderId;
  final String pinMessageId;
  final String message;
  final String messageType;
  final DateTime createAt;
  final int countMessage;
  final int messageDisplay;
  final String typeGroup;
  final int adminId;
  final int shareGroupFromLink;
  final dynamic memberList;
  final int browseMember;
  final int isFavorite;
  final int notification;
  final int isHidden;
  final int deleteTime;
  final int deleteType;
  final int listMess;
  final String linkAvatar;
  final List<dynamic> listBrowerMember;
  final List<ListMember> listMember;
  final dynamic listMessage;

  factory ConversationInfo.fromJson(Map<String, dynamic> json) => ConversationInfo(
        conversationId: json["conversationId"] ?? 0,
        companyId: json["companyId"] ?? 0,
        conversationName: json["conversationName"] ?? "",
        avatarConversation: json["avatarConversation"] ?? "",
        unReader: json["unReader"] ?? 0,
        isGroup: json["isGroup"] ?? 0,
        senderId: json["senderId"] ?? 0,
        pinMessageId: json["pinMessageId"] ?? "",
        message: json["message"] ?? "",
        messageType: json["messageType"] ?? "",
        createAt: DateTime.parse(json["createAt"] ?? ""),
        countMessage: json["countMessage"] ?? 0,
        messageDisplay: json["messageDisplay"] ?? 0,
        typeGroup: json["typeGroup"] ?? "",
        adminId: json["adminId"] ?? 0,
        shareGroupFromLink: json["shareGroupFromLink"] ?? 0,
        memberList: json["memberList"] ?? 0,
        browseMember: json["browseMember"] ?? 0,
        isFavorite: json["isFavorite"] ?? 0,
        notification: json["notification"] ?? 0,
        isHidden: json["isHidden"] ?? 0,
        deleteTime: json["deleteTime"] ?? 0,
        deleteType: json["deleteType"] ?? 0,
        listMess: json["listMess"] ?? 0,
        linkAvatar: json["linkAvatar"] ?? "",
        listBrowerMember: json["listBrowerMember"] == null ? [] : List<dynamic>.from(json["listBrowerMember"].map((x) => x)),
        listMember: json["listMember"] == null ? [] : List<ListMember>.from(json["listMember"].map((x) => ListMember.fromJson(x))),
        listMessage: json["listMessage"],
      );

  Map<String, dynamic> toJson() => {
        "conversationId": conversationId,
        "companyId": companyId,
        "conversationName": conversationName,
        "avatarConversation": avatarConversation,
        "unReader": unReader,
        "isGroup": isGroup,
        "senderId": senderId,
        "pinMessageId": pinMessageId,
        "message": message,
        "messageType": messageType,
        "createAt": createAt.toIso8601String(),
        "countMessage": countMessage,
        "messageDisplay": messageDisplay,
        "typeGroup": typeGroup,
        "adminId": adminId,
        "shareGroupFromLink": shareGroupFromLink,
        "memberList": memberList,
        "browseMember": browseMember,
        "isFavorite": isFavorite,
        "notification": notification,
        "isHidden": isHidden,
        "deleteTime": deleteTime,
        "deleteType": deleteType,
        "listMess": listMess,
        "linkAvatar": linkAvatar,
        "listBrowerMember": List<dynamic>.from(listBrowerMember.map((x) => x)),
        "listMember": List<dynamic>.from(listMember.map((x) => x.toJson())),
        "listMessage": listMessage,
      };
}

class ListMember {
  ListMember({
    required this.id,
    required this.userName,
    required this.avatarUser,
    required this.status,
    required this.active,
    required this.isOnline,
    required this.statusEmotion,
    required this.lastActive,
    required this.unReader,
    required this.linkAvatar,
    required this.companyId,
    required this.timeLastSeener,
  });

  final int id;
  final String userName;
  final String avatarUser;
  final String status;
  final int active;
  final int isOnline;
  final int statusEmotion;
  final String lastActive;
  final int unReader;
  final String linkAvatar;
  final int companyId;
  final DateTime timeLastSeener;

  factory ListMember.fromJson(Map<String, dynamic> json) => ListMember(
        id: json["id"] ?? 0,
        userName: json["userName"] ?? "",
        avatarUser: json["avatarUser"] ?? "",
        status: json["status"] ?? "",
        active: json["active"] ?? 0,
        isOnline: json["isOnline"] ?? 0,
        statusEmotion: json["statusEmotion"] ?? 0,
        lastActive: json["lastActive"] ?? "",
        unReader: json["unReader"] ?? 0,
        linkAvatar: json["linkAvatar"] ?? "",
        companyId: json["companyId"] ?? 0,
        timeLastSeener: DateTime.parse(json["timeLastSeener"] ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "avatarUser": avatarUser,
        "status": status,
        "active": active,
        "isOnline": isOnline,
        "statusEmotion": statusEmotion,
        "lastActive": lastActive,
        "unReader": unReader,
        "linkAvatar": linkAvatar,
        "companyId": companyId,
        "timeLastSeener": timeLastSeener.toIso8601String(),
      };
}
