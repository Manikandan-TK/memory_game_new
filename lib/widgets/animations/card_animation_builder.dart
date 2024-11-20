import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'animation_controller.dart';
import 'animation_config.dart';
import '../../models/game_config.dart';

/// Widget that builds card animations
class CardAnimationBuilder extends StatelessWidget {
  final CardAnimationController controller;
  final bool isFlipped;
  final bool isMatched;
  final Widget child;
  final Color glowColor;
  final double cardSize;
  final GameDifficulty difficulty;

  const CardAnimationBuilder({
    Key? key,
    required this.controller,
    required this.isFlipped,
    required this.isMatched,
    required this.child,
    required this.glowColor,
    required this.cardSize,
    required this.difficulty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final config = CardAnimationConfig.forDifficulty(difficulty);
    
    return AnimatedBuilder(
      animation: Listenable.merge([
        controller.flipAnimation,
        controller.scaleAnimation,
        controller.glowAnimation,
      ]),
      builder: (context, child) {
        return Transform(
          transform: Matrix4.identity()
            ..setEntry(3, 2, config.perspectiveValue)
            ..rotateY(isFlipped ? math.pi * controller.flipAnimation.value : 0),
          alignment: Alignment.center,
          child: Transform.scale(
            scale: isMatched ? 1.0 : (controller.scaleAnimation.value),
            child: DecoratedBox(
              decoration: BoxDecoration(
                boxShadow: [
                  if (isMatched)
                    BoxShadow(
                      color: glowColor.withOpacity(0.4),
                      blurRadius: cardSize * 0.2,
                      spreadRadius: cardSize * 0.05,
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
