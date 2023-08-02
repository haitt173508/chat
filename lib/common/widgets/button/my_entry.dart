import 'package:flutter/material.dart';

class MyEntry<T> extends StatefulWidget implements PopupMenuEntry<T> {
  const MyEntry({
    Key? key,
    required this.child,
    this.onTap,
    this.value,
    this.decoration,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final T? value;
  final BoxDecoration? decoration;

  @override
  State<MyEntry<T>> createState() => _MyEntryState<T>();

  @override
  double get height => 36;

  @override
  bool represents(value) => value != null;
}

class _MyEntryState<T> extends State<MyEntry<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Ink(
        child: Center(child: widget.child),
        decoration: widget.decoration,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        height: widget.height,
      ),
      borderRadius: widget.decoration?.borderRadius as BorderRadius?,
      onTap: () {
        Navigator.of(context).pop(widget.value);
        widget.onTap?.call();
      },
    );
  }
}
