import 'dart:developer' show log;

import 'package:socket_io_client/socket_io_client.dart' as IO;

class ChatClient {
  static ChatClient? _instance;

  factory ChatClient() => _instance ??= ChatClient._();

  ChatClient._() {
    _socket = IO.io(
      'http://43.239.223.142:3000',
      {
        'transports': ['websocket'],
        'autoConnect': true,
        'reconnectionDelay': 500,
        'reconnectionDelayMax': 1000,
        'randomizationFactor': 0,
        'reconnection': true,
        'timeout': 30000,
        'extraHeaders': {
          'Connection': 'Upgrade',
          'Upgrade': 'websocket',
          'secure': true,
        },
      },
    );
    _listenEvents();
  }

  late final IO.Socket _socket;

  IO.Socket get socket => _socket;

  _listenEvents() {
    _socket.onConnect(_connectHandler);
    _socket.onConnectError(_connectErrorHandler);
    _socket.onConnectTimeout(_connectTimeoutHandler);
    _socket.onError(_errorHandler);
  }

  _stopListenEvents() {
    _socket.off('connect', _connectHandler);
    _socket.off('connect_error', _connectErrorHandler);
    _socket.off('connect_timeout', _connectTimeoutHandler);
    _socket.off('disconnect', _disconnectHandler);
    _socket.off('error', _errorHandler);
  }

  _connectHandler(dynamic value) => _log('Connect', value);

  _connectErrorHandler(dynamic value) => _log('ConnectError', value);

  _connectTimeoutHandler(dynamic value) => _log('ConnectTimeout', value);

  _disconnectHandler(dynamic value) => _log('Disconnect', value);

  _errorHandler(dynamic value) => _log('Error', value);

  _log(String type, dynamic msg) {
    log("$type: $msg", name: 'SocketLogger');
  }

  emit(String event, [dynamic data]) => _socket.emit(
        event,
        data is List ? Iterable.generate(data.length, (i) => data[i]) : data,
      );

  void Function(String event, dynamic Function(dynamic) handler) get on =>
      _socket.on;

  void Function(String event, [dynamic Function(dynamic) handler]) get off =>
      _socket.off;

  reconnect() {
    // _socket..connect();
    // ..reconnect();
    // _stopListenEvents();
    // _listenEvents();
  }

  _disconnect() {
    _stopListenEvents();
    _socket.disconnect();
    _instance = null;
  }

  static dispose() {
    // Memory leak issues in iOS when closing socket.
    // https://pub.dev/packages/socket_io_client#:~:text=Memory%20leak%20issues%20in%20iOS%20when%20closing%20socket.%20%23
    _instance?._socket.dispose();
  }
}

final ChatClient chatClient = ChatClient();
