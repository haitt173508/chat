import 'package:flutter/painting.dart';

extension ImageProviderExt on ImageProvider? {
  bool canResolve() {
    try {
      if (this == null) return false;
      this!
          .resolve(ImageConfiguration())
          .completer!
          .reportError(exception: throw Exception());
    } catch (e) {
      return false;
    }
  }
}
