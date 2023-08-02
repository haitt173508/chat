import 'package:chat_365/modules/chat_conversations/models/result_chat_conversation.dart';
import 'package:chat_365/modules/new_conversation/models/list_login_history_model.dart';
import 'package:equatable/equatable.dart';

abstract class CreateConversationState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreateConversationInitial extends CreateConversationState {}

class ConversationCreationInProgress extends CreateConversationState {}

class ConversationCreationSuccess extends CreateConversationState {
  final ChatItemModel model;

  ConversationCreationSuccess(this.model);

  @override
  List<Object> get props => [];
}

class ConversationCreationFailure extends CreateConversationState {
  final String message;

  ConversationCreationFailure(this.message);

  @override
  List<Object> get props => [message];
}

class LoginHistoryLoad extends CreateConversationState {}

class LoginHistoryLoading extends CreateConversationState {}

// class LoginHistoryState extends CreateConversationState {}
