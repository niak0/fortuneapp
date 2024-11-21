import 'dart:math';

import 'package:flutter/material.dart';

class CirclePainter extends CustomPainter {
  final double percentage;
  final Color progressColor;

  CirclePainter(this.percentage, this.progressColor);

  @override
  void paint(Canvas canvas, Size size) {
    double strokeWidth = 10;
    Paint baseCircle = Paint()
      ..color = Colors.grey[800]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    Paint progressCircle = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    double radius = (size.width / 2) - strokeWidth / 2;
    Offset center = Offset(size.width / 2, size.height / 2);

    // Draw base circle (gray background)
    canvas.drawCircle(center, radius, baseCircle);

    // Draw progress arc
    double arcAngle = 2 * pi * percentage;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2, arcAngle, false, progressCircle);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}