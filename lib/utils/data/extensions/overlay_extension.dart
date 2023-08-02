import 'package:chat_365/router/app_route_observer.dart';
import 'package:flutter/cupertino.dart';

extension OverlayExt on OverlayState {
  insertWithObserve(OverlayEntry overlayEntry) {
    insert(overlayEntry);
    routeObserver.overlayEntries.insert(0, overlayEntry);
  }

  clearObserveOverlay() {
    for (var overlay in routeObserver.overlayEntries) {
      try {
        overlay?.remove();
      } catch (e) {}
    }
  }
}

extension OverlayEntryExt on OverlayEntry {
  removeIfExistInObserveOverlay() {
    routeObserver.overlayEntries.remove(this);
    try {
      this.remove();
    } catch (e) {}
  }
}
