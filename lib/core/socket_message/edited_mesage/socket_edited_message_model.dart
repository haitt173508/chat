class SocketEditedMessageModel {
  final int conversationId;

  /// message id
  final String id;
  final String message;

  SocketEditedMessageModel({
    required this.conversationId,
    required this.id,
    required this.message,
  });

  factory SocketEditedMessageModel.fromMap(List<dynamic> map) =>
      SocketEditedMessageModel(
        conversationId: map[0],
        id: map[1],
        message: map[2],
      );
}
