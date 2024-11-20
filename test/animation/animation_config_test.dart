import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/widgets/animations/animation_config.dart';

void main() {
  group('CardAnimationConfig Tests', () {
    test('Easy mode configuration should have correct values', () {
      final config = CardAnimationConfig.forDifficulty(GameDifficulty.easy);
      
      expect(config.duration.inMilliseconds, equals(600));
      expect(config.maxScale, equals(1.15));
      expect(config.perspectiveValue, equals(0.002));
    });

    test('Medium mode configuration should have correct values', () {
      final config = CardAnimationConfig.forDifficulty(GameDifficulty.medium);
      
      expect(config.duration.inMilliseconds, equals(500));
      expect(config.maxScale, equals(1.12));
      expect(config.perspectiveValue, equals(0.0015));
    });

    test('Hard mode configuration should have correct values', () {
      final config = CardAnimationConfig.forDifficulty(GameDifficulty.hard);
      
      expect(config.duration.inMilliseconds, equals(400));
      expect(config.maxScale, equals(1.08));
      expect(config.perspectiveValue, equals(0.001));
    });

    test('copyWith should create new instance with updated values', () {
      final original = CardAnimationConfig.forDifficulty(GameDifficulty.easy);
      final modified = original.copyWith(
        duration: const Duration(milliseconds: 300),
        maxScale: 1.05,
      );

      expect(modified.duration.inMilliseconds, equals(300));
      expect(modified.maxScale, equals(1.05));
      expect(modified.perspectiveValue, equals(original.perspectiveValue));
      expect(modified.flipCurve, equals(original.flipCurve));
    });

    test('Configurations should be immutable', () {
      final config1 = CardAnimationConfig.forDifficulty(GameDifficulty.easy);
      final config2 = CardAnimationConfig.forDifficulty(GameDifficulty.easy);
      
      expect(identical(config1, config2), isTrue);
    });
  });
}
