import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  const GradientButton({
    Key? key,
    required this.onPressed,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 16,
      vertical: 7,
    ),
    this.gradientColor,
    this.border,
    this.child,
    this.shadows,
    this.color,
    this.width,
  }) : super(key: key);

  final VoidCallback onPressed;
  final EdgeInsets? padding;
  final Gradient? gradientColor;
  final BoxBorder? border;
  final Widget? child;
  final List<BoxShadow>? shadows;
  final Color? color;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(100),
      child: Container(
        padding: padding,
        width: width,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          gradient: gradientColor,
          border: border,
          boxShadow: shadows,
          color: color,
        ),
        child: child,
      ),
    );
  }
}
