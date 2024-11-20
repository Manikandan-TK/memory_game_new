import 'dart:async';
import 'package:flutter/material.dart';
import 'package:memory_game_new/models/card_theme.dart';
import 'dart:ui' as ui;
import 'package:memory_game_new/widgets/card_pattern_painter.dart';

class PerformanceTest {
  /// Test results for each theme
  static final Map<CardThemeType, int> results = {};

  /// Runs performance test for a single theme
  static int testSingleTheme(CardThemeType theme, {int cardCount = 16}) {
    final stopwatch = Stopwatch()..start();
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    
    final painter = CardPatternPainter(
      primaryColor: Colors.blue,
      secondaryColor: Colors.lightBlue,
      themeType: theme,
    );
    
    const size = Size(100, 150);
    for (int i = 0; i < cardCount; i++) {
      painter.paint(canvas, size);
    }
    
    recorder.endRecording();
    stopwatch.stop();
    return stopwatch.elapsedMilliseconds;
  }

  /// Compares rendering performance for all themes
  static Future<Map<CardThemeType, int>> compareRenderingPerformance(BuildContext context) async {
    results.clear();
    
    for (var theme in CardThemeType.values) {
      final elapsed = testSingleTheme(theme);
      results[theme] = elapsed;
      print('Theme $theme rendering time for 16 cards: ${elapsed}ms');
    }
    
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Performance test complete. Check debug console for results.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    
    return results;
  }
}
