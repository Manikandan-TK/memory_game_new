import 'package:flutter/material.dart';
import 'animation_controller.dart';

/// Mixin that provides card animations functionality
mixin CardAnimationMixin<T extends StatefulWidget> on State<T>, TickerProviderStateMixin<T> {
  late final CardAnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = DefaultCardAnimationController(vsync: this);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  /// Updates animations based on card state changes
  void handleCardStateChange({
    required bool isFlipped,
    required bool wasFlipped,
    required bool isMatched,
    required bool wasMatched,
  }) {
    // Handle flip animation
    if (isFlipped != wasFlipped) {
      animationController.startFlipAnimation(isFlipped);
    }
    
    // Handle match animation
    if (isMatched && !wasMatched) {
      animationController.startMatchAnimation();
    }
  }
}
