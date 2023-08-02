// import 'package:chat_365/core/constants/api_path.dart';
// import 'package:chat_365/core/image_url_resolver.dart';
// import 'package:chat_365/modules/chat/model/api_message_model.dart';
// import 'package:chat_365/utils/data/chat_file_type.dart';
// import 'package:chat_365/utils/data/enums/message_type.dart';
// import 'package:chat_365/utils/helpers/time_utils.dart';
// import 'package:equatable/equatable.dart';


// class ChatMessageModel extends Equatable {
//   final String? id;
//   final String? avatar;
//   final MessageType type;
//   final String? message;
//   final String? fileDownloadLink;
//   final DateTime time;
//   final String displayTime;
//   late final ChatMessageTimeMeta timeMeta;
//   final bool? hasSeen;
//   final bool? isSender;
//   final int? senderId;
//   final String? senderName;
//   final ApiRelyMessageModel? relyMessage;
//   final List<ChatFile>? files;
//   // final ChatContact? contact;
//   final bool isSending;
//   // final BasicDisplayInfoModel basicDisplayInfoModel;

//   bool get hasRelyMessage => relyMessage != null;

//   ChatMessageModel({
//     this.id,
//     this.avatar,
//     required this.type,
//     this.message,
//     this.fileDownloadLink,
//     required this.time,
//     this.hasSeen,
//     this.isSender,
//     this.senderId,
//     this.senderName,
//     this.relyMessage,
//     this.files,
//     // this.contact,
//     this.isSending = false,
//     // required this.basicDisplayInfoModel,
//   }) : displayTime = TimeUtils.getGroupMessagesDateTimeRepresentation(time) {
//     timeMeta = ChatMessageTimeMeta(time: time, displayTime: displayTime);
//   }

//   /*
//   factory ChatMessageModel.sending({
//     String? id,
//     String? avatar,
//     required MessageType type,
//     String? message,
//     String? fileDownloadLink,
//     required DateTime time,
//     bool? hasSeen,
//     bool? sender,
//     int? senderId,
//     String? senderName,
//     ApiRelyMessageModel? relyMessage,
//     List<ChatFile>? files,
//   }) =>
//       ChatMessageModel(
//         id: id,
//         avatar: avatar,
//         type: MessageType.notification,
//         message: message,
//         fileDownloadLink: fileDownloadLink,
//         time: DateTime.parse(map["createAt"]),
//         relyMessage: relyMessage
//         isSending: true,
//       );
//   */

//   factory ChatMessageModel.notification(
//     Map<String, dynamic> map,
//     String? avatar,
//   ) =>
//       ChatMessageModel(
//         type: MessageType.notification,
//         time: DateTime.parse(map["createAt"]),
//         message: map['message'],
//       );

//   factory ChatMessageModel.fromMap(
//     Map<String, dynamic> map, {
//     required MessageType messageType,
//     String? message,
//     String? avatar,
//     required String senderName,
//     // ChatContact? contact,
//   }) {
//     if (messageType.isNotification)
//       return ChatMessageModel(
//         type: messageType,
//         time: DateTime.parse(map["createAt"]),
//         message: message ?? map['message'],
//       );

//     final int senderId = map['senderID'];
//     // final bool isSender = map['senderID'] == AuthRepo.id;
//     final bool hasSeen = map['view'] == '1';

//     if (messageType.isContactCard)
//       return ChatMessageModel(
//         type: messageType,
//         time: DateTime.parse(map["createAt"]),
//         // isSender: isSender,
//         senderId: senderId,
//         // contact: contact,
//         avatar: avatar,
//         hasSeen: hasSeen,
//       );

//     return ChatMessageModel(
//       id: map['messageID'],
//       avatar: avatar,
//       type: messageType,
//       message: message ?? map['message'],
//       fileDownloadLink:
//           map['link'] != null && map['link'].isNotEmpty ? map['link'] : null,
//       time: DateTime.parse(map["createAt"]),
//       hasSeen: hasSeen,
//       // isSender: isSender,
//       senderId: senderId,
//       senderName: senderName,
//       relyMessage: map['quoteMessage'] == null
//           ? null
//           : ApiRelyMessageModel.fromMap(map['quoteMessage']),
//       files: map['listFile'] == null || map['listFile']?.isEmpty == true
//           ? null
//           : List.from(map['listFile']).map((e) => ChatFile.fromMap(e)).toList(),
//       // basicDisplayInfoModel: BasicDisplayInfoModel(avatarUrl: avatar,)
//     );
//   }

