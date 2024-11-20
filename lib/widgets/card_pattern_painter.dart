import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/card_theme.dart';

class CardPatternPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final CardThemeType themeType;

  CardPatternPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.themeType,
  });

  @override
  void paint(Canvas canvas, Size size) {
    switch (themeType) {
      case CardThemeType.classic:
        _paintClassicPattern(canvas, size);
        break;
      case CardThemeType.geometric:
        _paintGeometricPattern(canvas, size);
        break;
      case CardThemeType.nature:
        _paintNaturePattern(canvas, size);
        break;
      case CardThemeType.space:
        _paintSpacePattern(canvas, size);
        break;
      case CardThemeType.tech:
        _paintTechPattern(canvas, size);
        break;
    }
  }

  void _paintClassicPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final width = size.width;
    final height = size.height;
    
    // Draw border first
    paint.color = primaryColor.withOpacity(0.8);
    final borderRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(4, 4, width - 8, height - 8),
      const Radius.circular(8),
    );
    canvas.drawRRect(borderRect, paint);

    // Create a path for clipping
    final clipPath = Path()..addRRect(borderRect);
    canvas.clipPath(clipPath);

    final spacing = math.min(width, height) / 8;
    paint.color = primaryColor.withOpacity(0.6);

    // Draw diagonal lines from top-left to bottom-right
    for (double i = -height; i < width + height; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + height, height),
        paint,
      );
    }

    // Draw crossing diagonal lines from top-right to bottom-left
    paint.color = secondaryColor.withOpacity(0.5);
    for (double i = -height; i < width + height; i += spacing) {
      canvas.drawLine(
        Offset(width - i, 0),
        Offset(width - (i + height), height),
        paint,
      );
    }
  }

  void _paintGeometricPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = math.min(size.width, size.height) * 0.35;

    // Draw multiple rotated squares
    for (int i = 0; i < 4; i++) {
      final angle = i * math.pi / 4;
      paint.color = i.isEven 
          ? primaryColor.withOpacity(0.7 - i * 0.1)
          : secondaryColor.withOpacity(0.6 - i * 0.1);

      final points = <Offset>[];
      for (int j = 0; j < 4; j++) {
        final pointAngle = angle + j * math.pi / 2;
        points.add(Offset(
          centerX + radius * math.cos(pointAngle),
          centerY + radius * math.sin(pointAngle),
        ));
      }

      final path = Path()
        ..moveTo(points[0].dx, points[0].dy);
      for (int j = 1; j < points.length; j++) {
        path.lineTo(points[j].dx, points[j].dy);
      }
      path.close();
      canvas.drawPath(path, paint);
    }

    // Draw connecting lines
    paint.color = primaryColor.withOpacity(0.3);
    final outerPoints = <Offset>[];
    for (int i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      outerPoints.add(Offset(
        centerX + radius * math.cos(angle),
        centerY + radius * math.sin(angle),
      ));
    }

    for (int i = 0; i < 4; i++) {
      canvas.drawLine(outerPoints[i], outerPoints[i + 4], paint);
    }
  }

  void _paintNaturePattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;

    // Draw leaf veins
    paint.color = primaryColor.withOpacity(0.4);
    final mainVein = Path()
      ..moveTo(width * 0.5, height * 0.2)
      ..quadraticBezierTo(
        width * 0.5,
        height * 0.5,
        width * 0.5,
        height * 0.8,
      );
    canvas.drawPath(mainVein, paint);

    // Draw side veins
    paint.color = secondaryColor.withOpacity(0.3);
    for (int i = 0; i < 5; i++) {
      final y = height * (0.3 + i * 0.1);
      final controlY = y - height * 0.05;
      
      // Left vein
      final leftVein = Path()
        ..moveTo(width * 0.5, y)
        ..quadraticBezierTo(
          width * 0.3,
          controlY,
          width * 0.2,
          y,
        );
      canvas.drawPath(leftVein, paint);

      // Right vein
      final rightVein = Path()
        ..moveTo(width * 0.5, y)
        ..quadraticBezierTo(
          width * 0.7,
          controlY,
          width * 0.8,
          y,
        );
      canvas.drawPath(rightVein, paint);
    }

    // Draw leaf outline
    paint.color = primaryColor.withOpacity(0.5);
    final leafOutline = Path()
      ..moveTo(width * 0.5, height * 0.2)
      ..quadraticBezierTo(
        width * 0.2,
        height * 0.5,
        width * 0.5,
        height * 0.8,
      )
      ..quadraticBezierTo(
        width * 0.8,
        height * 0.5,
        width * 0.5,
        height * 0.2,
      );
    canvas.drawPath(leafOutline, paint);
  }

  void _paintSpacePattern(Canvas canvas, Size size) {
    final paint = Paint()..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;
    final centerX = width / 2;
    final centerY = height / 2;

    // Draw stars
    final random = math.Random(42); // Fixed seed for consistent pattern
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < 20; i++) {
      final x = random.nextDouble() * width;
      final y = random.nextDouble() * height;
      final radius = random.nextDouble() * 2 + 1;
      
      paint.color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withOpacity(random.nextDouble() * 0.5 + 0.2);
      
      canvas.drawCircle(Offset(x, y), radius, paint);
    }

    // Draw orbital rings
    paint.style = PaintingStyle.stroke;
    for (int i = 0; i < 3; i++) {
      final radius = math.min(width, height) * (0.2 + i * 0.1);
      paint.color = (i % 2 == 0 ? primaryColor : secondaryColor)
          .withOpacity(0.3);
      
      final oval = Path()
        ..addOval(Rect.fromCenter(
          center: Offset(centerX, centerY),
          width: radius * 2,
          height: radius,
        ));
      canvas.drawPath(oval, paint);
    }

    // Draw central planet
    paint.style = PaintingStyle.fill;
    paint.color = primaryColor.withOpacity(0.4);
    canvas.drawCircle(
      Offset(centerX, centerY),
      math.min(width, height) * 0.15,
      paint,
    );

    // Draw planet ring
    paint.style = PaintingStyle.stroke;
    paint.color = secondaryColor.withOpacity(0.5);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(centerX, centerY),
        width: math.min(width, height) * 0.4,
        height: math.min(width, height) * 0.1,
      ),
      paint,
    );
  }

  void _paintTechPattern(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final width = size.width;
    final height = size.height;
    final unitSize = math.min(width, height) * 0.1;

    // Draw circuit board pattern
    paint.color = primaryColor.withOpacity(0.4);
    
    // Main vertical lines
    for (double x = unitSize; x < width - unitSize; x += unitSize * 2) {
      canvas.drawLine(
        Offset(x, unitSize),
        Offset(x, height - unitSize),
        paint,
      );
    }

    // Main horizontal lines
    for (double y = unitSize; y < height - unitSize; y += unitSize * 2) {
      canvas.drawLine(
        Offset(unitSize, y),
        Offset(width - unitSize, y),
        paint,
      );
    }

    // Draw connection nodes
    paint.color = secondaryColor.withOpacity(0.5);
    for (double x = unitSize; x < width - unitSize; x += unitSize * 2) {
      for (double y = unitSize; y < height - unitSize; y += unitSize * 2) {
        canvas.drawCircle(Offset(x, y), 3, paint);
        
        // Draw small connecting lines
        if (x < width - unitSize * 2) {
          canvas.drawLine(
            Offset(x + 3, y),
            Offset(x + unitSize * 2 - 3, y),
            paint..color = secondaryColor.withOpacity(0.3),
          );
        }
        if (y < height - unitSize * 2) {
          canvas.drawLine(
            Offset(x, y + 3),
            Offset(x, y + unitSize * 2 - 3),
            paint,
          );
        }
      }
    }

    // Draw IC chip pattern in center
    final chipRect = Rect.fromCenter(
      center: Offset(width / 2, height / 2),
      width: unitSize * 4,
      height: unitSize * 3,
    );
    paint.color = primaryColor.withOpacity(0.6);
    canvas.drawRect(chipRect, paint);
    
    // Draw chip pins
    paint.color = secondaryColor.withOpacity(0.5);
    final pinWidth = unitSize * 0.4;
    final pinSpacing = unitSize * 0.8;
    
    for (int i = 0; i < 3; i++) {
      // Left pins
      canvas.drawRect(
        Rect.fromLTWH(
          chipRect.left - pinWidth,
          chipRect.top + pinSpacing * i,
          pinWidth,
          pinWidth,
        ),
        paint,
      );
      
      // Right pins
      canvas.drawRect(
        Rect.fromLTWH(
          chipRect.right,
          chipRect.top + pinSpacing * i,
          pinWidth,
          pinWidth,
        ),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CardPatternPainter oldDelegate) {
    return oldDelegate.primaryColor != primaryColor ||
        oldDelegate.secondaryColor != secondaryColor ||
        oldDelegate.themeType != themeType;
  }
}
