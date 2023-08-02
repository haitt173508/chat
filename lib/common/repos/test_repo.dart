// import 'dart:async';
// import 'dart:developer';

// import 'package:chat_365/core/constants/chat_socket_event.dart';
// import 'package:chat_365/utils/data/clients/chat_client.dart';

// class TestRepo {
//   StreamController _controller = StreamController();

//   get stream => _controller.stream;

//   TestRepo() {
//     _chatClient.emit(ChatSocketEvent.login, {1408});
//     _chatClient.on(
//       ChatSocketEvent.messageSent,
//       func,
//     );
//   }

//   func(msg) {
//     log(msg.toString());
//     _controller.sink.add(msg);
//   }

//   dispose() {
//     _controller.close();
//   }
// }
