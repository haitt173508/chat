class SocketDeletedMessageModel {
  final int conversationId;
  final String messageId;

  SocketDeletedMessageModel({
    required this.conversationId,
    required this.messageId,
  });

  factory SocketDeletedMessageModel.fromMap(List<dynamic> map) =>
      SocketDeletedMessageModel(
        conversationId: map[0],
        messageId: map[1],
      );
}
