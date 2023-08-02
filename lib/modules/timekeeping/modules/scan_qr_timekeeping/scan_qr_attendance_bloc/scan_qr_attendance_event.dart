part of 'scan_qr_attendance_bloc.dart';

abstract class ScanQrAttendanceEvent extends Equatable {
  const ScanQrAttendanceEvent();

  @override
  List<Object> get props => [];
}

class ScanQrRequestEvent extends ScanQrAttendanceEvent {}
