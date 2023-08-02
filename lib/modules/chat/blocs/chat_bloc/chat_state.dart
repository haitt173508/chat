part of 'chat_bloc.dart';

abstract class ChatState {
  ChatState();

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatInitial extends ChatState {}

/// Các State liên quan đến tin nhắn
abstract class ChatMessageState extends ChatState {
  final String messageId;

  ChatMessageState(this.messageId);
}

class ChatStateRecieveMessage extends ChatMessageState {
  final SocketSentMessageModel msg;

  /// Check tin nhắn nhận được là từ socket hay tin nhắn từ UI đẩy lên
  final bool isTempMessage;

  ChatStateRecieveMessage(
    this.msg, {
    this.isTempMessage = false,
  }) : super(msg.messageId);

  @override
  int get hashCode => Object.hashAllUnordered([msg.messageId, isTempMessage]);

  @override
  bool operator ==(Object other) =>
      other is ChatStateRecieveMessage &&
      other.runtimeType == runtimeType &&
      other.msg.messageId == msg.messageId &&
      other.isTempMessage == isTempMessage;
}

class ChatStateSendMessageSuccess extends ChatMessageState {
  final String messageId;

  ChatStateSendMessageSuccess(this.messageId) : super(messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateSendMessageError extends ChatMessageState {
  final ExceptionError error;
  final ApiMessageModel message;

  ChatStateSendMessageError(
    this.error, {
    required this.message,
  }) : super(message.messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateInProcessingMessage extends ChatMessageState {
  final ApiMessageModel message;
  final ProcessMessageType processingType;

  ChatStateInProcessingMessage(
    this.message, {
    this.processingType = ProcessMessageType.sending,
  }) : super(message.messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateEditMessageSuccess extends ChatMessageState {
  final int? conversationId;
  final String messageId;
  final String newMessage;

  ChatStateEditMessageSuccess(
    this.conversationId,
    this.messageId,
    this.newMessage,
  ) : super(messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateWarningMessageError extends ChatMessageState {
  final ExceptionError error;
  final String messageId;

  ChatStateWarningMessageError(
    this.messageId,
    this.error,
  ) : super(messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateDeleteMessageSuccess extends ChatMessageState {
  final String messageId;
  final int conversationId;
  final int? messageIndex;
  final SocketSentMessageModel? messageBelow;
  final SocketSentMessageModel? messageAbove;

  ChatStateDeleteMessageSuccess(
    this.messageId,
    this.conversationId, {
    this.messageIndex,
    this.messageBelow,
    this.messageAbove,
  }) : super(messageId);

  @override
  List<Object> get props => [messageId];
}

class ChatStateNewMemberAddedToGroup extends ChatState {
  final int conversationId;
  final List<IUserInfo> members;

  ChatStateNewMemberAddedToGroup(this.conversationId, this.members);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatStateFavoriteConversationStatusChanged extends ChatState {
  final int conversationId;
  final bool isChangeToFavorite;

  ChatStateFavoriteConversationStatusChanged(
    this.conversationId,
    this.isChangeToFavorite,
  );
}

// Get conversation ============================================================

class ChatStateGetConversationId extends ChatState {
  final IUserInfo? chatInfo;

  ChatStateGetConversationId({this.chatInfo});
}

///
class ChatStateLogUotAllDevice extends ChatState {
  ChatStateLogUotAllDevice();
}

class ChatStateGettingConversationId extends ChatStateGetConversationId {
  ChatStateGettingConversationId() : super();
}

class ChatStateGetConversationIdError extends ChatStateGetConversationId {
  final ExceptionError error;

  ChatStateGetConversationIdError(this.error, dynamic chatInfo) : super();
}

class ChatStateGetConversationIdSuccess extends ChatStateGetConversationId {
  final int conversationId;
  final IUserInfo chatInfo;
  final bool isGroup;
  final ChatFeatureAction? action;
  final ChatItemModel? chatItemModel;

  ChatStateGetConversationIdSuccess(
    this.conversationId,
    this.chatInfo,
    this.isGroup, {
    this.action,
    this.chatItemModel,
  }) : super(chatInfo: chatInfo);
}

// Response add friend =========================================================

class ChatStateOutGroup extends ChatState {
  final int conversationId;
  final int deletedId;
  final int newAdminId;

  ChatStateOutGroup(
    this.conversationId,
    this.deletedId,
    this.newAdminId,
  );
}