//   ApiRelyMessageModel toApiRelyMessage() => ApiRelyMessageModel(
//         messageId: id!,
//         senderId: senderId!,
//         senderName: senderName!,
//         createAt: time,
//         message: message,
//         type: type,
//       );

//   ChatMessageModel copyWithEditedMesage(String message) => ChatMessageModel(
//         id: id,
//         avatar: avatar,
//         type: type,
//         message: message,
//         fileDownloadLink: fileDownloadLink,
//         time: time,
//         hasSeen: hasSeen,
//         isSender: true,
//         senderId: senderId,
//         senderName: senderName,
//         relyMessage: relyMessage,
//         isSending: false,
//       );

//   @override
//   List<Object?> get props => [
//         id,
//         avatar,
//         type,
//         message,
//         fileDownloadLink,
//         time,
//         hasSeen,
//         isSender,
//         senderId,
//         senderName,
//         files,
//         isSending,
//       ];
// }

// class ChatMessageTimeMeta extends Equatable {
//   final DateTime time;
//   final String displayTime;

//   ChatMessageTimeMeta({
//     required this.time,
//     required this.displayTime,
//   });

//   @override
//   List<Object?> get props => [displayTime];
// }

// class ChatFile {
//   final ChatFileType type;
//   final String fileName;
//   final String displayFileName;
//   final String displayFileSize;
//   final int fileSize;
//   final double? width;
//   final double? height;
//   final String? imageSource;
//   final String? url;
//   final String? downloadUrl;

//   ChatFile({
//     required this.type,
//     required this.fileName,
//     required this.displayFileName,
//     required this.displayFileSize,
//     required this.fileSize,
//     this.width,
//     this.height,
//     this.imageSource,
//     this.url,
//   }) : downloadUrl = ImageUrlResolver.chatDownloadFile(fileName);

//   factory ChatFile.fromMap(Map<String, dynamic> map) => ChatFile(
//         type: ChatFileTypeExt.valueOf(map['typeFile']),
//         fileName: map['fullName'],
//         displayFileName: map['nameDisplay'],
//         displayFileSize: map['fileSizeInByte'],
//         fileSize: map['sizeFile'],
//         width: map['width'].toDouble(),
//         height: map['height'].toDouble(),
//         imageSource: map['imageSource'],
//         url: ApiPath.imageDomain + map['fullName'],
//       );

//   ChatFile copyWith({
//     required String url,
//   }) =>
//       ChatFile(
//         type: type,
//         fileName: fileName,
//         displayFileName: displayFileName,
//         displayFileSize: displayFileSize,
//         fileSize: fileSize,
//         width: width,
//         height: height,
//         imageSource: imageSource,
//         url: url,
//       );
// }

// // class ChatContact extends Contact {
// //   ChatContact({
// //     required this.relatedConversationId,
// //     required ChatMemberModel currentUser,
// //     required this.totalNumberOfMessages,
// //     required int id,
// //     required String name,
// //     required String avatarUrl,
// //     required int id365,
// //     required int type365,
// //     required String email,
// //     required String password,
// //     required String phone,
// //     required String status,
// //     required int active,
// //     required int isOnline,
// //     required int looker,
// //     required int statusEmotion,
// //     required String lastActive,
// //     required int companyId,
// //     required int notificationPayoff,
// //     required int notificationCalendar,
// //     required int notificationReport,
// //     required int notificationOffer,
// //     required int notificationPersonnelChange,
// //     required int notificationRewardDiscipline,
// //     required int notificationNewPersonnel,
// //     required int notificationChangeProfile,
// //     required int notificationTransferAsset,
// //     required String companyName,
// //     required int passWordType,
// //   })  : relatedConversationBasicInfo = BasicDisplayInfoModel(
// //           avatarUrl: avatarUrl,
// //           name: name,
// //         )..id = relatedConversationId,
// //         relatedMemberList = ValueNotifier([
// //           ChatMemberModel(
// //             id: id,
// //             userName: name,
// //             avatarUser: avatarUrl,
// //             // TODO: hanlde this case
// //             unReader: 0,
// //           ),
// //           currentUser,
// //         ]),
// //         super(
// //           id: id,
// //           name: name,
// //           avatarUrl: avatarUrl,
// //           id365: id365,
// //           type365: type365,
// //           email: email,
// //           password: password,
// //           phone: phone,
// //           status: status,
// //           active: active,
// //           isOnline: isOnline,
// //           looker: looker,
// //           statusEmotion: statusEmotion,
// //           lastActive: lastActive,
// //           companyId: companyId,
// //           notificationPayoff: notificationPayoff,
// //           notificationCalendar: notificationCalendar,
// //           notificationReport: notificationReport,
// //           notificationOffer: notificationOffer,
// //           notificationPersonnelChange: notificationPersonnelChange,
// //           notificationRewardDiscipline: notificationRewardDiscipline,
// //           notificationNewPersonnel: notificationNewPersonnel,
// //           notificationChangeProfile: notificationChangeProfile,
// //           notificationTransferAsset: notificationTransferAsset,
// //           companyName: companyName,
// //           passWordType: passWordType,
// //         );

