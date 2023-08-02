part of 'reaction_cubit.dart';

class ReactionState extends Equatable {
  ReactionState({
    Map<Emoji, Emotion> reactions = const {},
    this.lastEmoji,
  }) : _reactions = Map<Emoji, Emotion>.fromEntries(reactions.entries);

  final Map<Emoji, Emotion> _reactions;
  final Emoji? lastEmoji;

  Map<Emoji, Emotion> get reactions => _reactions;

  @override
  List<Object> get props => [DateTime.now()];
}

class ReactionStateChangeReactionError extends ReactionState {
  final ExceptionError error;

  ReactionStateChangeReactionError(this.error);

  @override
  List<Object> get props => [DateTime.now()];
}
