import 'package:chat_365/core/error_handling/exceptions.dart';

enum ChatFileType { image, file }

extension ChatFileTypeExt on ChatFileType {
  String get name {
    switch (this) {
      case ChatFileType.image:
        return 'sendPhoto';
      case ChatFileType.file:
        return 'sendFile';
    }
  }

  bool get isFile => this == ChatFileType.image || this == ChatFileType.file;

  bool get isImage => this == ChatFileType.image;

  static ChatFileType valueOf(String name) {
    try {
      return ChatFileType.values.firstWhere((e) => e.name == name);
    } catch (e) {
      throw DataNotFoundException(
          "ChatFileType.name == $name", 'ChatFileType.valueOf');
    }
  }
}
