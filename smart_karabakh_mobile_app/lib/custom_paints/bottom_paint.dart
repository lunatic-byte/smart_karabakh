import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class BottomPaint extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_1 = new Paint()
      ..color = Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint_1.shader = ui.Gradient.linear(
        Offset(size.width * 0.53, size.height * 0.91),
        Offset(size.width, size.height * 0.91),
        [Colors.pink.withOpacity(0.15), Colors.blue.withOpacity(0.7)],
        [0.00, 1.00]);

    Path path_1 = Path();
    path_1.moveTo(size.width, size.height * 0.81);
    path_1.lineTo(size.width, size.height * 1);
    path_1.lineTo(size.width * 0.52, size.height * 1.00);
    path_1.quadraticBezierTo(size.width * 0.56, size.height * 0.95,
        size.width * 0.67, size.height * 0.95);
    path_1.cubicTo(size.width * 0.75, size.height * 0.95, size.width * 0.81,
        size.height * 0.94, size.width * 0.86, size.height * 0.88);
    path_1.quadraticBezierTo(
        size.width * 0.90, size.height * 0.83, size.width, size.height * 0.81);
    path_1.close();

    canvas.drawPath(path_1, paint_1);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
