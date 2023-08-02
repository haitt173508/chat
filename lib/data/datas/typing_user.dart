class TypingUser {
  const TypingUser();

  final Set<int> typingUsers = const {};

  bool isTyping(int userId) => typingUsers.contains(userId);
}
