enum FilterConversationsBy { recent, hidden }

extension FilterConversationsByExt on FilterConversationsBy {
  String get displayName {
    switch (this) {
      case FilterConversationsBy.recent:
        return 'Cuộc trò chuyện gần đây';
      case FilterConversationsBy.hidden:
        return 'Cuộc trò chuyện bị ẩn';
    }
  }
}
