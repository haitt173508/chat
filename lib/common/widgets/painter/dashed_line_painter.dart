import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class DashedLinePainter extends CustomPainter {
  const DashedLinePainter(
    this.strokeWidth, [
    this.color = AppColors.divider,
  ]);

  static CustomPaint get customPaint => const CustomPaint(
        painter: DashedLinePainter(1),
      );

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3, dashSpace = 3, startX = 0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth;
    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
