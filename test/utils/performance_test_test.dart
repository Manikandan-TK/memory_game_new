import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/utils/performance_test.dart';
import 'package:memory_game_new/models/card_theme.dart';

void main() {
  group('Performance Test', () {
    test('should test single theme performance', () {
      final elapsed = PerformanceTest.testSingleTheme(CardThemeType.classic);
      expect(elapsed, isNonNegative);
    });

    test('should test all available themes', () {
      for (final theme in CardThemeType.values) {
        final elapsed = PerformanceTest.testSingleTheme(theme);
        expect(elapsed, isNonNegative);
        print('Theme $theme rendering time: ${elapsed}ms');
      }
    });

    testWidgets('should show completion message', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () => PerformanceTest.compareRenderingPerformance(context),
                child: const Text('Run Test'),
              ),
            ),
          ),
        ),
      );

      // Get context and run test
      final context = tester.element(find.text('Run Test'));
      final results = await PerformanceTest.compareRenderingPerformance(context);
      
      // Verify results
      expect(results.length, equals(CardThemeType.values.length));
      expect(results.values.every((time) => time >= 0), isTrue);

      // Verify UI update
      await tester.pump();
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
