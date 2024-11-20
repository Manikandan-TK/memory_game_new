import 'package:flutter/material.dart';

/// Interface defining animation behavior
abstract class CardAnimationController {
  Animation<double> get flipAnimation;
  Animation<double> get scaleAnimation;
  Animation<double> get glowAnimation;
  
  void startFlipAnimation(bool forward);
  void startMatchAnimation();
  void dispose();
}

/// Implementation of card animation controller
class DefaultCardAnimationController implements CardAnimationController {
  final TickerProvider vsync;
  late final AnimationController _controller;
  
  @override
  late final Animation<double> flipAnimation;
  
  @override
  late final Animation<double> scaleAnimation;
  
  @override
  late final Animation<double> glowAnimation;

  DefaultCardAnimationController({required this.vsync}) {
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: vsync,
    );

    flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    ));

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.15),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.15, end: 0.95),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0),
        weight: 35,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeInOutCubic),
    ));

    glowAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.4),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.4, end: 0.2),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.2, end: 0.3),
        weight: 30,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOutCubic),
    ));
  }

  @override
  void startFlipAnimation(bool forward) {
    if (forward) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void startMatchAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
  }
}
