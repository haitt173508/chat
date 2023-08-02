import 'package:chat_365/core/interfaces/interface_user_info.dart';
import 'package:equatable/equatable.dart';

class UserInfoState extends Equatable {
  const UserInfoState(this.userInfo);

  final IUserInfo userInfo;

  @override
  List<Object> get props => [DateTime.now()];
}

class UserInfoStateActiveTimeChanged extends UserInfoState {
  final DateTime? lastActive;

  UserInfoStateActiveTimeChanged(this.lastActive, IUserInfo userInfo)
      : super(userInfo);
}
