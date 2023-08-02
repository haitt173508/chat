import 'dart:convert';

import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/chat_conversations/models/conversation_basic_info.dart';
import 'package:chat_365/utils/data/enums/contact_source.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/extensions/date_time_extension.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'contact.g.dart';

@HiveType(typeId: HiveTypeId.contactHiveTypeId)
class ApiContact extends ConversationBasicInfo {
  @HiveField(minId + 1)
  final int id;
  @HiveField(minId + 2)
  final String groupName;
  @HiveField(minId + 3)
  final String? status;
  @HiveField(minId + 4)
  final int? active;
  @HiveField(minId + 5)
  final int? isOnline;
  @HiveField(minId + 6)
  final int? looker;
  @HiveField(minId + 7)
  final int? statusEmotion;

  late final ContactSource _contactSrouce;

  ContactSource get contactSource => _contactSrouce;
  // final BasicDisplayInfoModel displayInfoModel;

  // final int? id365;
  // final int? type365;
  // final String? email;
  // final String? password;
  // final String? phone;
  // final int? notificationPayoff;
  // final int? notificationCalendar;
  // final int? notificationReport;
  // final int? notificationOffer;
  // final int? notificationPersonnelChange;
  // final int? notificationRewardDiscipline;
  // final int? notificationNewPersonnel;
  // final int? notificationChangeProfile;
  // final int? notificationTransferAsset;
  // final String? companyName;
  // final int? passWordType;

  ApiContact({
    required this.id,
    required String name,
    required String? avatar,
    required DateTime? lastActive,
    required int? companyId,
    this.status,
    this.active,
    this.isOnline,
    this.looker,
    this.statusEmotion,
    ContactSource? contactSource,
    String? email,
    FriendStatus friendStatus = FriendStatus.unknown,
    //
    // required this.id365,
    // required this.type365,
    // required this.email,
    // required this.password,
    // required this.phone,
    // required this.notificationPayoff,
    // required this.notificationCalendar,
    // required this.notificationReport,
    // required this.notificationOffer,
    // required this.notificationPersonnelChange,
    // required this.notificationRewardDiscipline,
    // required this.notificationNewPersonnel,
    // required this.notificationChangeProfile,
    // required this.notificationTransferAsset,
    // required this.companyName,
    // required this.passWordType,
  })  : groupName = name,
        this._contactSrouce = contactSource ?? ContactSource.company,
        super(
          userId: id,
          conversationId: -1,
          name: name,
          avatar: avatar,
          userStatus: UserStatus.fromId(active ?? UserStatus.kMinId),
          isGroup: companyId == null,
          companyId: companyId,
          email: email,
          lastActive: lastActive,
          friendStatus: friendStatus,
        );

  static const minId = ConversationBasicInfo.kConversationBasicInfoMaxFieldId;

  copyWith({String? name}) => ApiContact(
        id: this.id,
        name: name ?? this.name,
        avatar: this.avatar,
        lastActive: this.lastActive,
        companyId: this.companyId,
        status: this.status,
        active: this.active,
        isOnline: this.isOnline,
        looker: this.looker,
        statusEmotion: this.statusEmotion,
        contactSource: this.contactSource,
        email: this.email,
      );

  factory ApiContact.fromMyContact(
    Map<String, dynamic> map, {
    ContactSource? contactSource,
  }) =>
      ApiContact(
        id: map['id'],
        name: map['userName'],
        avatar: (!(map["avatarUser"] as String?).isBlank
            ? map["avatarUser"]
            : map["linkAvatar"]),
        // avatar: map['linkAvatar'] ??
        //     ImageUrlResolver.avatar(map["id"], (!(map["avatarUser"] as String?).isBlank ? map["avatarUser"] : map["linkAvatar"])),
        // id365: map['iD365'],
        // type365: map['type365'],
        // email: map['email'],
        // password: map['password'],
        // phone: map['phone'],
        status: map['status'],
        active: map['active'],
        // isOnline: map['isOnline'],
        looker: map['looker'],
        statusEmotion: map['statusEmotion'],
        lastActive: NullableDateTimeExt.lastActiveFromJson(map),
        companyId: map['companyId'],
        email: map['email'],
        friendStatus: FriendStatusExt.fromApiValue(map['friendStatus'] ?? ''),
        contactSource: contactSource,
        // notificationPayoff: map['notificationPayoff'],
        // notificationCalendar: map['notificationCalendar'],
        // notificationReport: map['notificationReport'],
        // notificationOffer: map['notificationOffer'],
        // notificationPersonnelChange: map['notificationPersonnelChange'],
        // notificationRewardDiscipline: map['notificationRewardDiscipline'],
        // notificationNewPersonnel: map['notificationNewPersonnel'],
        // notificationChangeProfile: map['notificationChangeProfile'],
        // notificationTransferAsset: map['notificationTransferAsset'],
        // companyName: map['companyName'],
        // passWordType: map['type_Pass'],
      );

