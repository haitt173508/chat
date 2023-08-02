part of 'scan_qr_attendance_bloc.dart';

abstract class ScanQrAttendanceState extends Equatable {
  const ScanQrAttendanceState();

  @override
  List<Object> get props => [];
}

// ============================================================================

class ScanQrInfoState extends ScanQrAttendanceState {}

class ScanQrAttendanceInitial extends ScanQrInfoState {}

class ScanQrAttendanceLoadingState extends ScanQrInfoState {}

class ScanQRAttendanceErrorState extends ScanQrInfoState {
  final String? error;

  ScanQRAttendanceErrorState(this.error);
}

class ScanQRAttendanceChangeDeviceState extends ScanQrInfoState {
  final Info? model;

  ScanQRAttendanceChangeDeviceState({this.model});
}

/// Quet Qr thanh cong
class ScanQRAttendanceSuccessState extends ScanQrInfoState {
  final Info model;
  ScanQRAttendanceSuccessState({
    required this.model,
  });
}

/// ===========================================================================

class ScanQrTiemKeepingState extends ScanQrAttendanceState {}

class ScanQRTimeKeepingSuccessState extends ScanQrTiemKeepingState {}

class ScanQRTimeKeepingLoadingState extends ScanQrTiemKeepingState {}

class ScanQRTimeKeepingErrorState extends ScanQrTiemKeepingState {
  final String error;

  ScanQRTimeKeepingErrorState(this.error);
}
