enum ConversationCreationKind { normal, private }

extension GroupConversationCreationKindExt on ConversationCreationKind {
  String get serverName {
    switch (this) {
      case ConversationCreationKind.normal:
        return 'Nomarl';
      case ConversationCreationKind.private:
        return 'Morderate';
    }
  }
}
