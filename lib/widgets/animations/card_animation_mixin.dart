import 'package:flutter/material.dart';
import 'animation_controller.dart';
import '../../models/game_config.dart';

/// Mixin that provides card animations functionality
mixin CardAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late final CardAnimationController animationController;
  bool _isAnimating = false;

  /// Get the current difficulty level
  GameDifficulty get difficulty;

  @override
  void initState() {
    super.initState();
    animationController = DefaultCardAnimationController(
      vsync: this,
      difficulty: difficulty,
    );
  }

  @override
  void dispose() {
    if (mounted) {
      animationController.dispose();
    }
    super.dispose();
  }

  /// Updates animations based on card state changes
  void handleCardStateChange({
    required bool isFlipped,
    required bool wasFlipped,
    required bool isMatched,
    required bool wasMatched,
  }) {
    if (!mounted || _isAnimating) return;

    try {
      _isAnimating = true;
      
      // Handle flip animation
      if (isFlipped != wasFlipped) {
        animationController.startFlipAnimation(isFlipped);
      }
      
      // Handle match animation
      if (isMatched && !wasMatched) {
        animationController.startMatchAnimation();
      }
    } finally {
      _isAnimating = false;
    }
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ensure animations are properly reset when widget updates
    if (!mounted || _isAnimating) return;
    animationController.reset();
  }
}
