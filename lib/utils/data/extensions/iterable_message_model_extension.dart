import 'package:chat_365/modules/chat/model/api_message_model.dart';

extension IterableApiMessageModelExtension on Iterable<ApiMessageModel> {
  // void iterableRemoveMessage(ApiMessageModel message) =>
  //     this.toList()..removeWhere((e) => e.messageId == messageId);

  bool containMessageId(String messageId) =>
      this.toList().indexWhere((e) => e.messageId == messageId) != -1;
}

extension ListMessageModelExtension on List<ApiMessageModel> {
  removeMessage(ApiMessageModel messageId) => remove(messageId);
}

extension SetMessageModelExtension on Set<ApiMessageModel> {
  removeMessage(ApiMessageModel messageId) => remove(messageId);
}

extension MapMessageModelExtension<V> on Map<ApiMessageModel, V> {
  removeMessage(ApiMessageModel message) => remove(message);

  V? containMessageId(String messageId) {
    try {
      return this[keys.firstWhere((e) => e.messageId == messageId)];
    } catch (_) {
      return null;
    }
  }
}
