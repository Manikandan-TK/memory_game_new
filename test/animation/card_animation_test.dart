import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/widgets/animations/animation_controller.dart';
import 'package:memory_game_new/widgets/animations/card_animation_builder.dart';

void main() {
  group('Card Animation Performance Tests', () {
    late TickerProvider vsync;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      vsync = const TestVSync();
    });

    testWidgets('Hard mode rapid card flips should not cause animation glitches',
        (tester) async {
      // Create animation controller with hard mode settings
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      // Build widget tree with multiple card animations
      await tester.pumpWidget(
        MaterialApp(
          home: Row(
            children: List.generate(
              4, // Test with 4 cards simultaneously
              (index) => CardAnimationBuilder(
                controller: controller,
                isFlipped: true,
                isMatched: false,
                glowColor: Colors.green,
                cardSize: 60.0, // Hard mode card size
                difficulty: GameDifficulty.hard,
                child: const SizedBox(),
              ),
            ),
          ),
        ),
      );

      // Simulate rapid card flips with proper animation completion
      for (int i = 0; i < 5; i++) {
        controller.startFlipAnimation(true);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 400)); // Full animation duration
      }

      // Allow any remaining animations to complete
      await tester.pumpAndSettle();

      // Verify no pending frames
      expect(tester.hasRunningAnimations, false);
      
      // Clean up
      controller.dispose();
    });

    testWidgets('Animation scale should adjust for card size', (tester) async {
      final controller = DefaultCardAnimationController(
        vsync: vsync,
        difficulty: GameDifficulty.hard,
      );

      // Build and test small card animation
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

      // Start match animation and verify initial state
      await tester.pump();
      controller.startMatchAnimation();
      
      // Verify scale doesn't exceed boundaries during animation
      await tester.pump();
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 40));
        final scale = controller.scaleAnimation.value;
        expect(scale, lessThanOrEqualTo(1.08)); // Max scale for small cards
      }

      // Clean up
      await tester.pumpAndSettle();
      controller.dispose();
    });

    testWidgets('Multiple animations should complete without memory leaks',
        (tester) async {
      final controllers = List.generate(
        8,
        (_) => DefaultCardAnimationController(
          vsync: vsync,
          difficulty: GameDifficulty.hard,
        ),
      );

      // Build widget tree with multiple animations
      await tester.pumpWidget(
        MaterialApp(
          home: GridView.count(
            crossAxisCount: 4,
            children: List.generate(
              8,
              (index) => CardAnimationBuilder(
                controller: controllers[index],
                isFlipped: true,
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

      // Run multiple animations with proper timing
      await tester.pump();
      for (final controller in controllers) {
        controller.startFlipAnimation(true);
      }

      // Let animations complete
      await tester.pumpAndSettle();

      // Verify all animations completed
      expect(tester.hasRunningAnimations, false);

      // Clean up
      for (final controller in controllers) {
        controller.dispose();
      }
    });
  });
}

class TestVSync implements TickerProvider {
  const TestVSync();

  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}
