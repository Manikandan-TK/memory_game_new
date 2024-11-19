import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/providers/score_provider.dart';
import 'package:memory_game_new/models/game_config.dart';

void main() {
  group('ScoreProvider Tests', () {
    late ScoreProvider scoreProvider;

    setUp(() {
      scoreProvider = ScoreProvider();
    });

    test('should calculate score correctly for easy difficulty', () {
      // Base score: 1000
      // Moves penalty: 10 moves * 10 points = -100
      // Time penalty: 30 seconds * 2 points = -60
      // Difficulty multiplier: 1.0 (easy)
      // Expected: (1000 - 100 - 60) * 1.0 = 840
      scoreProvider.calculateScore(
        moves: 10,
        time: const Duration(seconds: 30),
        difficulty: GameDifficulty.easy,
      );

      expect(scoreProvider.currentScore?.value, equals(840));
      expect(scoreProvider.currentScore?.moves, equals(10));
      expect(scoreProvider.currentScore?.time.inSeconds, equals(30));
      expect(scoreProvider.currentScore?.difficulty, equals('easy'));
    });

    test('should calculate score correctly for medium difficulty', () {
      // Base score: 1000
      // Moves penalty: 10 moves * 10 points = -100
      // Time penalty: 30 seconds * 2 points = -60
      // Difficulty multiplier: 1.5 (medium)
      // Expected: (1000 - 100 - 60) * 1.5 = 1260
      scoreProvider.calculateScore(
        moves: 10,
        time: const Duration(seconds: 30),
        difficulty: GameDifficulty.medium,
      );

      expect(scoreProvider.currentScore?.value, equals(1260));
      expect(scoreProvider.currentScore?.difficulty, equals('medium'));
    });

    test('should calculate score correctly for hard difficulty', () {
      // Base score: 1000
      // Moves penalty: 10 moves * 10 points = -100
      // Time penalty: 30 seconds * 2 points = -60
      // Difficulty multiplier: 2.0 (hard)
      // Expected: (1000 - 100 - 60) * 2.0 = 1680
      scoreProvider.calculateScore(
        moves: 10,
        time: const Duration(seconds: 30),
        difficulty: GameDifficulty.hard,
      );

      expect(scoreProvider.currentScore?.value, equals(1680));
      expect(scoreProvider.currentScore?.difficulty, equals('hard'));
    });

    test('should not allow negative scores', () {
      // Using very high penalties that would result in negative score
      scoreProvider.calculateScore(
        moves: 1000, // -10000 points
        time: const Duration(seconds: 1000), // -2000 points
        difficulty: GameDifficulty.easy,
      );

      expect(scoreProvider.currentScore?.value, equals(0));
    });

    test('should reset score correctly', () {
      scoreProvider.calculateScore(
        moves: 10,
        time: const Duration(seconds: 30),
        difficulty: GameDifficulty.easy,
      );

      expect(scoreProvider.currentScore, isNotNull);

      scoreProvider.resetCurrentScore();
      expect(scoreProvider.currentScore, isNull);
    });

    test('should update high scores correctly', () {
      // Add three scores
      scoreProvider.calculateScore(
        moves: 10,
        time: const Duration(seconds: 30),
        difficulty: GameDifficulty.hard,
      ); // 1680 points

      expect(scoreProvider.highScores.length, equals(1));
      expect(scoreProvider.highScores.first.value, equals(1680));

      scoreProvider.calculateScore(
        moves: 5,
        time: const Duration(seconds: 15),
        difficulty: GameDifficulty.hard,
      ); // 1850 points

      expect(scoreProvider.highScores.length, equals(2));
      expect(scoreProvider.highScores.first.value, equals(1850));
    });
  });
}
