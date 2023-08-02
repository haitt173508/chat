enum FilterConversationBy {
  nearest,
  favorite,
}

extension FilterConversationByExt on FilterConversationBy {
  String get name {
    switch (this) {
      case FilterConversationBy.nearest:
        return 'Cuộc trò chuyện gần đây';
      case FilterConversationBy.favorite:
        return 'Cuộc trò chuyện yêu thích';
      default:
        return '';
    }
  }

  int get index => FilterConversationBy.values.indexOf(this);
}