// //   final int relatedConversationId;
// //   final ValueNotifier<List<ChatMemberModel>> relatedMemberList;
// //   final BasicDisplayInfoModel relatedConversationBasicInfo;
// //   final ValueNotifier<int> totalNumberOfMessages;

// //   factory ChatContact.fromMap(
// //     Map<String, dynamic> map, {
// //     required int relatedConversationId,
// //     required ChatMemberModel currentUser,
// //     required ValueNotifier<int> totalNumberOfMessages,
// //   }) =>
// //       ChatContact(
// //         relatedConversationId: relatedConversationId,
// //         currentUser: currentUser,
// //         totalNumberOfMessages: totalNumberOfMessages,
// //         id: map['id'],
// //         name: map['userName'],
// //         avatarUrl: (!(map["avatarUser"] as String?).isBlank ? map["avatarUser"] : map["linkAvatar"]),
// //         id365: map['iD365'],
// //         type365: map['type365'],
// //         email: map['email'],
// //         password: map['password'],
// //         phone: map['phone'],
// //         status: map['status'],
// //         active: map['active'],
// //         isOnline: map['isOnline'],
// //         looker: map['looker'],
// //         statusEmotion: map['statusEmotion'],
// //         lastActive: map['lastActive'],
// //         companyId: map['companyId'],
// //         notificationPayoff: map['notificationPayoff'],
// //         notificationCalendar: map['notificationCalendar'],
// //         notificationReport: map['notificationReport'],
// //         notificationOffer: map['notificationOffer'],
// //         notificationPersonnelChange: map['notificationPersonnelChange'],
// //         notificationRewardDiscipline: map['notificationRewardDiscipline'],
// //         notificationNewPersonnel: map['notificationNewPersonnel'],
// //         notificationChangeProfile: map['notificationChangeProfile'],
// //         notificationTransferAsset: map['notificationTransferAsset'],
// //         companyName: map['companyName'],
// //         passWordType: map['type_Pass'],
// //       );

// //   factory ChatContact.fromContact(
// //     Contact contact, {
// //     required int relatedConversationId,
// //     required ChatMemberModel currentUser,
// //     required ValueNotifier<int> totalNumberOfMessages,
// //   }) =>
// //       ChatContact(
// //         relatedConversationId: relatedConversationId,
// //         currentUser: currentUser,
// //         totalNumberOfMessages: totalNumberOfMessages,
// //         id: contact.id,
// //         name: contact.name,
// //         avatarUrl: contact.avatarUrl,
// //         id365: contact.id365,
// //         type365: contact.type365,
// //         email: contact.email,
// //         password: contact.password,
// //         phone: contact.phone,
// //         status: contact.status,
// //         active: contact.active,
// //         isOnline: contact.isOnline,
// //         looker: contact.looker,
// //         statusEmotion: contact.statusEmotion,
// //         lastActive: contact.lastActive,
// //         companyId: contact.companyId,
// //         notificationPayoff: contact.notificationPayoff,
// //         notificationCalendar: contact.notificationCalendar,
// //         notificationReport: contact.notificationReport,
// //         notificationOffer: contact.notificationOffer,
// //         notificationPersonnelChange: contact.notificationPersonnelChange,
// //         notificationRewardDiscipline: contact.notificationRewardDiscipline,
// //         notificationNewPersonnel: contact.notificationNewPersonnel,
// //         notificationChangeProfile: contact.notificationChangeProfile,
// //         notificationTransferAsset: contact.notificationTransferAsset,
// //         companyName: contact.companyName,
// //         passWordType: contact.passWordType,
// //       );
// // }
