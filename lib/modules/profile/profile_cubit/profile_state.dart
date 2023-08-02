import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:equatable/equatable.dart';

abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ProfileStateLoading extends ProfileState {}

class ProfileStateLoadError extends ProfileState {
  final ExceptionError error;

  ProfileStateLoadError(this.error);

  @override
  List<Object?> get props => [DateTime.now()];
}

class ProfileStateLoadDone extends ProfileState {
  final ChatItemModel profile;

  ProfileStateLoadDone(this.profile);

  @override
  List<Object?> get props => [DateTime.now()];
}

//Change password
class ChangePasswordStateLoading extends ProfileState {}

class ChangePasswordStateDone extends ProfileState {
  @override
  List<Object?> get props => [DateTime.now()];
}

class ChangePasswordStateError extends ProfileState {
  final ExceptionError error;

  ChangePasswordStateError(this.error);
  @override
  List<Object?> get props => [DateTime.now()];
}

//Change name (group, nickName)
class ChangeNameStateLoading extends ProfileState {}

class ChangeNameStateDone extends ProfileState {
  @override
  List<Object?> get props => [DateTime.now()];
}

class ChangeNameStateError extends ProfileState {
  final ExceptionError error;

  ChangeNameStateError(this.error);
  @override
  List<Object?> get props => [DateTime.now()];
}

//Remove
class RemoveMemberStateLoading extends ProfileState {}

class RemoveMemberStateDone extends ProfileState {
  @override
  List<Object?> get props => [DateTime.now()];
}

class RemoveMemberStateError extends ProfileState {
  final ExceptionError error;

  RemoveMemberStateError(this.error);
  @override
  List<Object?> get props => [DateTime.now()];
}

//Change avatar
class ChangeAvatarStateLoading extends ProfileState {}

class ChangeAvatarStateDone extends ProfileState {
  @override
  List<Object?> get props => [DateTime.now()];
}

class ChangeAvatarStateError extends ProfileState {
  final ExceptionError error;

  ChangeAvatarStateError(this.error);
  @override
  List<Object?> get props => [DateTime.now()];
}
