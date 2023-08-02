part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();

  @override
  List<Object> get props => [];
}

class ChatDetailEventLoadConversationDetail extends ChatDetailEvent {}

/// Event fetch data từ api
///
/// Dùng để load ds Message khi vào màn ChatScreen và chức năng Loadmore
class ChatDetailEventFetchListMessges extends ChatDetailEvent {}

/// addAll([listMsgs]) vào sau list
class ChatDetailEventAddNewListMessages extends ChatDetailEvent {
  final List<SocketSentMessageModel> listMsgs;

  /// Check tin nhắn thêm vào là tin nhắn từ socket hay tin nhắn fake lên UI
  final bool isTempMessage;

  ChatDetailEventAddNewListMessages(
    this.listMsgs, {
    this.isTempMessage = false,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

/// insertAll([listMsgs]) vào trước list
class ChatDetailEventInsertNewListMessages extends ChatDetailEvent {
  final List<SocketSentMessageModel> listMsgs;

  ChatDetailEventInsertNewListMessages(this.listMsgs);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatDetailEventRaiseError extends ChatDetailEvent {
  final ExceptionError error;

  ChatDetailEventRaiseError(this.error);

  @override
  List<Object> get props => [error];
}

class ChatDetailEventMarkReadMessage extends ChatDetailEvent {
  final int conversationId;
  final int senderId;

  ChatDetailEventMarkReadMessage(this.conversationId, this.senderId);
}
