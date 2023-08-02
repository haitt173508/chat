import 'dart:math';

import 'package:chat_365/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AnimationRipple extends CustomPainter {
  final double animationValue;

  AnimationRipple(this.animationValue);

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // throw UnimplementedError();
    return true;
  }

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 3; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height),
          value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()
      ..color = AppColors.white.withOpacity((1 - (value / 4).clamp(.0, 1)));
    canvas.drawCircle(rect.center,
        sqrt(rect.width * .5 * rect.width * .5) * value / 4, paint);
  }
}
