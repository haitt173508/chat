// import 'package:chat_365/modules/chat/model/api_message_model.dart';
// import 'package:chat_365/modules/contact/model/contact.dart';
// import 'package:chat_365/utils/data/enums/emoji.dart';
// import 'package:chat_365/utils/data/enums/message_type.dart';
// import 'package:chat_365/utils/helpers/time_utils.dart';
// import 'package:equatable/equatable.dart';

// class SocketSentMessageModel {
//   final int conversationId;
//   final String messageId;
//   final int senderId;
//   final MessageType? type;
//   final String? message;
//   final List<Emotion>? emotion;
//   final ApiRelyMessageModel? relyMessage;
//   final DateTime createAt;
//   final List<ApiFileModel>? files;
//   final InfoLink? infoLink;
//   final Contact? contact;

//   SocketSentMessageModel({
//     required this.conversationId,
//     required this.messageId,
//     required this.senderId,
//     this.type,
//     this.message,
//     this.emotion,
//     this.relyMessage,
//     required this.createAt,
//     this.files,
//     this.infoLink,
//     this.contact,
//   });

//   bool get hasRelyMessage => relyMessage != null;

//   factory SocketSentMessageModel.fromMap(Map<String, dynamic> map) =>
//       SocketSentMessageModel(
//         conversationId: map['conversationID'],
//         messageId: map['messageID'],
//         senderId: map['senderID'],
//         type: MessageTypeExt.valueOf(map['messageType']),
//         message: map['message'],
//         emotion: map['emotion'] != null
//             ? List<Emotion>.from(map['emotion'].map((e) => Emotion.fromMap(e)))
//             : null,
//         relyMessage: map['quoteMessage'] == null
//             ? null
//             : ApiRelyMessageModel.fromMap(map['quoteMessage']),
//         createAt: DateTime.parse(map['createAt']),
//         files: map['ListFile'] == null
//             ? null
//             : List.from(map['listFile'])
//                 .map(
//                   (e) => ApiFileModel(
//                     fileName: map['nameDisplay'],
//                     resolvedFileName: map['fullName'],
//                     fileType: MessageTypeExt.valueOf(map['typeFile']),
//                     displayFileSize: map['fileSizeInByte'],
//                     fileSize: map['sizeFile'],
//                     imageSource: map['imageSource'],
//                     width: map['width'],
//                     height: map['height'],
//                   ),
//                 )
//                 .toList(),
//         infoLink:
//             map['InfoLink'] == null ? null : InfoLink.fromMap(map['InfoLink']),
//         contact: map['userProfile'] == null
//             ? Contact.fromMyContact(map['userProfile'])
//             : null,
//       );

//   factory SocketSentMessageModel.fromMapOfSocket(Map<String, dynamic> map) {
//     final messageType = MessageTypeExt.valueOf(map['MessageType']);

//     return SocketSentMessageModel(
//       conversationId: map['ConversationID'] is String
//           ? int.parse(map['ConversationID'])
//           : map['ConversationID'],
//       messageId: map['MessageID'],
//       senderId: map['SenderID'] is String
//           ? int.parse(map['SenderID'])
//           : map['SenderID'],
//       type: messageType,
//       message: map['Message'],
//       emotion:
//           map['Emotion'] is String ? int.parse(map['Emotion']) : map['Emotion'],
//       relyMessage: map['QuoteMessage'] == null ||
//               map['QuoteMessage']?['MessageID']?.isEmpty == true
//           ? null
//           : ApiRelyMessageModel.fromMapOfSocket(map['QuoteMessage']),
//       createAt: map['CreateAt'] == null
//           ? DateTime.now()
//           : DateTime.parse(map['CreateAt']),
//       files: map['ListFile'] == null || map['ListFile']?.isEmpty == true
//           ? null
//           : List.from(map['ListFile'])
//               .map(
//                 (e) => ApiFileModel(
//                   fileName: e['NameDisplay'],
//                   resolvedFileName: e['FullName'],
//                   fileType: MessageTypeExt.valueOf(e['TypeFile']),
//                   displayFileSize: e['FileSizeInByte'],
//                   fileSize: e['SizeFile'],
//                   imageSource: e['ImageSource'],
//                   width: e['Width'] is int
//                       ? double.parse(e['Width'].toString())
//                       : e['Width'],
//                   height: e['Height'] is int
//                       ? double.parse(e['Height'].toString())
//                       : e['Height'],
//                 ),
//               )
//               .toList(),
//       infoLink:
//           map['InfoLink'] == null ? null : InfoLink.fromMap(map['InfoLink']),
//       contact: messageType.isNotContactCard || map["UserProfile"] == null
//           ? null
//           : Contact.fromSocketContact(map["UserProfile"]),
//     );
//   }

//   SocketSentMessageModel copyWith({
//     required MessageType type,
//     String? messageId,
//     String? message,
//     int? emotion,
//     ApiRelyMessageModel? relyMessage,
//     DateTime? createAt,
//     String? fileName,
//     int? fileSize,
//   }) =>
//       SocketSentMessageModel(
//         conversationId: conversationId,
//         senderId: senderId,
//         messageId: messageId ?? this.messageId,
//         type: type,
//         message: message,
//         // emotion: emotion,
//         createAt: createAt ?? this.createAt,
//         relyMessage: relyMessage,
//       );

//   Map<String, dynamic> toMap() => {
//         'MessageID': messageId,
//         'ConversationID': conversationId,
//         'SenderID': senderId,
//         'MessageType': type!.databaseName,
//         'Message': message,
//         'Emotion': emotion ?? 0,
//         'Quote': relyMessage?.toMap(),
//         'CreateAt': TimeUtils.serverDateFormat.format(createAt),
//         'InfoLink': infoLink?.toMap(),
//         'Profile': contact == null ? null : contact!.toJsonString(),
//       };

//   Map<String, dynamic> toMapOfEditedMessage() => {
//         'MessageID': messageId,
//         'Message': message,
//       };
// }

// class InfoLink {
//   final String messageId;
//   final String description;
//   final String title;
//   final String linkHome;
//   final String image;
//   final bool haveImage;

//   InfoLink({
//     required this.messageId,
//     required this.description,
//     required this.title,
//     required this.linkHome,
//     required this.image,
//     required this.haveImage,
//   });

//   factory InfoLink.fromMap(Map<String, dynamic> map) => InfoLink(
//         messageId: map['messageID'],
//         description: map['description'],
//         title: map['title'],
//         linkHome: map['linkHome'],
//         image: map['image'],
//         haveImage: map['haveImage'] == "True",
//       );

//   Map<String, dynamic> toMap() => {
//         'MessageID': messageId,
//         'Description': description,
//         'Title': title,
//         'LinkHome': linkHome,
//         'Image': image,
//         'HaveImage': haveImage,
//       };
// }