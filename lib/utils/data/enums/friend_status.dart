import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'friend_status.g.dart';

@HiveType(typeId: HiveTypeId.friendStatusHiveTypeId)
enum FriendStatus {
  @HiveField(0)
  decline,

  /// [user hiện tại] gửi kết bạn đến [user khác]
  @HiveField(1)
  send,

  /// [user khác] gửi kết bạn đến [user hiện tại]
  @HiveField(2)
  request,
  @HiveField(3)
  accept,
  @HiveField(4)
  unknown,
}

extension FriendStatusExt on FriendStatus {
  String get apiValue {
    switch (this) {
      case FriendStatus.accept:
        return 'accept';
      case FriendStatus.decline:
        return 'deciline';
      case FriendStatus.request:
        return 'request';
      case FriendStatus.send:
        return 'send';
      default:
        return 'none';
    }
  }

  static FriendStatus fromValue(String value) =>
      FriendStatus.values.singleWhere(
        (e) => e.apiValue == value,
        orElse: () => FriendStatus.unknown,
      );

  static final _apiValue = {
    'none': FriendStatus.unknown,
    'accept': FriendStatus.accept,
    'deciline': FriendStatus.decline,
    'send': FriendStatus.send,
    'request': FriendStatus.request,
    'friend': FriendStatus.accept,
  };

  static FriendStatus fromApiValue(String value) =>
      _apiValue[value] ?? FriendStatus.unknown;
}
