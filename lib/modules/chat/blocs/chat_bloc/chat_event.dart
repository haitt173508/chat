part of 'chat_bloc.dart';

abstract class ChatEvent {
  const ChatEvent();

// @override
// List<Object> get props => [DateTime.now()];
}

// On Events: Các event on từ server

class ChatEventOnRecievedMessage extends ChatEvent {
  final SocketSentMessageModel msg;

  ChatEventOnRecievedMessage(this.msg);

  @override
  List<Object> get props => [msg];

  @override
  int get hashCode => Object.hashAll([msg.messageId]);

  @override
  bool operator ==(Object other) =>
      other is ChatStateRecieveMessage &&
      other.runtimeType == runtimeType &&
      other.msg.messageId == msg.messageId;
}

class ChatEventOnTyping extends ChatEvent {
  final int senderId;
  final int conversationId;

  ChatEventOnTyping({
    required this.senderId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [senderId, conversationId];
}

class ChatEventOnStopTyping extends ChatEvent {
  final int senderId;
  final int conversationId;

  ChatEventOnStopTyping({
    required this.senderId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [senderId, conversationId];
}

class ChatEventOnMarkReadAllMessage extends ChatEvent {
  final int senderId;
  final int conversationId;

  ChatEventOnMarkReadAllMessage({
    required this.senderId,
    required this.conversationId,
  });

  @override
  List<Object> get props => [senderId, conversationId];
}

class ChatEventOnRecievedEmotionMessage extends ChatEvent {
  final int senderId;
  final String messageId;
  final int conversationId;
  final Emoji emoji;
  final bool checked;
  final MessageType messageType;
  final String message;

  ChatEventOnRecievedEmotionMessage({
    required this.senderId,
    required this.messageId,
    required this.conversationId,
    required this.emoji,
    required this.checked,
    required this.messageType,
    required this.message,
  });

  @override
  List<Object> get props => [
        DateTime.now(),
      ];
}

class ChatEventOnMessageEditted extends ChatEvent {
  final int? conversationId;
  final String messageId;
  final String newMessage;

  ChatEventOnMessageEditted(
    this.conversationId,
    this.messageId,
    this.newMessage,
  );

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventOnNewMemberAddedToGroup extends ChatEvent {
  final int conversationId;
  final List<IUserInfo> members;

  ChatEventOnNewMemberAddedToGroup(this.conversationId, this.members);

  @override
  List<Object> get props => [conversationId, members];
}

class ChatEventOnFriendStatusChanged extends ChatEvent {
  final int requestUserId;
  final int responseUserId;
  final FriendStatus status;

  ChatEventOnFriendStatusChanged(
      this.requestUserId, this.responseUserId, this.status);
}

class ChatEventOnPinMessage extends ChatEvent {
  final int conversationId;
  final String messageId;

  ChatEventOnPinMessage(this.conversationId, this.messageId);
}

class ChatEventOnUnPinMessage extends ChatEvent {
  final int conversationId;

  ChatEventOnUnPinMessage(this.conversationId);
}

class ChatEventOnDeleteMessage extends ChatEvent {
  final int conversationId;
  final String messageId;

  ChatEventOnDeleteMessage(this.conversationId, this.messageId);
}

class ChatEventToEmitDeleteMessageWithMessageIndexInConversation
    extends ChatEvent {
  final int conversationId;
  final String messageId;
  final int messageIndex;
  final SocketSentMessageModel? aboveMessage;
  final SocketSentMessageModel? belowMessage;

  ChatEventToEmitDeleteMessageWithMessageIndexInConversation(
    this.conversationId,
    this.messageId,
    this.messageIndex, {
    this.aboveMessage,
    this.belowMessage,
  });
}

class ChatEventOnDeleteContact extends ChatEvent {
  final int userId;
  final int chatId;

  ChatEventOnDeleteContact(this.userId, this.chatId);
}

class ChatEventOnChangeFavoriteStatus extends ChatEvent {
  final int conversationId;
  final bool isChangeToFavorite;

  ChatEventOnChangeFavoriteStatus(this.conversationId, this.isChangeToFavorite);
}

class ChatEventOnOutGroup extends ChatEvent {
  final int conversationId;
  final int deletedMemberId;
  final int newAdminId;

  ChatEventOnOutGroup(
    this.conversationId,
    this.deletedMemberId,
    this.newAdminId,
  );
}
// ========================= END ON EVENT ======================================

// ========================= Emit Events: các event emit lên server =============

class ChatEventEmitSendMessage extends ChatEvent {
  final ApiMessageModel message;
  final List<int> recieveIds;
  final ConversationBasicInfo? conversationBasicInfo;
  final List<int>? onlineUsers;

  ChatEventEmitSendMessage(
    this.message, {
    required this.recieveIds,
    this.conversationBasicInfo,
    this.onlineUsers,
  });

  @override
  List<Object> get props => [message, recieveIds];
}

class ChatEventEmitTypingChanged extends ChatEvent {
  final bool isTyping;
  final int userId;
  final int conversationId;
  final List<int> listMembers;

  ChatEventEmitTypingChanged(
    this.isTyping, {
    required this.userId,
    required this.conversationId,
    required this.listMembers,
  });

  @override
  List<Object> get props => [
        isTyping,
        userId,
        conversationId,
        ...listMembers,
      ];
}

class ChatEventEmitMarkReadMessage extends ChatEvent {
  /// Nếu [null]: đánh dấu Seen tất cả tin nhắn (chưa xem) trong cuộc trò chuyện
  final int? messageId;
  final int senderId;
  final int conversationId;
  final List<int> memebers;

  ChatEventEmitMarkReadMessage({
    this.messageId,
    required this.senderId,
    required this.conversationId,
    required this.memebers,
  });

  @override
  List<Object> get props => [
        if (messageId != null) messageId!,
        senderId,
        conversationId,
        ...memebers,
      ];
}

class ChatEventEmitChangeReationMessage extends ChatEvent {
  final int userId;
  final String messageId;
  final int conversationId;
  final Emoji emoji;
  final bool isChecked;
  final MessageType messageType;
  final String message;
  List<int> allMemberIdsInConversation;
  List<int> memberReactThisEmoji;

  ChatEventEmitChangeReationMessage(
    this.userId,
    this.messageId,
    this.conversationId,
    this.emoji,
    this.isChecked,
    this.messageType,
    this.message,
    this.allMemberIdsInConversation,
    this.memberReactThisEmoji,
  );

  @override
  List<Object> get props => [
        this.userId,
        this.messageId,
        this.conversationId,
        this.emoji,
        this.isChecked,
        this.messageType,
        this.message,
      ];
}

class ChatEventEmitDeleteMessage extends ChatEvent {
  final ApiMessageModel message;
  final List<int> members;

  ChatEventEmitDeleteMessage(this.message, this.members);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventEmitNewConversationCreated extends ChatEvent {
  final int conversationId;
  final List<int> members;

  ChatEventEmitNewConversationCreated(this.conversationId, this.members);

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventEmitEditMessage extends ChatEvent {
  final ApiMessageModel message;

  /// trường bên dưới dùng để đẩy socket
  final List<int> memebers;

  ChatEventEmitEditMessage(
    this.message, {
    required this.memebers,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventEmitChangeFavoriteConversation extends ChatEvent {
  final int userId;
  final int conversationId;
  final bool changeToFavorite;

  ChatEventEmitChangeFavoriteConversation(
    this.userId,
    this.conversationId,
    this.changeToFavorite,
  );
}

// ========================================END EMIT=========================================

class ChatEventRaiseSendMessageError extends ChatEvent {
  final ApiMessageModel message;
  final ExceptionError error;

  ChatEventRaiseSendMessageError(
    this.error, {
    required this.message,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventAddProcessingMessage extends ChatEvent {
  final ApiMessageModel message;
  final ProcessMessageType processingType;

  ChatEventAddProcessingMessage(
    this.message, {
    this.processingType = ProcessMessageType.sending,
  });

  @override
  List<Object> get props => [DateTime.now()];
}

class ChatEventRemoveMessage extends ChatEvent {
  final String messageId;

  ChatEventRemoveMessage(this.messageId);

  @override
  List<Object> get props => [DateTime.now()];
}

// Khác

class ChatEventGetConversationId extends ChatEvent {
  final int senderId;
  final int? userId;
  final int? conversationId;
  final dynamic chatInfo;
  final bool? isGroup;
  final bool? isNeedToFetchChatInfo;
  final ChatFeatureAction? action;

  ChatEventGetConversationId(
    this.senderId, {
    this.chatInfo,
    this.userId,
    this.conversationId,
    this.isGroup,
    this.isNeedToFetchChatInfo = false,
    this.action,
  });
}

class ChatEventAddFriend extends ChatEvent {
  final int senderId;
  final int chatId;

  ChatEventAddFriend(this.senderId, this.chatId);
}

class ChatEventResponseAddFriend extends ChatEvent {
  final FriendStatus status;

  /// Id người từ chối hoặc chấp nhận lợi mời
  final int responseId;

  /// Id người gửi lời mời
  final int requestId;

  ChatEventResponseAddFriend(this.responseId, this.requestId, this.status);
}

class ChatEventOnLoggedIn extends ChatEvent {
  final int userId;

  ChatEventOnLoggedIn(this.userId);
}

class ChatEventOnAuthStatusChanged extends ChatEvent {
  final int userId;
  final AuthStatus authStatus;

  ChatEventOnAuthStatusChanged(
    this.userId,
    this.authStatus,
  );

  @override
  List<Object> get props => [userId, authStatus];
}

class ChatEventResendMessage extends ChatEvent {
  final int conversationId;
  final List<ApiMessageModel> messages;
  final List<int> members;
  final Function(ApiMessageModel)? onResend;

  ChatEventResendMessage(
    this.conversationId,
    this.messages,
    this.members, {
    this.onResend,
  });
}

class ChatEventLogUotAllDevice extends ChatEvent {}
