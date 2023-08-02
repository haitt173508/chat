class SocketTypingModel {
  final int conversationId;
  final int userId;

  SocketTypingModel({
    required this.conversationId,
    required this.userId,
  });

  factory SocketTypingModel.fromMap(List<dynamic> map) => SocketTypingModel(
        conversationId: map[0],
        userId: map[1],
      );
}
