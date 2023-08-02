import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class CustomRefreshIndicator extends StatelessWidget {
  const CustomRefreshIndicator({
    Key? key,
    required this.onRefresh,
    required this.child,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.displacement = 40,
    this.edgeOffset = 0,
  }) : super(key: key);

  final RefreshCallback onRefresh;
  final Widget child;
  final ScrollNotificationPredicate notificationPredicate;
  final double edgeOffset;

  /// The distance from the child's top or bottom [edgeOffset] where
  /// the refresh indicator will settle. During the drag that exposes the refresh
  /// indicator, its actual displacement may significantly exceed this value.
  ///
  /// In most cases, [displacement] distance starts counting from the parent's
  /// edges. However, if [edgeOffset] is larger than zero then the [displacement]
  /// value is calculated from that offset instead of the parent's edge.
  final double displacement;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      backgroundColor: Theme.of(context).backgroundColor,
      notificationPredicate: notificationPredicate,
      displacement: displacement,
      edgeOffset: edgeOffset,
      child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: child),
    );
  }
}
