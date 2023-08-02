// part of 'signup_cubit.dart';
import 'package:chat_365/utils/data/models/error_response.dart';
import 'package:equatable/equatable.dart';

abstract class ScanQRState extends Equatable {
  const ScanQRState();

  @override
  List<Object> get props => [];
}

  class ScanQRInitial extends ScanQRState {}

class SignUpStateInit extends ScanQRState {}

class SignUpStateLoad extends ScanQRState {}

class SignUpStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpCompanyStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpEmployeeStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  SignUpEmployeeStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class SignUpStateError extends ScanQRState {
  final String error;

  SignUpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Gui ma otp
class SendOtpStateLoad extends ScanQRState {}

class SendOtpStateSuccess extends ScanQRState {
  final String message = 'Gửi mã otp thành công';
  // final IUserInfo userInfo;

  SendOtpStateSuccess();
  @override
  List<Object> get props => [];
}

class SendOtpStateError extends ScanQRState {
  final String error;

  SendOtpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

class SendOtpExistEmailStateError extends ScanQRState {
  final String error;

  SendOtpExistEmailStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Gui lai ma otp
class ReSendOtpStateLoad extends ScanQRState {}

class ReSendOtpStateSuccess extends ScanQRState {
  final String message = 'Gửi mã otp thành công';
  // final IUserInfo userInfo;

  ReSendOtpStateSuccess();
  @override
  List<Object> get props => [];
}

class ReSendOtpStateError extends ScanQRState {
  final String error;

  ReSendOtpStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan id cong ty
class CompareIdCompanyStateLoad extends ScanQRState {}

class CompareIdCompanyStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  CompareIdCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CompareIdCompanyStateError extends ScanQRState {
  final String error;

  CompareIdCompanyStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Cap nhat mat khau
class UpdatePassStateLoad extends ScanQRState {}

class UpdatePassStateSuccess extends ScanQRState {
  final String message;
  // final IUserInfo userInfo;

  UpdatePassStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class ChangePassStateSuccess extends ScanQRState {
  final String message;
  // final IUserInfo userInfo;

  ChangePassStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class UpdatePassStateError extends ScanQRState {
  final String error;

  UpdatePassStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

class ChangePassStateError extends ScanQRState {
  final String error;

  ChangePassStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan otp
class CompareOTPStateLoad extends ScanQRState {}

class CompareOTPStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  CompareOTPStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CompareOTPStateError extends ScanQRState {
  final String error;

  CompareOTPStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Xac nhan otp
class AddFirstEmployeeStateLoad extends ScanQRState {}

class AddFirstEmployeeStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  AddFirstEmployeeStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class AddFirstEmployeeStateError extends ScanQRState {
  final String error;

  AddFirstEmployeeStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Kiem tra ten cong ty
class CheckNameCompanyStateLoad extends ScanQRState {}

class CheckNameCompanyStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  CheckNameCompanyStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CheckNameCompanyStateError extends ScanQRState {
  final String error;
  final ErrorResponse? errorRes;
  CheckNameCompanyStateError(this.error, this.errorRes);

  @override
  List<Object> get props => [error, ...super.props];
}

//* Kiem tra tai khoan dang ky
class CheckAccountStateLoad extends ScanQRState {}

class CheckAccountStateSuccess extends ScanQRState {
  final String? message;
  // final IUserInfo userInfo;

  CheckAccountStateSuccess({
    this.message,
  });
  @override
  List<Object> get props => [];
}

class CheckAccountStateError extends ScanQRState {
  final String error;
  final ErrorResponse? errorRes;
  CheckAccountStateError(this.error, this.errorRes);

  @override
  List<Object> get props => [error, ...super.props];
}

//*Lay danh sach to
class GetNestStateLoad extends ScanQRState {}

class GetNestStateSuccess extends ScanQRState {
  final String message;
  // final IUserInfo userInfo;

  GetNestStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class GetNestStateError extends ScanQRState {
  final String error;

  GetNestStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}

//*Lay danh sach nhom
class GetGroupStateLoad extends ScanQRState {}

class GetGroupStateSuccess extends ScanQRState {
  final String message;
  // final IUserInfo userInfo;

  GetGroupStateSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [];
}

class GetGroupStateError extends ScanQRState {
  final String error;

  GetGroupStateError(this.error);

  @override
  List<Object> get props => [error, ...super.props];
}
