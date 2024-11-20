import 'package:flutter_test/flutter_test.dart';
import 'package:memory_game_new/utils/performance_test.dart';
import 'package:memory_game_new/models/theme_identifier.dart';

void main() {
  group('Performance Test', () {
    setUpAll(() {
      // Initialize asset bundle for testing
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    test('should test single theme performance', () async {
      final elapsed = await PerformanceTest.testSingleTheme(ThemeIdentifier.classic);
      expect(elapsed, isNonNegative);
    });

    test('should test all available themes', () async {
      final results = await PerformanceTest.testAllThemes();
      
      for (final entry in results.entries) {
        expect(entry.value, isNonNegative);
        print('Theme ${entry.key.name} rendering time: ${entry.value}ms');
      }
    });

    test('should calculate average render time', () async {
      await PerformanceTest.testAllThemes();
      final average = PerformanceTest.getAverageRenderTime();
      
      expect(average, isNonNegative);
      print('Average rendering time: ${average}ms');
    });

    test('should handle theme asset loading', () async {
      // Test each theme identifier
      for (final identifier in ThemeIdentifier.values) {
        final elapsed = await PerformanceTest.testSingleTheme(identifier);
        expect(elapsed, isNonNegative);
        expect(elapsed, isNonZero);
      }
    });
  });
}
