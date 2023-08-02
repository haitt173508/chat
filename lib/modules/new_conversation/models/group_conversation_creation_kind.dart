enum GroupConversationCreationKind { public, needModeration }

extension GroupConversationCreationKindExt on GroupConversationCreationKind {
  String get serverName {
    switch (this) {
      case GroupConversationCreationKind.public:
        return 'Nomarl';
      case GroupConversationCreationKind.needModeration:
        return 'Morderate';
    }
  }
}
