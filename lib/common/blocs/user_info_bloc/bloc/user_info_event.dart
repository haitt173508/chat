import 'package:chat_365/utils/data/enums/auth_status.dart';
import 'package:chat_365/utils/data/enums/user_status.dart';
import 'package:equatable/equatable.dart';

abstract class UserInfoEvent extends Equatable {
  final int userId;

  UserInfoEvent(this.userId);

  @override
  List<Object?> get props => [];
}

class UserInfoEventAvatarChanged extends UserInfoEvent {
  final int userId;
  final String? avatar;

  UserInfoEventAvatarChanged({
    required this.userId,
    required this.avatar,
  }) : super(userId);

  @override
  List<Object?> get props => [avatar, userId];
}

class UserInfoEventUserNameChanged extends UserInfoEvent {
  final int userId;
  final String name;

  UserInfoEventUserNameChanged({
    required this.userId,
    required this.name,
  }) : super(userId);

  @override
  List<Object?> get props => [name, userId];
}

class UserInfoEventUserStatusChanged extends UserInfoEvent {
  final int userId;
  final UserStatus userStatus;

  UserInfoEventUserStatusChanged({
    required this.userId,
    required this.userStatus,
  }) : super(userId);

  @override
  List<Object?> get props => [userStatus, userId];
}

class UserInfoEventStatusChanged extends UserInfoEvent {
  final int userId;
  final String status;

  UserInfoEventStatusChanged({
    required this.userId,
    required this.status,
  }) : super(userId);

  @override
  List<Object?> get props => [userId, status];
}

class UserInfoEventNicknameChanged extends UserInfoEvent {
  final String newNickname;
  final int conversationId;

  UserInfoEventNicknameChanged({
    required this.newNickname,
    required this.conversationId,
  }) : super(-1);

  @override
  List<Object?> get props => [userId, newNickname, conversationId];
}

class UserInfoEventActiveTimeChanged extends UserInfoEvent {
  final AuthStatus status;
  final int userId;
  final DateTime? lastActive;

  UserInfoEventActiveTimeChanged(
    this.userId,
    this.status, {
    required this.lastActive,
  }) : super(userId);

  @override
  List<Object?> get props => [status, userId, lastActive];
}