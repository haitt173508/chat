// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';

import 'dart:ui' as ui;

class WarningIconPainter extends CustomPainter {
  const WarningIconPainter();

  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.4960935, size.height * 0.6269529);
    path_0.cubicTo(
        size.width * 0.5175784,
        size.height * 0.6269529,
        size.width * 0.5351562,
        size.height * 0.6093752,
        size.width * 0.5351562,
        size.height * 0.5878908);
    path_0.lineTo(size.width * 0.5351562, size.height * 0.3144529);
    path_0.cubicTo(
        size.width * 0.5351562,
        size.height * 0.2929686,
        size.width * 0.5175784,
        size.height * 0.2753908,
        size.width * 0.4960935,
        size.height * 0.2753908);
    path_0.cubicTo(
        size.width * 0.4746092,
        size.height * 0.2753908,
        size.width * 0.4570314,
        size.height * 0.2929686,
        size.width * 0.4570314,
        size.height * 0.3144529);
    path_0.lineTo(size.width * 0.4570314, size.height * 0.5878908);
    path_0.cubicTo(
        size.width * 0.4570314,
        size.height * 0.6093752,
        size.width * 0.4746092,
        size.height * 0.6269529,
        size.width * 0.4960935,
        size.height * 0.6269529);
    path_0.close();

    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.04101562, size.height * 0.4511719),
        Offset(size.width * 0.9696536, size.height * 0.4511719), [
      Color(0xffFF884B).withOpacity(1),
      Color(0xffFF634C).withOpacity(1),
      Color(0xffFE4A4F).withOpacity(1),
      Color(0xffFE4840).withOpacity(1)
    ], [
      0,
      0.35,
      0.655,
      1
    ]);
    canvas.drawPath(path_0, paint_0_fill);

    Path path_1 = Path();
    path_1.moveTo(size.width * 0.4960961, size.height * 0.8208954);
    path_1.cubicTo(
        size.width * 0.5272699,
        size.height * 0.8208954,
        size.width * 0.5525418,
        size.height * 0.7956275,
        size.width * 0.5525418,
        size.height * 0.7644510);
    path_1.cubicTo(
        size.width * 0.5525418,
        size.height * 0.7332810,
        size.width * 0.5272699,
        size.height * 0.7080065,
        size.width * 0.4960961,
        size.height * 0.7080065);
    path_1.cubicTo(
        size.width * 0.4649222,
        size.height * 0.7080065,
        size.width * 0.4396510,
        size.height * 0.7332810,
        size.width * 0.4396510,
        size.height * 0.7644510);
    path_1.cubicTo(
        size.width * 0.4396510,
        size.height * 0.7956275,
        size.width * 0.4649222,
        size.height * 0.8208954,
        size.width * 0.4960961,
        size.height * 0.8208954);
    path_1.close();

    Paint paint_1_fill = Paint()..style = PaintingStyle.fill;
    paint_1_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.04101843, size.height * 0.7644510),
        Offset(size.width * 0.9696601, size.height * 0.7644510), [
      Color(0xffFF884B).withOpacity(1),
      Color(0xffFF634C).withOpacity(1),
      Color(0xffFE4A4F).withOpacity(1),
      Color(0xffFE4840).withOpacity(1)
    ], [
      0,
      0.35,
      0.655,
      1
    ]);
    canvas.drawPath(path_1, paint_1_fill);

    Path path_2 = Path();
    path_2.moveTo(size.width * 0.9882810, size.height * 0.8246078);
    path_2.lineTo(size.width * 0.5869131, size.height * 0.06933660);
    path_2.cubicTo(
        size.width * 0.5673817,
        size.height * 0.03242255,
        size.width * 0.5322255,
        size.height * 0.01054752,
        size.width * 0.4927725,
        size.height * 0.01054752);
    path_2.lineTo(size.width * 0.4917961, size.height * 0.01054752);
    path_2.cubicTo(
        size.width * 0.4521477,
        size.height * 0.01093817,
        size.width * 0.4169908,
        size.height * 0.03339908,
        size.width * 0.3978503,
        size.height * 0.07089935);
    path_2.lineTo(size.width * 0.01425680, size.height * 0.8253922);
    path_2.cubicTo(
        size.width * -0.005079170,
        size.height * 0.8634771,
        size.width * -0.003321353,
        size.height * 0.9097647,
        size.width * 0.01894425,
        size.height * 0.9460915);
    path_2.cubicTo(
        size.width * 0.03906144,
        size.height * 0.9789085,
        size.width * 0.07285033,
        size.height * 0.9988301,
        size.width * 0.1093739,
        size.height * 0.9988301);
    path_2.lineTo(size.width * 0.8945294, size.height);
    path_2.lineTo(size.width * 0.8947255, size.height);
    path_2.cubicTo(
        size.width * 0.9316405,
        size.height,
        size.width * 0.9654314,
        size.height * 0.9798824,
        size.width * 0.9853529,
        size.height * 0.9466797);
    path_2.cubicTo(
        size.width * 1.007418,
        size.height * 0.9097647,
        size.width * 1.008595,
        size.height * 0.8628889,
        size.width * 0.9882810,
        size.height * 0.8246078);
    path_2.close();
    path_2.moveTo(size.width * 0.9183595, size.height * 0.9064444);
    path_2.cubicTo(
        size.width * 0.9150392,
        size.height * 0.9121111,
        size.width * 0.9074183,
        size.height * 0.9218758,
        size.width * 0.8947255,
        size.height * 0.9218758);
    path_2.lineTo(size.width * 0.1095693, size.height * 0.9207059);
    path_2.cubicTo(
        size.width * 0.09687386,
        size.height * 0.9207059,
        size.width * 0.08925686,
        size.height * 0.9111307,
        size.width * 0.08574118,
        size.height * 0.9054706);
    path_2.cubicTo(
        size.width * 0.07929608,
        size.height * 0.8949216,
        size.width * 0.07558497,
        size.height * 0.8777320,
        size.width * 0.08398301,
        size.height * 0.8609412);
    path_2.lineTo(size.width * 0.4677725, size.height * 0.1060556);
    path_2.cubicTo(
        size.width * 0.4734366,
        size.height * 0.09492222,
        size.width * 0.4826163,
        size.height * 0.08789150,
        size.width * 0.4927725,
        size.height * 0.08789150);
    path_2.lineTo(size.width * 0.4929680, size.height * 0.08789150);
    path_2.cubicTo(
        size.width * 0.5031242,
        size.height * 0.08789150,
        size.width * 0.5123039,
        size.height * 0.09453203,
        size.width * 0.5181627,
        size.height * 0.1056647);
    path_2.lineTo(size.width * 0.9193333, size.height * 0.8613268);
    path_2.cubicTo(
        size.width * 0.9283203,
        size.height * 0.8781242,
        size.width * 0.9246078,
        size.height * 0.8959020,
        size.width * 0.9183595,
        size.height * 0.9064444);
    path_2.close();

    Paint paint_2_fill = Paint()..style = PaintingStyle.fill;
    paint_2_fill.shader = ui.Gradient.linear(
        Offset(size.width * 0.04101458, size.height * 0.5052739),
        Offset(size.width * 0.9696536, size.height * 0.5052739), [
      Color(0xffFF884B).withOpacity(1),
      Color(0xffFF634C).withOpacity(1),
      Color(0xffFE4A4F).withOpacity(1),
      Color(0xffFE4840).withOpacity(1)
    ], [
      0,
      0.35,
      0.655,
      1
    ]);
    canvas.drawPath(path_2, paint_2_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
