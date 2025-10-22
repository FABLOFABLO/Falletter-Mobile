import 'dart:math';

import 'package:flutter/material.dart';

class CircleProgress extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Gradient gradient;

  CircleProgress({
    required this.progress,
    required this.strokeWidth,
    required this.gradient,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final rect = Rect.fromCircle(center: center, radius: radius);

    final paint = Paint();
    paint.shader = gradient.createShader(rect);
    paint.strokeWidth = strokeWidth;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = -2 * pi * progress;

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) =>
      oldDelegate is CircleProgress && oldDelegate.progress != progress;
}
