import 'package:flutter/material.dart';

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final centerX = size.width / 2;
    final startY = 60.0;

    // Starting point (Level 1)
    path.moveTo(centerX, startY);

    // Path to Level 2 (left)
    path.quadraticBezierTo(
      centerX - 50,
      startY + 50,
      size.width * 0.2 + 40,
      startY + 90,
    );

    // Path to Level 3 (right)
    path.quadraticBezierTo(
      size.width * 0.2,
      startY + 130,
      size.width * 0.8 - 40,
      startY + 180,
    );

    // Path to Level 4 (left)
    path.quadraticBezierTo(
      size.width * 0.8,
      startY + 220,
      size.width * 0.2 + 40,
      startY + 270,
    );

    // Path to Level 5 (right)
    path.quadraticBezierTo(
      size.width * 0.2,
      startY + 310,
      size.width * 0.8 - 40,
      startY + 360,
    );

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
