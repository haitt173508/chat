part of 'login_cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginLoadingQR extends LoginState {}

class LoginSuccessQR extends LoginState {}

class LoginErrorQR extends LoginState {
  final String error;

  LoginErrorQR(this.error);
}

class LoginStateInit extends LoginState {}

class LoginStateLoad extends LoginState {}

class LoginSuccessfulTestState extends LoginState {
  // final IUserInfo userInfo;
  // final UserType userType;

  // LoginSuccessfulTestState(
  //   this.userInfo, {
  //   required this.userType,
  // });
}

class LoginWrongFriendsListState extends LoginState {}

class LoginStateSuccess extends LoginState {
  final String? message;
  final IUserInfo userInfo;
  final int countConversation;
  final UserType userType;

  LoginStateSuccess(
    this.userInfo, {
    this.message,
    required this.countConversation,
    required this.userType,
  });

  @override
  List<Object> get props => [userInfo, countConversation];
}

class LoginWaring extends LoginState {
  final String? message;
  final IUserInfo userInfo;
  final int countConversation;
  final UserType userType;

  LoginWaring(
    this.userInfo, {
    this.message,
    required this.countConversation,
    required this.userType,
  });
}

// Tai khoan nhan vien chua duoc cong ty duyet
class LoginStateUnBrowser extends LoginState {
  final String? message;
  final String nameCompany;

  LoginStateUnBrowser(
    this.nameCompany, {
    this.message,
  });
}

class LoginStateError extends LoginState {
  final String error;
  final ErrorResponse? errorRes;

  LoginStateError(this.error, this.errorRes);

  @override
  List<Object> get props => [error, ...super.props];
}

class LoginStateUnconfirmed extends LoginState {
  final String error;

  LoginStateUnconfirmed(
    this.error,
  );

  @override
  List<Object> get props => [error, ...super.props];
}

class ListContactSuccessState extends LoginState {
  final ListContactData model;

  ListContactSuccessState({
    required this.model,
  });
}
