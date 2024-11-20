import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:memory_game_new/models/game_config.dart';
import 'package:memory_game_new/providers/game_provider.dart';
import 'package:memory_game_new/providers/card_theme_provider.dart';
import 'package:memory_game_new/widgets/memory_card_widget.dart';

void main() {
  group('Animation Integration Tests', () {
    late GameProvider gameProvider;
    late CardThemeProvider themeProvider;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      gameProvider = GameProvider();
      themeProvider = CardThemeProvider();
      
      // Ensure consistent game state for tests
      gameProvider.updateDifficulty(GameDifficulty.hard);
      gameProvider.initializeGame();
    });

    Widget buildTestableWidget(Widget child) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: gameProvider),
          ChangeNotifierProvider.value(value: themeProvider),
        ],
        child: MaterialApp(
          home: Material(
            child: child,
          ),
        ),
      );
    }

    testWidgets('Cards should animate correctly during game play', (tester) async {
      const cardIndex = 0;
      const animationDuration = Duration(milliseconds: 400); // Hard difficulty duration
      final cardEmoji = gameProvider.cards[cardIndex].emoji;
      
      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: MemoryCardWidget(
              card: gameProvider.cards[cardIndex],
              onTap: () => gameProvider.flipCard(cardIndex),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Initial state - card should be face down
      expect(find.text(cardEmoji), findsNothing);

      // Tap to flip card
      await tester.tap(find.byType(MemoryCardWidget));
      
      // Verify animation starts
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      
      // Wait for animation to complete
      await tester.pump(animationDuration);
      await tester.pumpAndSettle();

      // Card should now be face up
      expect(find.text(cardEmoji), findsOneWidget);
    });

    testWidgets('Match animations should trigger correctly', (tester) async {
      // Find two matching cards
      const firstCardIndex = 0;
      final firstCardEmoji = gameProvider.cards[firstCardIndex].emoji;
      final secondCardIndex = gameProvider.cards.indexWhere((card) => 
        card.emoji == firstCardEmoji && card.id != gameProvider.cards[firstCardIndex].id);
      
      const animationDuration = Duration(milliseconds: 400);

      await tester.pumpWidget(
        buildTestableWidget(
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MemoryCardWidget(
                card: gameProvider.cards[firstCardIndex],
                onTap: () => gameProvider.flipCard(firstCardIndex),
              ),
              MemoryCardWidget(
                card: gameProvider.cards[secondCardIndex],
                onTap: () => gameProvider.flipCard(secondCardIndex),
              ),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Flip first card
      await tester.tap(find.byType(MemoryCardWidget).first);
      await tester.pump();
      await tester.pump(animationDuration);
      await tester.pumpAndSettle();

      // Flip second card
      await tester.tap(find.byType(MemoryCardWidget).last);
      await tester.pump();
      
      // Wait for both flip and match animations
      await tester.pump(animationDuration);
      await tester.pumpAndSettle();

      // Both cards should show emoji and be matched
      expect(find.text(firstCardEmoji), findsNWidgets(2));
      expect(gameProvider.cards[firstCardIndex].isMatched, isTrue);
      expect(gameProvider.cards[secondCardIndex].isMatched, isTrue);
    });

    testWidgets('Animations should handle game reset correctly', (tester) async {
      // Flip all cards first
      for (var i = 0; i < gameProvider.cards.length; i++) {
        gameProvider.flipCard(i);
      }
      
      const animationDuration = Duration(milliseconds: 400);
      
      await tester.pumpWidget(
        buildTestableWidget(
          GridView.count(
            crossAxisCount: 2,
            children: List.generate(
              gameProvider.cards.length,
              (index) => MemoryCardWidget(
                card: gameProvider.cards[index],
                onTap: () {},
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Reset game
      gameProvider.resetGame();
      await tester.pump();
      await tester.pump(animationDuration);
      await tester.pumpAndSettle();

      // All cards should be face down
      for (final card in gameProvider.cards) {
        expect(find.text(card.emoji), findsNothing);
        expect(card.isFlipped, isFalse);
      }
    });

    testWidgets('Animations should handle difficulty changes', (tester) async {
      const hardDuration = Duration(milliseconds: 400);
      const easyDuration = Duration(milliseconds: 600);
      
      await tester.pumpWidget(
        buildTestableWidget(
          Center(
            child: MemoryCardWidget(
              card: gameProvider.cards[0],
              onTap: () => gameProvider.flipCard(0),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Test hard mode animation duration
      await tester.tap(find.byType(MemoryCardWidget));
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(hardDuration ~/ 2);
      expect(tester.hasRunningAnimations, isTrue);
      await tester.pump(hardDuration ~/ 2);
      await tester.pumpAndSettle();

      // Change to easy mode
      gameProvider.updateDifficulty(GameDifficulty.easy);
      await tester.pumpAndSettle();

      // Reset game for clean state
      gameProvider.resetGame();
      await tester.pumpAndSettle();

      // Test easy mode animation duration
      await tester.tap(find.byType(MemoryCardWidget));
      await tester.pump();
      expect(tester.hasRunningAnimations, isTrue);
      
      // Animation should not be complete after hard duration
      await tester.pump(hardDuration);
      expect(tester.hasRunningAnimations, isTrue);
      
      // Animation should complete after easy duration
      await tester.pump(easyDuration - hardDuration);
      await tester.pumpAndSettle();
      expect(tester.hasRunningAnimations, isFalse);
    });
  });
}
