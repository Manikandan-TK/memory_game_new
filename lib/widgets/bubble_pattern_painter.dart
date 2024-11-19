import 'dart:math' as math;
import 'package:flutter/material.dart';

class BubblePatternPainter extends CustomPainter {
  final Color color;
  final double density;

  BubblePatternPainter({
    required this.color,
    this.density = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final random = math.Random(42); // Fixed seed for consistent pattern
    final bubbleCount = (size.width * size.height * 0.0003 * density).round();
    
    for (var i = 0; i < bubbleCount; i++) {
      final x = random.nextDouble() * size.width;
      final y = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 20 + 10;
      
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
