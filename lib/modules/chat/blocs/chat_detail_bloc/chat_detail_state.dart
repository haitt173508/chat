part of 'chat_detail_bloc.dart';

abstract class ChatDetailState {
  const ChatDetailState();

  @override
  List<Object> get props => [];
}

class ChatDetailInitial extends ChatDetailState {}

class ChatDetailStateLoading extends ChatDetailState {
  final bool markNeedBuild;

  ChatDetailStateLoading(this.markNeedBuild);
}

class ChatDetailStateLoadDetailDone extends ChatDetailState {
  final ChatItemModel detail;
  final bool isBroadcastUpdate;

  ChatDetailStateLoadDetailDone(
    this.detail, {
    this.isBroadcastUpdate = true,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatDetailStateLoadDoneListMessages extends ChatDetailState {
  final List<SocketSentMessageModel> listMsgModels;

  ChatDetailStateLoadDoneListMessages(this.listMsgModels);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatDetailStateError extends ChatDetailState {
  final ExceptionError error;

  ChatDetailStateError(this.error);

  @override
  List<Object> get props => [error, DateTime.now()];
}

class ChatDetailStateMarkReadMessage extends ChatDetailState {
  final int conversationId;
  final int senderId;

  ChatDetailStateMarkReadMessage(this.conversationId, this.senderId);
}
