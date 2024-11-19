import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/models/score_model.dart';

void main() {
  group('Score Model Tests', () {
    test('should create Score instance with valid parameters', () {
      final now = DateTime.now();
      final score = Score(
        value: 100,
        moves: 10,
        time: const Duration(seconds: 30),
        timestamp: now,
        difficulty: 'easy',
      );

      expect(score.value, equals(100));
      expect(score.moves, equals(10));
      expect(score.time.inSeconds, equals(30));
      expect(score.timestamp, equals(now));
      expect(score.difficulty, equals('easy'));
    });

    test('should convert Score to JSON correctly', () {
      final timestamp = DateTime(2024, 1, 1, 12, 0);
      final score = Score(
        value: 150,
        moves: 15,
        time: const Duration(seconds: 45),
        timestamp: timestamp,
        difficulty: 'medium',
      );

      final json = score.toJson();

      expect(json['value'], equals(150));
      expect(json['moves'], equals(15));
      expect(json['time'], equals(45));
      expect(json['timestamp'], equals('2024-01-01T12:00:00.000'));
      expect(json['difficulty'], equals('medium'));
    });

    test('should create Score from JSON correctly', () {
      final json = {
        'value': 200,
        'moves': 20,
        'time': 60,
        'timestamp': '2024-01-01T12:00:00.000',
        'difficulty': 'hard',
      };

      final score = Score.fromJson(json);

      expect(score.value, equals(200));
      expect(score.moves, equals(20));
      expect(score.time.inSeconds, equals(60));
      expect(score.timestamp, equals(DateTime(2024, 1, 1, 12, 0)));
      expect(score.difficulty, equals('hard'));
    });

    group('Edge Cases', () {
      test('should handle zero values', () {
        final score = Score(
          value: 0,
          moves: 0,
          time: const Duration(seconds: 0),
          timestamp: DateTime.now(),
          difficulty: 'easy',
        );

        final json = score.toJson();
        final decoded = Score.fromJson(json);

        expect(decoded.value, equals(0));
        expect(decoded.moves, equals(0));
        expect(decoded.time.inSeconds, equals(0));
      });

      test('should handle large values', () {
        final score = Score(
          value: 999999,
          moves: 999999,
          time: const Duration(seconds: 999999),
          timestamp: DateTime.now(),
          difficulty: 'hard',
        );

        final json = score.toJson();
        final decoded = Score.fromJson(json);

        expect(decoded.value, equals(999999));
        expect(decoded.moves, equals(999999));
        expect(decoded.time.inSeconds, equals(999999));
      });

      test('should handle different difficulty strings', () {
        final difficulties = ['easy', 'medium', 'hard', 'custom'];
        
        for (final diff in difficulties) {
          final score = Score(
            value: 100,
            moves: 10,
            time: const Duration(seconds: 30),
            timestamp: DateTime.now(),
            difficulty: diff,
          );

          final json = score.toJson();
          final decoded = Score.fromJson(json);

          expect(decoded.difficulty, equals(diff));
        }
      });

      test('should handle negative time conversion', () {
        final json = {
          'value': 100,
          'moves': 10,
          'time': -30, // Negative time value
          'timestamp': '2024-01-01T12:00:00.000',
          'difficulty': 'easy',
        };

        final score = Score.fromJson(json);
        expect(score.time.inSeconds, equals(-30));
      });

      test('should handle maximum DateTime values', () {
        final score = Score(
          value: 100,
          moves: 10,
          time: const Duration(seconds: 30),
          timestamp: DateTime.parse('275760-09-13T00:00:00Z'), // Maximum DateTime
          difficulty: 'easy',
        );

        final json = score.toJson();
        final decoded = Score.fromJson(json);
        expect(decoded.timestamp.year, equals(275760));
      });

      test('should handle empty difficulty string', () {
        final score = Score(
          value: 100,
          moves: 10,
          time: const Duration(seconds: 30),
          timestamp: DateTime.now(),
          difficulty: '',
        );

        final json = score.toJson();
        final decoded = Score.fromJson(json);
        expect(decoded.difficulty, equals(''));
      });
    });

    group('Error Cases', () {
      test('should throw when parsing invalid JSON timestamp', () {
        final json = {
          'value': 100,
          'moves': 10,
          'time': 30,
          'timestamp': 'invalid-date',
          'difficulty': 'easy',
        };

        expect(() => Score.fromJson(json), throwsFormatException);
      });

      test('should throw when required fields are missing', () {
        final invalidJson = {
          'value': 100,
          'moves': 10,
          // time is missing
          'timestamp': '2024-01-01T12:00:00.000',
          'difficulty': 'easy',
        };

        expect(() => Score.fromJson(invalidJson), throwsA(isA<TypeError>()));
      });
    });
  });
}
