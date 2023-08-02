import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    Key? key,
    required this.child,
    this.decoration,
    this.onTap,
    this.height = 40,
    this.width = 190,
  }) : super(key: key);
  final Widget child;
  final BoxDecoration? decoration;
  final VoidCallback? onTap;
  final double height;
  final double width;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Ink(
        height: widget.height,
        width: widget.width,
        child: Center(
          child: widget.child,
        ),
        decoration: widget.decoration,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      ),
      borderRadius: widget.decoration?.borderRadius as BorderRadius?,
    );
  }
}
