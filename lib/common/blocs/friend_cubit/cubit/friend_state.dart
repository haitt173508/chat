part of 'friend_cubit.dart';

abstract class FriendState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FriendStateLoading extends FriendState {}

class FriendStateLoadSuccess extends FriendState {
  @override
  List<Object?> get props => [DateTime.now()];
}

class FriendStateStatusChanged extends FriendState {
  final int contactId;
  final FriendStatus friendStatus;

  FriendStateStatusChanged(
    this.contactId, {
    required this.friendStatus,
  });

  @override
  List<Object?> get props => [contactId, friendStatus];
}

class FriendStateLoadError extends FriendState {
  final ExceptionError error;
  final bool markNeedBuild;

  FriendStateLoadError(
    this.error, {
    this.markNeedBuild = false,
  });

  @override
  List<Object?> get props => [DateTime.now()];
}

// Add friend ==================================================================

class FriendStateAddFriend extends FriendState {
  final int? senderId;
  final int chatId;

  FriendStateAddFriend({
    this.senderId,
    required this.chatId,
  });
}

class FriendStateAddFriendLoading extends FriendStateAddFriend {
  FriendStateAddFriendLoading({required int chatId}) : super(chatId: chatId);
}

class FriendStateAddFriendSuccess extends FriendStateAddFriend {
  final IUserInfo userInfo;

  FriendStateAddFriendSuccess(this.userInfo) : super(chatId: userInfo.id);
}

class FriendStateAddFriendError extends FriendStateAddFriend {
  final int chatId;
  final ExceptionError error;

  FriendStateAddFriendError(this.chatId, this.error) : super(chatId: chatId);
}

// Response friend =============================================================

class FriendStateResponseAddFriend extends FriendState {
  final int requestId;
  final FriendStatus? status;

  FriendStateResponseAddFriend(this.requestId, [this.status]);
}

class FriendStateResponseAddFriendLoading extends FriendStateResponseAddFriend {
  FriendStateResponseAddFriendLoading(int requestId) : super(requestId);
}

class FriendStateResponseAddFriendError extends FriendStateResponseAddFriend {
  final ExceptionError error;

  FriendStateResponseAddFriendError(this.error, int requestId)
      : super(requestId);
}

class FriendStateResponseAddFriendSuccess extends FriendStateResponseAddFriend {
  final FriendStatus status;
  final int requestId;
  final IUserInfo? requestInfo;

  FriendStateResponseAddFriendSuccess(
    this.requestId,
    this.status, {
    this.requestInfo,
  }) : super(requestId, status);
}

// Delete friend ===============================================================

class FriendStateDeleteContact extends FriendState {
  final int userId;
  final int chatId;

  FriendStateDeleteContact(this.userId, this.chatId);
}
