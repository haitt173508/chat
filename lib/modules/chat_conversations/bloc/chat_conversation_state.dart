part of 'chat_conversation_bloc.dart';

abstract class ChatConversationState {
  const ChatConversationState();

  @override
  List<Object> get props => [];
}

class ChatConversationInitial extends ChatConversationState {}

class ChatConversationStateLoading extends ChatConversationState {
  final bool markNeedBuild;

  ChatConversationStateLoading({required this.markNeedBuild});

  @override
  List<Object> get props => [markNeedBuild];
}

class ChatConversationStateLoadDone extends ChatConversationState {
  final List<ChatItemModel> _chatItems;

  ChatConversationStateLoadDone(List<ChatItemModel> chatItems)
      : this._chatItems = [...chatItems];

  List<ChatItemModel> get chatItems => _chatItems;

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatConversationStateError extends ChatConversationState {
  final ExceptionError error;
  final bool markNeedBuild;

  ChatConversationStateError(
    this.error, {
    required this.markNeedBuild,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatConversationAddFavoriteSuccessState
    extends ChatConversationStateLoadDone {
  ChatConversationAddFavoriteSuccessState(
    List<ChatItemModel> chatItems,
    this.item,
  ) : super(chatItems);

  final ChatItemModel item;
}

class ChatConversationRemoveFavoriteSuccessState
    extends ChatConversationStateLoadDone {
  ChatConversationRemoveFavoriteSuccessState(
    List<ChatItemModel> chatItems,
    this.item,
  ) : super(chatItems);

  final ChatItemModel item;
}
