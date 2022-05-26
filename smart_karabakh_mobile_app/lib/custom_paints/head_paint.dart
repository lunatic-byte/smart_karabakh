import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../constants/const_colors.dart';

class HeaderPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint_0.shader = ui.Gradient.linear(
        Offset(0, size.height * 0.13),
        Offset(size.width * 0.58, size.height * 0.13),
        [Colors.pink.withOpacity(0.15), Colors.blue.withOpacity(0.7)],
        [0.00, 1.00]);

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.27);
    path_0.quadraticBezierTo(size.width * 0.11, size.height * 0.26,
        size.width * 0.14, size.height * 0.18);
    path_0.cubicTo(size.width * 0.18, size.height * 0.10, size.width * 0.28,
        size.height * 0.09, size.width * 0.35, size.height * 0.09);
    path_0.quadraticBezierTo(
        size.width * 0.51, size.height * 0.09, size.width * 0.58, 0);
    path_0.lineTo(0, 0);
    path_0.lineTo(0, size.height * 0.27);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
