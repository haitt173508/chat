import 'package:chat_365/common/blocs/user_info_bloc/bloc/user_info_bloc.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';

/// Model truyền vào list message item UI trong chi tiết chat
///
/// Gồm [UserInfoBloc], [SocketSentMessageModel]
class MessageItemModel {
  MessageItemModel({
    required this.userInfoBloc,
    required this.socketSentMessageModel,
  });

  final UserInfoBloc userInfoBloc;
  final SocketSentMessageModel socketSentMessageModel;
}
