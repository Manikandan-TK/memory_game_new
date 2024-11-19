import '../models/game_config.dart';

class GameScoreCalculator {
  // Scoring constants
  static const double matchPoints = 100.0;
  static const double quickMatchBonus = 50.0;
  static const double comboBonus = 25.0;
  static const int quickMatchThreshold = 3; // seconds

  // Difficulty multipliers
  static const Map<GameDifficulty, double> difficultyMultipliers = {
    GameDifficulty.easy: 1.0,
    GameDifficulty.medium: 1.5,
    GameDifficulty.hard: 2.0,
  };

  static int calculateMatchScore({
    required GameDifficulty difficulty,
    required bool isQuickMatch,
    required int comboCount,
  }) {
    final multiplier = difficultyMultipliers[difficulty] ?? 1.0;
    double score = matchPoints;

    // Add quick match bonus
    if (isQuickMatch) {
      score += quickMatchBonus;
    }

    // Add combo bonus
    if (comboCount > 1) {
      score += comboBonus * comboCount;
    }

    // Apply difficulty multiplier
    score *= multiplier;

    return score.round();
  }

  static bool isQuickMatch(Duration matchDuration) {
    return matchDuration.inSeconds <= quickMatchThreshold;
  }
}
