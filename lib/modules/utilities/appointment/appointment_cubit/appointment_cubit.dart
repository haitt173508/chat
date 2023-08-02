import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'appointment_state.dart';

class AppointmentCubit extends Cubit<AppointmentState> {
  AppointmentCubit() : super(AppointmentInitial());
}
