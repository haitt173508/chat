part of 'typing_detector_bloc.dart';

abstract class TypingDetectorEvent extends Equatable {
  TypingDetectorEvent();

  @override
  List<Object> get props => [];
}

class TypingDectorEventAddUser extends TypingDetectorEvent {
  final int userId;

  TypingDectorEventAddUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class TypingDetectorEventRemoveUser extends TypingDetectorEvent {
  final int userId;

  TypingDetectorEventRemoveUser(this.userId);

  @override
  List<Object> get props => [userId];
}

class TypingDetectorEventRemoveAllUser extends TypingDetectorEvent {}
