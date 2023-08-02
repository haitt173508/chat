import 'dart:async';
import 'dart:convert';

import 'package:chat_365/data/services/hive_service/hive_type_id.dart';
import 'package:chat_365/modules/auth/modules/login/models/result_login.dart';
import 'package:chat_365/utils/data/enums/friend_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:chat_365/utils/data/enums/user_type.dart';
import 'package:equatable/equatable.dart';
import 'package:hive_flutter/adapters.dart';

/// Thêm 1 trường [HiveField] cần tăng thêm 1 đơn vị
const kMaxIUserInfoMaxFieldId = 11;

/// Hiển thị [name], [avatar], [id] người dùng hiện tại
@HiveType(typeId: HiveTypeId.iUserInfoHiveTypeId)
abstract class IUserInfo extends Equatable with Comparable<IUserInfo> {
  @HiveField(0)
  int id;
  @HiveField(1)
  String name;
  @HiveField(2)
  UserStatus userStatus;

  /// Avatar lưu dưới dạng List\<int\> hoặc String url
  @HiveField(3)
  dynamic avatar;

  @HiveField(4)
  int? companyId;
  @HiveField(5)
  final String? email;
  @HiveField(6)
  final int? id365;

  /// Dòng text hiển thị dưới tên người dùng
  @HiveField(7)
  String? status;

  /// Thời gian online gần nhất
  ///
  /// Nếu là [null]: người đó đang online
  @HiveField(8)
  DateTime? lastActive;
  @HiveField(9)
  String? password;

  /// [FriendStatus] của user với user hiện tại
  /// - Nếu là user => mặc định [FriendStatus.unknown]
  /// - Nếu là group hoặc không phải thông tin người dùng => [null]
  @HiveField(10)
  FriendStatus? friendStatus;

  @HiveField(11)
  UserType? userType;

  IUserInfo({
    required this.id,
    required this.name,
    this.id365,
    this.avatar,
    this.companyId,
    this.userStatus = UserStatus.online,
    this.email,
    this.status,
    this.lastActive,
    this.password,
    this.friendStatus,
    this.userType,
  });

  factory IUserInfo.fromJson(
    Map<String, dynamic> json, {
    UserType userType = UserType.staff,
  }) {
    // if (userType == UserType.staff || userType == UserType.customer)
    return UserInfo.fromJson(json);
    // else
    //   throw UnimplementedError();
  }

  factory IUserInfo.fromLocalStorageJson(
    Map<String, dynamic> json, {
    UserType userType = UserType.staff,
  }) {
    // if (userType == UserType.staff || userType == UserType.customer)
    return UserInfo.fromLocalStorageJson(json);
    // else
    //   throw UnimplementedError();
  }

  Map<String, dynamic> toJson();

  FutureOr<Map<String, dynamic>> toLocalStorageJson();

  String toJsonString() => json.encode(toJson());

  @override
  int compareTo(IUserInfo other) {
    return this.name.compareTo(other.name);
  }

  @override
  List<Object?> get props => [id];
}

class BasicInfo extends IUserInfo {
  BasicInfo({
    required int id,
    String? name,
    // required this.state,
  }) : super(
          id: id,
          name: name ?? 'Người dùng $id',
          // userStatus: state,
        );

  // final UserStatus state;
  String get name => super.name;

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }

  @override
  FutureOr<Map<String, dynamic>> toLocalStorageJson() {
    throw UnimplementedError();
  }

  @override
  String toString() => name;
}
