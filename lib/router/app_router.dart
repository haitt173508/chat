import 'package:chat_365/router/page_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: implementation_imports
import 'package:flutter_bloc/src/bloc_provider.dart'
    show BlocProviderSingleChildWidget;

import 'app_pages.dart';

enum Transition {
  fadeIn,
  rightToLeft,
  downToUp,
  rightToLeftWithFade,
}

extension _TransitionExtension on Transition {
  Offset? get beginOffset {
    switch (this) {
      case Transition.rightToLeft:
      case Transition.rightToLeftWithFade:
        return const Offset(1.0, 0.0);
      case Transition.downToUp:
        return const Offset(0.0, 1.0);
      default:
        return null;
    }
  }

  Offset? get endOffset {
    if (this == Transition.rightToLeftWithFade) return const Offset(-1.0, 0.0);
    return null;
  }

  static Widget builder(
      BuildContext context,
      Animation<double> animation,
      Animation<double> secondaryAnimation,
      Transition transition,
      Curve? curve,
      Widget child) {
    const zeroOffset = Offset.zero;

    if (transition == Transition.fadeIn)
      return FadeTransition(opacity: animation, child: child);

    if (transition == Transition.rightToLeftWithFade)
      return SlideTransition(
        position: Tween<Offset>(
          begin: transition.beginOffset,
          end: zeroOffset,
        ).animate(animation),
        child: FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: zeroOffset,
              end: transition.endOffset,
            ).animate(secondaryAnimation),
            child: child,
          ),
        ),
      );

    final tween = Tween(begin: transition.beginOffset, end: zeroOffset);
    final curvedAnimation = CurvedAnimation(
      parent: animation,
      curve: curve ?? _defaultTransitionCurve,
    );

    return SlideTransition(
      position: tween.animate(curvedAnimation),
      child: child,
    );
  }
}

const Transition _defaultTransition = Transition.rightToLeft;
const Curve _defaultTransitionCurve = Curves.easeOutQuad;
const Duration _defaultTransitionDuration = Duration(milliseconds: 320);

class AppRouter {
  static String _initialPageName = AppPages.Initial.name;

  static _duplicatedPage(String name) => "Duplicated Page: $name";

