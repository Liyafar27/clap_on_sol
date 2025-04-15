import 'dart:math';

import 'package:flutter/material.dart';

class ArcWordPainter extends CustomPainter {
  final String text;
  final TextStyle textStyle;
  final double radius;
  final double startAngle;
  final double sweepAngle;

  ArcWordPainter({
    required this.text,
    required this.textStyle,
    required this.radius,
    required this.startAngle,
    required this.sweepAngle,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final characters = text.split('');
    final anglePerChar = sweepAngle / (characters.length - 1);
    double angle = startAngle;

    for (final char in characters) {
      final tp = TextPainter(
        text: TextSpan(text: char, style: textStyle),
        textDirection: TextDirection.ltr,
      )..layout();

      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle + pi / 2); // ← это правильный касательный угол
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();

      angle += anglePerChar;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
