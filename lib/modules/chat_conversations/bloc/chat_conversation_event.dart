part of 'chat_conversation_bloc.dart';

abstract class ChatConversationEvent {
  const ChatConversationEvent();

  @override
  List<Object> get props => [];
}

class ChatConversationEventAddData extends ChatConversationEvent {
  final List<ChatItemModel> list;
  final bool saveToLocal;
  final bool insertAtTop;

  ChatConversationEventAddData(
    this.list, {
    this.saveToLocal = false,
    this.insertAtTop = false,
  });

  @override
  List<Object> get props => [list];
}

class ChatConversationEventRaiseError extends ChatConversationEvent {
  final ExceptionError error;

  ChatConversationEventRaiseError(this.error);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatConversationEventAddLoadingState extends ChatConversationEvent {
  final bool? markNeedBuild;

  ChatConversationEventAddLoadingState({this.markNeedBuild = false});

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatConversationEventDeleteConversation extends ChatConversationEvent {
  final int conversationId;

  ChatConversationEventDeleteConversation(this.conversationId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatConversationEventAddFavoriteConversation
    extends ChatConversationEvent {
  final ChatItemModel item;

  ChatConversationEventAddFavoriteConversation(this.item);
}

class ChatConversationEventRemoveFavoriteConversation
    extends ChatConversationEvent {
  final ChatItemModel item;

  ChatConversationEventRemoveFavoriteConversation(this.item);
}
