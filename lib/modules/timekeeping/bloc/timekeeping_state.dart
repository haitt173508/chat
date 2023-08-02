
import 'package:chat_365/modules/timekeeping/modules/scan_face_timekeeping/model/result_list_shift_model.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:equatable/equatable.dart';

abstract class TimekeepingState extends Equatable {

  TimekeepingState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class TimekeepingLoadingState extends TimekeepingState {
  // TimekeepingLoadingState();
}

class TimeKeepingLoadingLocationState extends TimekeepingLoadingState {

}

class TimekeepingError401 extends TimekeepingState {
  final ExceptionError ? error ;
  TimekeepingError401(this.error);
  @override
  List<Object?> get props => [error];
}
class TimekeepingLoadedState extends TimekeepingState {

  TimekeepingLoadedState();

}
class TimekeepingErrorState extends TimekeepingState {
  final ExceptionError ? error ;
  TimekeepingErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
