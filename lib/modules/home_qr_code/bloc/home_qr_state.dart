
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:equatable/equatable.dart';

abstract class HomeQRCodeState extends Equatable {

  HomeQRCodeState();
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class   HomeQRCodeInitial extends HomeQRCodeState {}


class HomeQRCodeLoadingState extends HomeQRCodeState {
  // HomeQRCodeLoadingState();
}
class AddGroupLoadingState extends HomeQRCodeState {
  // HomeQRCodeLoadingState();
}

class HomeQRCodeError extends HomeQRCodeState {
  final ExceptionError ? error ;
  HomeQRCodeError(this.error);
  @override
  List<Object?> get props => [error];
}
class HomeQRCodeLoadedState extends HomeQRCodeState {

  HomeQRCodeLoadedState();

}
class HomeQRCodeErrorState extends HomeQRCodeState {
  final ExceptionError ? error ;
  HomeQRCodeErrorState(this.error);
  @override
  // TODO: implement props
  List<Object?> get props => [error];
}
