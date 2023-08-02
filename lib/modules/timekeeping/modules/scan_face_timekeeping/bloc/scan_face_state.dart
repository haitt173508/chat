import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_face_verification_model.dart';
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_list_shift_model.dart';
import 'package:equatable/equatable.dart';

abstract class ScanFaceState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class   ApiCameraAttendanceInitial extends ScanFaceState {}

class ScanFaceAttendanceSuccessState extends ScanFaceState {
  final GetListShift  model;
  ScanFaceAttendanceSuccessState({
    required this.model,
  });
}
class ScanFaceInfoState extends ScanFaceState {}

class ApiCameraAttendanceSuccess extends ScanFaceState {
  final ResultFaceVerificationModel resultAttendanceApi;
  final String base64ImageString;

  ApiCameraAttendanceSuccess(
    this.resultAttendanceApi, {
    required this.base64ImageString,
  });
}

class ApiCameraAttendanceLoading extends ScanFaceState {}

class ScanFaceError extends ScanFaceState {
  final String error;

  ScanFaceError(this.error);
}
