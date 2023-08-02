import 'dart:async';

import 'package:chat_365/core/error_handling/exceptions.dart';
import 'package:chat_365/modules/chat/blocs/chat_bloc/chat_bloc.dart';
import 'package:chat_365/modules/chat/model/result_socket_chat.dart';
import 'package:chat_365/modules/chat/repo/chat_repo.dart';
import 'package:chat_365/utils/data/enums/emoji.dart';
import 'package:chat_365/utils/data/enums/message_type.dart';
import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:chat_365/utils/data/models/exception_error.dart';
import 'package:chat_365/utils/helpers/logger.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'reaction_state.dart';

class ReactionCubit extends Cubit<ReactionState> {
  ReactionCubit(
    this.messageId, {
    required ChatRepo chatRepo,
    required Map<Emoji, Emotion> initEmotions,
  })  : _chatRepo = chatRepo,
        super(ReactionState(reactions: initEmotions)) {
    _subscription = _chatRepo.stream.listen((event) {
      if (event is ChatEventOnRecievedEmotionMessage &&
          event.messageId == messageId) {
        logger.log(
          '${event}',
          name: 'ReactionCubit_${this.hashCode}',
          color: StrColor.magenta,
        );
        // _logRection(state.reactions);
        var reactions = state.reactions;
        if (event.checked) {
          /// Hủy reaction
          reactions[event.emoji]?.listUserId.remove(event.senderId);
        } else {
          reactions[event.emoji] ??= Emotion(
            type: event.emoji,
            listUserId: [],
            isChecked: false,
          );
          reactions[event.emoji]?.listUserId.add(event.senderId);
        }
        // _logRection(reactions);

        emit(
          ReactionState(
            reactions: reactions,
            lastEmoji: !event.checked ? event.emoji : null,
          ),
        );
      }
    });
  }

  _logRection(Map<Emoji, Emotion> react) => logger.log(
      Map.from(react.map((e, v) => MapEntry(e.id, v.listUserId.length))),
      name: 'CheckReaction');

  changeReaction(ChatEventEmitChangeReationMessage event) {
    try {
      _chatRepo.changeReaction(event);
    } on CustomException catch (e) {
      emit(ReactionStateChangeReactionError(e.error));
    }
  }

  like(
    int userId,
    SocketSentMessageModel message,
    List<int> members,
  ) {
    changeReaction(ChatEventEmitChangeReationMessage(
      userId,
      message.messageId,
      message.conversationId,
      Emoji.like,
      false,
      message.type ?? MessageType.text,
      message.message ?? '',
      members,
      [],
    ));
  }

  final String messageId;

  final ChatRepo _chatRepo;
  late final StreamSubscription _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  @override
  void onChange(Change<ReactionState> change) {
    logger.log('---CheckReaction---');
    _logRection(change.currentState.reactions);
    _logRection(change.nextState.reactions);
    super.onChange(change);
  }
}
