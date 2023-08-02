// To parse this JSON data, do
//
//     final resultListMessage = resultListMessageFromJson(jsonString);

import 'dart:convert';

ResultListMessage resultListMessageFromJson(String str) => ResultListMessage.fromJson(json.decode(str));

String resultListMessageToJson(ResultListMessage data) => json.encode(data.toJson());

class ResultListMessage {
  ResultListMessage({
    required this.data,
    required this.error,
  });

  final Data? data;
  final Error? error;

  factory ResultListMessage.fromJson(Map<String, dynamic> json) => ResultListMessage(
    data:json["data"] == null ? null : Data.fromJson(json["data"]),
    error:json["error"] == null ? null : Error.fromJson(json["error"]),
  );

  Map<String, dynamic> toJson() => {
    "data":data == null ? null : data!.toJson(),
    "error": error == null? null:  error!.toJson(),
  };
}

class Data {
  Data({
    required this.result,
    required this.message,
    required this.messageInfo,
    required this.listMessages,
  });

  final bool result;
  final String message;
  final dynamic messageInfo;
  final List<ListMessage> listMessages;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    result: json["result"]??false,
    message: json["message"]??"",
    messageInfo: json["message_info"]??"",
    listMessages: json["listMessages"] == null ? [] : List<ListMessage>.from(json["listMessages"].map((x) => ListMessage.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "result": result,
    "message": message,
    "message_info": messageInfo,
    "listMessages": List<dynamic>.from(listMessages.map((x) => x.toJson())),
  };
}

class ListMessage {
  ListMessage({
    required this.messageId,
    required this.conversationId,
    required this.senderId,
    required this.messageType,
    required this.message,
    required this.emotion,
    required this.quoteMessage,
    required this.createAt,
    required this.nameFile,
    required this.sizeFile,
  });

  final int messageId;
  final int conversationId;
  final int senderId;
  final String messageType;
  final String message;
  final int emotion;
  final int quoteMessage;
  final DateTime createAt;
  final String nameFile;
  final String sizeFile;

  factory ListMessage.fromJson(Map<String, dynamic> json) => ListMessage(
    messageId: json["messageID"]??0,
    conversationId: json["conversationID"]??0,
    senderId: json["senderID"]??0,
    messageType: json["messageType"]??"",
    message: json["message"]??'',
    emotion: json["emotion"]??0,
    quoteMessage: json["quoteMessage"]??0,
    createAt: DateTime.parse(json["createAt"]),
    nameFile: json["nameFile"]??'',
    sizeFile: json["sizeFile"]??'',
  );

  Map<String, dynamic> toJson() => {
    "messageID": messageId,
    "conversationID": conversationId,
    "senderID": senderId,
    "messageType": messageType,
    "message": message,
    "emotion": emotion,
    "quoteMessage": quoteMessage,
    "createAt": createAt.toIso8601String(),
    "nameFile": nameFile,
    "sizeFile": sizeFile,
  };
}

class Error {
  Error({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;

  factory Error.fromJson(Map<String, dynamic> json) => Error(
    code: json["code"]??0,
    message: json["message"]??'',
  );

  Map<String, dynamic> toJson() => {
    "code": code == 0 ? null :code,
    "message": message == ''? null : message,
  };
}
