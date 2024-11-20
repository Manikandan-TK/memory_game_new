import 'package:flutter/material.dart';
import '../../models/game_config.dart';
import 'animation_config.dart';

/// Interface defining animation behavior
abstract class CardAnimationController {
  Animation<double> get flipAnimation;
  Animation<double> get scaleAnimation;
  Animation<double> get glowAnimation;
  
  void startFlipAnimation(bool forward);
  void startMatchAnimation();
  void dispose();
  void reset();
}

/// Implementation of card animation controller
class DefaultCardAnimationController implements CardAnimationController {
  final TickerProvider vsync;
  final GameDifficulty difficulty;
  late final AnimationController _controller;
  late final CardAnimationConfig _config;
  bool _isDisposed = false;
  
  @override
  late final Animation<double> flipAnimation;
  
  @override
  late final Animation<double> scaleAnimation;
  
  @override
  late final Animation<double> glowAnimation;

  DefaultCardAnimationController({
    required this.vsync,
    required this.difficulty,
  }) {
    _config = CardAnimationConfig.forDifficulty(difficulty);
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _controller = AnimationController(
      duration: _config.duration,
      vsync: vsync,
    );

    flipAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: _config.flipCurve,
    ));

    scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: _config.maxScale),
        weight: 35,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: _config.maxScale, end: 0.95),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.95, end: 1.0),
        weight: 35,
      ),
    ]).animate(CurvedAnimation(
      parent: _controller,
      curve: _config.scaleCurve,
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
      curve: _config.glowCurve,
    ));
  }

  @override
  void startFlipAnimation(bool forward) {
    if (_isDisposed) return;
    if (forward) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void startMatchAnimation() {
    if (_isDisposed) return;
    _controller.reset();
    _controller.forward();
  }

  @override
  void dispose() {
    if (!_isDisposed) {
      _isDisposed = true;
      _controller.stop();
      _controller.dispose();
    }
  }

  @override
  void reset() {
    if (_isDisposed) return;
    _controller.reset();
  }
}
