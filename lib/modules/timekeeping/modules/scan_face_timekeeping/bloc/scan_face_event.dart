import 'package:equatable/equatable.dart';

  abstract class ScanFaceEvent extends Equatable {}

class ApiCameraAttendance extends ScanFaceEvent {
  final String? image;

  ApiCameraAttendance(this.image);

  @override
  // TODO: implement props
  List<Object> get props => [];
}
