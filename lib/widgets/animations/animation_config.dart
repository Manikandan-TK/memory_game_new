import 'package:flutter/material.dart';
import '../../models/game_config.dart';

/// Configuration for card animations based on difficulty level
class CardAnimationConfig {
  final Duration duration;
  final double maxScale;
  final double perspectiveValue;
  final Curve flipCurve;
  final Curve scaleCurve;
  final Curve glowCurve;

  const CardAnimationConfig({
    required this.duration,
    required this.maxScale,
    required this.perspectiveValue,
    required this.flipCurve,
    required this.scaleCurve,
    required this.glowCurve,
  });

  /// Factory constructor to create animation config based on difficulty
  factory CardAnimationConfig.forDifficulty(GameDifficulty difficulty) {
    switch (difficulty) {
      case GameDifficulty.easy:
        return const CardAnimationConfig(
          duration: Duration(milliseconds: 600),
          maxScale: 1.15,
          perspectiveValue: 0.002,
          flipCurve: Curves.easeOutBack,
          scaleCurve: Curves.easeInOutCubic,
          glowCurve: Curves.easeOutCubic,
        );
      case GameDifficulty.medium:
        return const CardAnimationConfig(
          duration: Duration(milliseconds: 500),
          maxScale: 1.12,
          perspectiveValue: 0.0015,
          flipCurve: Curves.easeOutBack,
          scaleCurve: Curves.easeInOutCubic,
          glowCurve: Curves.easeOutCubic,
        );
      case GameDifficulty.hard:
        return const CardAnimationConfig(
          duration: Duration(milliseconds: 400),
          maxScale: 1.08,
          perspectiveValue: 0.001,
          flipCurve: Curves.easeOut,
          scaleCurve: Curves.easeInOut,
          glowCurve: Curves.easeOut,
        );
    }
  }

  /// Creates a copy of this config with optional parameter overrides
  CardAnimationConfig copyWith({
    Duration? duration,
    double? maxScale,
    double? perspectiveValue,
    Curve? flipCurve,
    Curve? scaleCurve,
    Curve? glowCurve,
  }) {
    return CardAnimationConfig(
      duration: duration ?? this.duration,
      maxScale: maxScale ?? this.maxScale,
      perspectiveValue: perspectiveValue ?? this.perspectiveValue,
      flipCurve: flipCurve ?? this.flipCurve,
      scaleCurve: scaleCurve ?? this.scaleCurve,
      glowCurve: glowCurve ?? this.glowCurve,
    );
  }
}
