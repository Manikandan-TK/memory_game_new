import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/widgets/animations/animation_controller.dart';
import 'package:memory_game_new/widgets/animations/card_animation_builder.dart';

void main() {
  group('Animation Behavior Tests', () {
    late TickerProvider vsync;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      vsync = const TestVSync();
    });

    testWidgets('Flip animation should complete full cycle', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardAnimationBuilder(
            controller: controller,
            isFlipped: false,
            isMatched: false,
            glowColor: Colors.green,
            cardSize: 60.0,
            difficulty: GameDifficulty.hard,
            child: const SizedBox(),
          ),
        ),
      );

      // Test forward animation
      controller.startFlipAnimation(true);
      await tester.pump();
      
      // Check start state
      expect(controller.flipAnimation.value, equals(0.0));
      
      // Move to middle of animation
      await tester.pump(const Duration(milliseconds: 200));
      expect(controller.flipAnimation.value, greaterThan(0.0));
      expect(controller.flipAnimation.value, lessThan(1.0));
      
      // Complete animation
      await tester.pump(const Duration(milliseconds: 200));
      expect(controller.flipAnimation.value, equals(1.0));

      // Test reverse animation
      controller.startFlipAnimation(false);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));
      expect(controller.flipAnimation.value, equals(0.0));
    });

    testWidgets('Match animation should follow correct sequence', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardAnimationBuilder(
            controller: controller,
            isFlipped: true,
            isMatched: true,
            glowColor: Colors.green,
            cardSize: 60.0,
            difficulty: GameDifficulty.hard,
            child: const SizedBox(),
          ),
        ),
      );

      controller.startMatchAnimation();
      await tester.pump();

      // Test scale sequence
      final scaleValues = <double>[];
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 40));
        scaleValues.add(controller.scaleAnimation.value);
      }

      // Verify scale animation sequence
      expect(scaleValues.first, equals(1.0));
      expect(scaleValues.any((v) => v > 1.0), isTrue);
      expect(scaleValues.any((v) => v < 1.0), isTrue);
      expect(scaleValues.last, equals(1.0));
    });

    testWidgets('Glow animation should sync with match animation', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardAnimationBuilder(
            controller: controller,
            isFlipped: true,
            isMatched: true,
            glowColor: Colors.green,
            cardSize: 60.0,
            difficulty: GameDifficulty.hard,
            child: const SizedBox(),
          ),
        ),
      );

      controller.startMatchAnimation();
      await tester.pump();

      // Test glow opacity sequence
      final glowValues = <double>[];
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 40));
        glowValues.add(controller.glowAnimation.value);
      }

      // Verify glow animation sequence
      expect(glowValues.first, equals(0.0));
      expect(glowValues.any((v) => v > 0.0), isTrue);
      expect(glowValues.last, lessThanOrEqualTo(0.3));
    });

    testWidgets('Animations should handle rapid state changes', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardAnimationBuilder(
            controller: controller,
            isFlipped: false,
            isMatched: false,
            glowColor: Colors.green,
            cardSize: 60.0,
            difficulty: GameDifficulty.hard,
            child: const SizedBox(),
          ),
        ),
      );

      // Rapid flip changes
      for (int i = 0; i < 3; i++) {
        controller.startFlipAnimation(true);
        await tester.pump(const Duration(milliseconds: 100));
        controller.startFlipAnimation(false);
        await tester.pump(const Duration(milliseconds: 100));
      }

      // Verify animation completes cleanly
      await tester.pumpAndSettle();
      expect(controller.flipAnimation.value, equals(0.0));
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