  factory ApiContact.fromSocketContact(Map<String, dynamic> map) => ApiContact(
        id: map['Id'] ?? map['ID'],
        name: map['UserName'],
        avatar: (!(map["AvatarUser"] as String?).isBlank
            ? map["AvatarUser"]
            : map["LinkAvatar"]),
        // id365: map['ID365'],
        // type365: map['Type365'],
        // email: map['Email'],
        // password: map['Password'],
        // phone: map['Phone'],
        status: map['Status'],
        active: map['Active'],
        isOnline: map['IsOnline'],
        looker: map['Looker'],
        statusEmotion: map['StatusEmotion'],
        lastActive: NullableDateTimeExt.fromIsOnlineAndLastActive(
          map["IsOnline"] == 1,
          map["LastActive"],
        ),
        companyId: map['CompanyId'],
        contactSource: map['ContactSource'] != null
            ? ContactSource.values[map['ContactSource']]
            : null,
        friendStatus: FriendStatusExt.fromApiValue(map['FriendStatus'] ?? ''),
        // notificationPayoff: map['NotificationPayoff'],
        // notificationCalendar: map['NotificationCalendar'],
        // notificationReport: map['NotificationReport'],
        // notificationOffer: map['NotificationOffer'],
        // notificationPersonnelChange: map['NotificationPersonnelChange'],
        // notificationRewardDiscipline: map['NotificationRewardDiscipline'],
        // notificationNewPersonnel: map['NotificationNewPersonnel'],
        // notificationChangeProfile: map['NotificationChangeProfile'],
        // notificationTransferAsset: map['NotificationTransferAsset'],
        // companyName: map['CompanyName'],
        // passWordType: map['Type_Pass'],
      );

  Map<String, dynamic> toHiveObjectMap() => {
        'Id': id,
        'ID365': id365,
        'Email': email,
        'UserName': name,
        'AvatarUser': avatar,
        'Status': status,
        'Active': active,
        'IsOnline': isOnline,
        'Looker': looker,
        'StatusEmotion': statusEmotion,
        'LastActive': lastActive?.toTimezoneFormatString(),
        'CompanyId': companyId,
        'LinkAvatar': avatar,
        'ContactSource': _contactSrouce.index,
        'FriendStatus': friendStatus?.name,
      };

  Map<String, dynamic> toMap() => {
        'id': id,
        'iD365': id365,
        'email': email,
        // 'type365': type365,
        // 'password': password,
        // 'phone': phone,
        'userName': name,
        'avatarUser': avatar,
        'status': status,
        'active': active,
        'isOnline': isOnline,
        'looker': looker,
        'statusEmotion': statusEmotion,
        'lastActive': lastActive?.toIso8601String(),
        'companyId': companyId,
        // 'notificationPayoff': notificationPayoff,
        // 'notificationCalendar': notificationCalendar,
        // 'notificationReport': notificationReport,
        // 'notificationOffer': notificationOffer,
        // 'notificationPersonnelChange': notificationPersonnelChange,
        // 'notificationRewardDiscipline': notificationRewardDiscipline,
        // 'notificationNewPersonnel': notificationNewPersonnel,
        // 'notificationChangeProfile': notificationChangeProfile,
        // 'notificationTransferAsset': notificationTransferAsset,
        // 'companyName': companyName,
        // 'type_Pass': passWordType,
        'linkAvatar': avatar,
      };

  @override
  String toJsonString() => json.encode(toMap());

  // @override
  // List<String> get searchProps => [
  //       id.toString(),
  //       groupName,
  //       name,
  //       if (email != null) email!,
  //       if (phone != null) phone!,
  //       companyId.toString(),
  //       if (companyName != null) companyName!,
  //     ];

  @override
  Map<String, dynamic> toJson() => {
        'Id': id,
        'ID365': id365,
        'Email': email,
        'UserName': name,
        'AvatarUser': avatar,
        'Status': status,
        'Active': active,
        'IsOnline': isOnline,
        'Looker': looker,
        'StatusEmotion': statusEmotion,
        'LastActive': lastActive?.toIso8601String(),
        'CompanyId': companyId,
        'LinkAvatar': avatar,
      };
}