  static PageRouteBuilder<T> _createRoute<T>({
    required PageBuilder pageBuilder,
    required RouteSettings settings,
    Transition? transition,
    Duration? transitionDuration,
    Curve? curve,
    bool opaque = true,
    bool fullscreenDialog = false,
  }) =>
      PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => pageBuilder(),
        settings: settings,
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            _TransitionExtension.builder(context, animation, secondaryAnimation,
                transition ?? _defaultTransition, curve, child),
        transitionDuration: transitionDuration ?? _defaultTransitionDuration,
        opaque: opaque,
        fullscreenDialog: fullscreenDialog,
      );

  /// [opaque]
  ///
  /// Whether the route obscures previous routes when the transition is complete.
  ///
  /// When an opaque route's entrance transition is complete, the routes behind
  /// the opaque route will not be built to save resources.
  static Future<T?> toPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    AppPages page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    bool preventDuplicates = true,
    Transition? transition,
    Curve? curve,
    Duration? duration,
    bool? opaque,
    bool? fullscreenDialog,
  }) {
    NavigatorState navState = Navigator.of(context);

    if (preventDuplicates &&
        navState.widget.pages.length != 0 &&
        navState.widget.pages.last.name == page.name)
      throw StateError(_duplicatedPage(page.name));

    PageConfig pageConfig = AppPagesExtension.getPageConfig(page, arguments);

    late PageBuilder pageBuilder;

    if (blocValue != null)
      pageBuilder = () => BlocProvider.value(
            value: blocValue,
            child: (() => pageConfig.pageBuilder())(),
          );
    else if (blocProviders != null)
      pageBuilder = () => MultiBlocProvider(
            providers: blocProviders,
            child: (() => pageConfig.pageBuilder())(),
          );
    else
      pageBuilder = pageConfig.pageBuilder;

    return navState.push<T>(
      _createRoute(
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: page.name, arguments: arguments),
        transition: transition ?? pageConfig.transition,
        transitionDuration: duration ?? pageConfig.transitionDuration,
        curve: curve ?? pageConfig.curve,
        opaque: opaque ?? pageConfig.opaque,
        fullscreenDialog: fullscreenDialog ?? pageConfig.fullscreenDialog,
      ),
    );
  }

  static Future<T?>?
      replaceWithPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    AppPages page, {
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    Transition? transition,
    Curve? curve,
    Duration? duration,
  }) {
    PageConfig pageConfig = AppPagesExtension.getPageConfig(page, arguments);

    late PageBuilder pageBuilder;

    if (blocValue != null)
      pageBuilder = () => BlocProvider.value(
            value: blocValue,
            child: (() => pageConfig.pageBuilder())(),
          );
    else if (blocProviders != null)
      pageBuilder = () => MultiBlocProvider(
            providers: blocProviders,
            child: (() => pageConfig.pageBuilder())(),
          );
    else
      pageBuilder = pageConfig.pageBuilder;

    return Navigator.of(context).pushReplacement(
      _createRoute(
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: page.name, arguments: arguments),
        transition: transition ?? pageConfig.transition,
        transitionDuration: duration ?? pageConfig.transitionDuration,
        curve: curve ?? pageConfig.curve,
        opaque: pageConfig.opaque,
        fullscreenDialog: pageConfig.fullscreenDialog,
      ),
    );
  }

  static Future<T?>?
      replaceAllWithPage<T extends Object?, B extends BlocBase<Object?>>(
    BuildContext context,
    AppPages page, {
    bool Function(Route<dynamic>)? predicate,
    Map<String, dynamic>? arguments,
    B? blocValue,
    List<BlocProviderSingleChildWidget>? blocProviders,
    Transition? transition,
    Curve? curve,
    Duration? duration,
  }) {
    PageConfig pageConfig = AppPagesExtension.getPageConfig(page, arguments);

    late PageBuilder pageBuilder;

    if (blocValue != null)
      pageBuilder = () => BlocProvider.value(
            value: blocValue,
            child: (() => pageConfig.pageBuilder())(),
          );
    else if (blocProviders != null)
      pageBuilder = () => MultiBlocProvider(
            providers: blocProviders,
            child: (() => pageConfig.pageBuilder())(),
          );
    else
      pageBuilder = pageConfig.pageBuilder;

    return Navigator.of(context).pushAndRemoveUntil(
      _createRoute(
        pageBuilder: pageBuilder,
        settings: RouteSettings(name: page.name, arguments: arguments),
        transition: transition ?? pageConfig.transition,
        transitionDuration: duration ?? pageConfig.transitionDuration,
        curve: curve ?? pageConfig.curve,
        opaque: pageConfig.opaque,
        fullscreenDialog: pageConfig.fullscreenDialog,
      ),
      predicate ?? (Route<dynamic> _) => false,
    );
  }

  static back<T>(
    BuildContext context, {
    T? result,
  }) =>
      Navigator.pop(context, result);

  static backToPageName(BuildContext context, String name) =>
      Navigator.of(context).popUntil((route) {
        if (route is DialogRoute) return false;

        String? routeName;

        if (route is MaterialPageRoute || route is PageRouteBuilder)
          routeName = route.settings.name;

        return routeName == name || routeName == _initialPageName;
      });

  static backToPage(BuildContext context, AppPages page) =>
      backToPageName(context, page.name);

  static backUntil(
    BuildContext context,
    bool Function(Route<dynamic>) predicate,
  ) =>
      Navigator.of(context).popUntil(predicate);

  static removeAllDialog(
    BuildContext context, {
    bool Function(Route<dynamic>)? predicate,
  }) =>
      Navigator.of(context).popUntil(
        (route) =>
            predicate?.call(route) == true || (route is DialogRoute) != true,
      );
}
