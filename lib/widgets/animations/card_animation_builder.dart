import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'animation_controller.dart';

/// Widget that builds card animations
class CardAnimationBuilder extends StatelessWidget {
  final CardAnimationController controller;
  final bool isFlipped;
  final bool isMatched;
  final Widget child;
  final Color glowColor;
  final double cardSize;

  const CardAnimationBuilder({
    Key? key,
    required this.controller,
    required this.isFlipped,
    required this.isMatched,
    required this.child,
    required this.glowColor,
    required this.cardSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller.flipAnimation,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.002) // Perspective
            ..rotateY(isFlipped ? math.pi * controller.flipAnimation.value : 0),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: isMatched ? controller.scaleAnimation.value : 1.0,
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  if (isMatched)
                    BoxShadow(
                      color: glowColor.withOpacity(controller.glowAnimation.value),
                      blurRadius: cardSize * 0.2,
                      spreadRadius: 4,
                    ),
                ],
              ),
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}
