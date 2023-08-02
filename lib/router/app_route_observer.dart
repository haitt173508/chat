import 'dart:developer' show log;

import 'package:chat_365/utils/data/extensions/string_extension.dart';
import 'package:flutter/material.dart';

class AppRouteObserver extends RouteObserver<PageRoute<dynamic>> {
  _log(String msg) {
    log(msg, name: 'Navigator');
  }

  Route? _currentPageRoute;

  List<Route> _history = [];
  List<OverlayEntry?> overlayEntries = [];

  set currentPageRoute(Route? value) {
    if (value is PageRoute) {
      _currentPageRoute = value;
      _history.add(value);
    }
  }

  Route? get currentPageRoute => _currentPageRoute;

  bool isContainPageName(String pageName) => currentPageRoute != null
      ? ModalRoute.withName(pageName).call(routeObserver.currentPageRoute!)
      : false;

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    currentPageRoute = previousRoute;
    _history.remove(route);
    if (route is DialogRoute)
      _log("CLOSE DIALOG: ${route.settings.name}");
    else if (route.runtimeType.toString().contains('_ModalBottomSheetRoute'))
      _log(
          "CLOSE MODEL BOTTOM SHEET: ${route.settings.name}${_resolveArguments(route.settings)}");
    else if (route.settings.name != null)
      _log(
          "POP ROUTE: ${route.settings.name}${_resolveArguments(route.settings)}");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    currentPageRoute = route;
    super.didPush(route, previousRoute);
    if (route is DialogRoute && !route.settings.name.isBlank)
      _log("""
SHOW DIALOG: ${route.settings.name}
     message: ${_resolveArguments(route.settings)}
""");
    else if (route.runtimeType.toString().contains('_ModalBottomSheetRoute'))
      _log(
          "SHOW MODEL BOTTOM SHEET: ${route.settings.name}${_resolveArguments(route.settings)}");
    else if (route.settings.name != null)
      _log(
          "PUSH ROUTE: ${route.settings.name}${_resolveArguments(route.settings)}");
  }

  String _resolveArguments(RouteSettings settings) {
    Object? args = settings.arguments;

    if (args == null) return '';

    if (args is Map)
      return "?${args.entries.map((e) => "${e.key.toString()}=${e.value.toString()}").join('&')}";

    return "?${args.toString()}";
  }
}

AppRouteObserver routeObserver = AppRouteObserver();
