import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double sh = size.height; // for convenient shortage
    double sw = size.width; // for convenient shortage
    double cornerSide = sh * 0.1; // desirable value for corners side
    double l = 60;
    Paint paint = Paint()
      ..color = AppColors.tundora
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double w = size.width, h = size.height;

    Path path = Path()
      ..moveTo(0, l)
      ..lineTo(0, 0)
      ..lineTo(l, 0)
      ..moveTo(w - l, 0)
      ..lineTo(w, 0)
      ..lineTo(w, l)
      ..moveTo(w, h - l)
      ..lineTo(w, h)
      ..lineTo(w - l, h)
      ..moveTo(l, h)
      ..lineTo(0, h)
      ..lineTo(0, h - l);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(BorderPainter oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(BorderPainter oldDelegate) => false;
}
