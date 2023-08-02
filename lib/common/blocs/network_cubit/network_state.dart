part of 'network_cubit.dart';

class NetworkState extends Equatable {
  const NetworkState(this.hasInternet, {this.socketDisconnected  = false});

  final bool hasInternet;

  final bool socketDisconnected;

  @override
  List<Object> get props => [hasInternet, socketDisconnected];
}
