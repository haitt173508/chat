part of 'chat_library_cubit.dart';

abstract class ChatLibraryState {
  const ChatLibraryState();
}

class ChatLibraryStateLoadSuccess extends ChatLibraryState {
  final MessageType? messageType;

  ChatLibraryStateLoadSuccess({this.messageType});
}

class ChatLibraryLoadConversationDetailError extends ChatLibraryState {
  final ExceptionError error;

  ChatLibraryLoadConversationDetailError(this.error);
}

class ChatLibraryStateLoading extends ChatLibraryState {}

class ChatLibraryStateError extends ChatLibraryState {
  final ExceptionError error;

  ChatLibraryStateError(this.error);
}
