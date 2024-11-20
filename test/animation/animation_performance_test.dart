import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/widgets/animations/animation_controller.dart';
import 'package:memory_game_new/widgets/animations/card_animation_builder.dart';

void main() {
  group('Animation Performance Tests', () {
    late TickerProvider vsync;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      vsync = const TestVSync();
    });

    testWidgets('Should handle concurrent animations efficiently', (tester) async {
      // Create multiple controllers for different cards
      const numCards = 16; // Maximum cards in hard mode
      final controllers = List.generate(
        numCards,
        (_) => DefaultCardAnimationController(
          vsync: vsync,
          difficulty: GameDifficulty.hard,
        ),
      );

      // Build widget tree with grid of cards
      await tester.pumpWidget(
        MaterialApp(
          home: GridView.count(
            crossAxisCount: 4,
            children: List.generate(
              numCards,
              (index) => CardAnimationBuilder(
                controller: controllers[index],
                isFlipped: false,
                isMatched: false,
                glowColor: Colors.green,
                cardSize: 60.0,
                difficulty: GameDifficulty.hard,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      // Start all animations simultaneously
      for (final controller in controllers) {
        controller.startFlipAnimation(true);
      }

      // Track frame timings
      final frameTimes = <Duration>[];
      final stopwatch = Stopwatch()..start();

      // Monitor frame times during animation
      for (int i = 0; i < 10; i++) {
        await tester.pump();
        frameTimes.add(stopwatch.elapsed);
        stopwatch.reset();
      }

      // Verify frame times are reasonable
      for (final frameTime in frameTimes) {
        // Frame time should be less than 16ms (60fps)
        expect(frameTime.inMilliseconds, lessThanOrEqualTo(16));
      }

      // Clean up
      for (final controller in controllers) {
        controller.dispose();
      }
    });

    testWidgets('Should maintain performance during rapid matches', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: CardAnimationBuilder(
            controller: controller,
            isFlipped: true,
            isMatched: false,
            glowColor: Colors.green,
            cardSize: 60.0,
            difficulty: GameDifficulty.hard,
            child: const SizedBox(),
          ),
        ),
      );

      final frameTimes = <Duration>[];
      final stopwatch = Stopwatch()..start();

      // Simulate rapid matches
      for (int i = 0; i < 5; i++) {
        controller.startMatchAnimation();
        for (int j = 0; j < 10; j++) {
          await tester.pump(const Duration(milliseconds: 40));
          frameTimes.add(stopwatch.elapsed);
          stopwatch.reset();
        }
      }

      // Verify consistent frame times
      Duration? previousFrameTime;
      for (final frameTime in frameTimes) {
        if (previousFrameTime != null) {
          // Frame time variance should be within 5ms
          expect(
            (frameTime - previousFrameTime).abs().inMilliseconds,
            lessThanOrEqualTo(5),
          );
        }
        previousFrameTime = frameTime;
      }
    });

    testWidgets('Should handle memory efficiently during animations', (tester) async {
      const numCards = 16;
      final controllers = <DefaultCardAnimationController>[];

      // Simulate multiple game rounds
      for (int round = 0; round < 3; round++) {
        // Create new controllers for each round
        controllers.clear();
        for (int i = 0; i < numCards; i++) {
          controllers.add(DefaultCardAnimationController(
            vsync: vsync,
            difficulty: GameDifficulty.hard,
          ));
        }

        await tester.pumpWidget(
          MaterialApp(
            home: GridView.count(
              crossAxisCount: 4,
              children: List.generate(
                numCards,
                (index) => CardAnimationBuilder(
                  controller: controllers[index],
                  isFlipped: false,
                  isMatched: false,
                  glowColor: Colors.green,
                  cardSize: 60.0,
                  difficulty: GameDifficulty.hard,
                  child: const SizedBox(),
                ),
              ),
            ),
          ),
        );

        // Run animations
        for (final controller in controllers) {
          controller.startFlipAnimation(true);
        }

        await tester.pump(const Duration(milliseconds: 200));

        // Clean up previous round
        for (final controller in controllers) {
          controller.dispose();
        }
      }

      // Verify no pending animations
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
