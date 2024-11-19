import 'dart:math' as math;
import 'package:flutter/material.dart';

class GeometricPatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final bool isGameScreen;

  GeometricPatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
    this.isGameScreen = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final patternPaint = Paint()
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Calculate pattern density based on screen
    final spacing = isGameScreen ? 50.0 : 30.0;
    
    // Draw hexagonal pattern
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing * 0.866) {
        final progress = (x + y) / (size.width + size.height);
        patternPaint.color = Color.lerp(
          primaryColor,
          secondaryColor,
          progress,
        )!.withOpacity(isGameScreen ? 0.15 : 0.2);

        final points = _createHexagonPoints(x, y, spacing * 0.5);
        canvas.drawPath(
          Path()..addPolygon(points, true),
          patternPaint,
        );
      }
    }

    // Add connecting lines between hexagons for extra detail
    patternPaint.strokeWidth = 1.0;
    for (double x = -spacing; x < size.width + spacing; x += spacing) {
      for (double y = -spacing; y < size.height + spacing; y += spacing * 0.866) {
        final progress = (x + y) / (size.width + size.height);
        patternPaint.color = Color.lerp(
          primaryColor,
          secondaryColor,
          progress,
        )!.withOpacity(isGameScreen ? 0.1 : 0.15);

        // Draw connecting lines
        if (x + spacing < size.width) {
          canvas.drawLine(
            Offset(x + spacing * 0.5, y),
            Offset(x + spacing, y),
            patternPaint,
          );
        }
      }
    }
  }

  List<Offset> _createHexagonPoints(double centerX, double centerY, double size) {
    final points = <Offset>[];
    for (int i = 0; i < 6; i++) {
      final angle = (i * 60) * math.pi / 180;
      points.add(Offset(
        centerX + size * math.cos(angle),
        centerY + size * math.sin(angle),
      ));
    }
    return points;
  }

  @override
  bool shouldRepaint(GeometricPatternPainter oldDelegate) =>
      oldDelegate.primaryColor != primaryColor ||
      oldDelegate.secondaryColor != secondaryColor ||
      oldDelegate.isGameScreen != isGameScreen;
}
