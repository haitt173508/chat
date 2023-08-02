import 'dart:async';

import 'package:flutter/cupertino.dart';

class TextEditingControllerDebouncer {
  String? _lastSearch;
  final Function callBack;
  final Duration duration;
  final TextEditingController controller;
  Timer? _throttle;

  TextEditingControllerDebouncer(
    this.callBack, {
    this.duration = const Duration(milliseconds: 200),
    required this.controller,
  }) {
    _lastSearch = controller.text;
    controller.addListener(_listener);
  }

  _listener() {
    if (_throttle?.isActive ?? true) _throttle?.cancel();
    _throttle = Timer(duration, () {
      if (_lastSearch != controller.text) {
        _lastSearch = controller.text;
        callBack.call();
      }
    });
  }

  dispose() {
    controller.dispose();
  }
}
