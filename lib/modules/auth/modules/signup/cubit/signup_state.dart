part of 'signup_cubit.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}

class SignUpInitial extends SignUpState {}

class SignUpStateInit extends SignUpState {}

class SignUpStateLoad extends SignUpState {}

class SignUpStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpCompanyStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpEmployeeStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpEmployeeStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpStateError extends SignUpState {
  final String error;

  SignUpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Gui ma otp
class SendOtpStateLoad extends SignUpState {}

class SendOtpStateSuccess extends SignUpState {
  final String message = 'Gửi mã otp thành công';
  // final IUserInfo userInfo;

  SendOtpStateSuccess();
  @override
  List<Object> get props => [];
}

class SendOtpStateError extends SignUpState {
  final String error;

  SendOtpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

class SendOtpExistEmailStateError extends SignUpState {
  final String error;

  SendOtpExistEmailStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Gui lai ma otp
class ReSendOtpStateLoad extends SignUpState {}

class ReSendOtpStateSuccess extends SignUpState {
  final String message = 'Gửi mã otp thành công';
  // final IUserInfo userInfo;

  ReSendOtpStateSuccess();
  @override
  List<Object> get props => [];
}

class ReSendOtpStateError extends SignUpState {
  final String error;

  ReSendOtpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan id cong ty
class CompareIdCompanyStateLoad extends SignUpState {}

class CompareIdCompanyStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  CompareIdCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CompareIdCompanyStateError extends SignUpState {
  final String error;

  CompareIdCompanyStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Cap nhat mat khau
class UpdatePassStateLoad extends SignUpState {}

class UpdatePassStateSuccess extends SignUpState {
  final String message;
  // final IUserInfo userInfo;

  UpdatePassStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class ChangePassStateSuccess extends SignUpState {
  final String message;
  // final IUserInfo userInfo;

  ChangePassStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class UpdatePassStateError extends SignUpState {
  final String error;

  UpdatePassStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

class ChangePassStateError extends SignUpState {
  final String error;

  ChangePassStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan otp
class CompareOTPStateLoad extends SignUpState {}

class CompareOTPStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  CompareOTPStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CompareOTPStateError extends SignUpState {
  final String error;

  CompareOTPStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan otp
class AddFirstEmployeeStateLoad extends SignUpState {}

class AddFirstEmployeeStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  AddFirstEmployeeStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class AddFirstEmployeeStateError extends SignUpState {
  final String error;

  AddFirstEmployeeStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Kiem tra ten cong ty
class CheckNameCompanyStateLoad extends SignUpState {}

class CheckNameCompanyStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  CheckNameCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CheckNameCompanyStateError extends SignUpState {
  final String error;
  final ErrorResponse? errorRes;
  CheckNameCompanyStateError(this.error, this.errorRes);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Kiem tra tai khoan dang ky
class CheckAccountStateLoad extends SignUpState {}

class CheckAccountStateSuccess extends SignUpState {
  final String? message;
  // final IUserInfo userInfo;

  CheckAccountStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CheckAccountStateError extends SignUpState {
  final String error;
  final ErrorResponse? errorRes;
  CheckAccountStateError(this.error, this.errorRes);

  @override
  List<Object> get props => [error, ...super.props];
}

//*Lay danh sach to
class GetNestStateLoad extends SignUpState {}

class GetNestStateSuccess extends SignUpState {
  final String message;
  // final IUserInfo userInfo;

  GetNestStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class GetNestStateError extends SignUpState {
  final String error;

  GetNestStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//*Lay danh sach nhom
class GetGroupStateLoad extends SignUpState {}

class GetGroupStateSuccess extends SignUpState {
  final String message;
  // final IUserInfo userInfo;

  GetGroupStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class GetGroupStateError extends SignUpState {
  final String error;

  GetGroupStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}
