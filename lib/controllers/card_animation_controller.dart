import 'package:flutter/material.dart';

/// Interface for card animation behavior
abstract class CardAnimationBehavior {
  void flipCard();
  void reset();
  bool get isFlipped;
  Animation<double> get flipAnimation;
}

/// Controller responsible for managing card flip animation state and behavior
class CardAnimationController extends ChangeNotifier implements CardAnimationBehavior {
  final AnimationController _controller;
  late final Animation<double> _flipAnimation;
  bool _showFrontSide = false;  // Initialize to false to show back side
  final bool initiallyFlipped;

  CardAnimationController({
    required TickerProvider vsync,
    Duration? duration,
    this.initiallyFlipped = false,
  }) : _controller = AnimationController(
          vsync: vsync,
          duration: duration ?? const Duration(milliseconds: 500),
        ) {
    _setupAnimation();
    _controller.addStatusListener(_handleAnimationStatus);
    _showFrontSide = initiallyFlipped;
    if (initiallyFlipped) {
      _controller.value = 1.0;
    }
  }

  void _setupAnimation() {
    _flipAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 0.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.5, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _showFrontSide = true;
      notifyListeners();
    } else if (status == AnimationStatus.dismissed) {
      _showFrontSide = false;
      notifyListeners();
    }
  }

  @override
  Animation<double> get flipAnimation => _flipAnimation;

  @override
  bool get isFlipped => _showFrontSide;

  bool get showFrontSide => _showFrontSide;

  @override
  void flipCard() {
    if (_controller.isAnimating) return;
    
    if (_showFrontSide) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
  }

  @override
  void reset() {
    _controller.reset();
    _showFrontSide = initiallyFlipped;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
