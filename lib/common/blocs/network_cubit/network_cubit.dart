import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:chat_365/data/services/network_service/network_service.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:equatable/equatable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  NetworkCubit() : super(NetworkState(true)) {
    check;

    _subscription = _dataConnectionChecker.onStatusChange.listen((event) {
      if (event == DataConnectionStatus.disconnected) {
        emit(NetworkState(false));
        logger.log('Lost connection', name: 'Internet Checker');
      } else {
        emit(NetworkState(true));
        logger.log('Connection back', name: 'Internet Checker');
      }
    });
  }

  late final StreamSubscription _subscription;
  final DataConnectionChecker _dataConnectionChecker = DataConnectionChecker();

  Stream<NetworkState> get networkStream => stream.asBroadcastStream();

  Future<DataConnectionStatus> get check =>
      _dataConnectionChecker.connectionStatus;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
