import 'dart:async';
import 'package:flutter/material.dart';
import '../models/card_theme.dart' as game;
import '../models/theme_identifier.dart';
import 'dart:ui' as ui;

/// A utility class for testing the performance of card theme rendering
class PerformanceTest {
  /// Test results for each theme
  static final Map<ThemeIdentifier, int> results = {};

  /// Loads and decodes an image from an asset path
  static Future<ui.Image> _loadImage(String assetPath) async {
    final imageProvider = AssetImage(assetPath);
    final completer = Completer<ui.Image>();
    
    final imageStream = imageProvider.resolve(ImageConfiguration.empty);
    final listener = ImageStreamListener(
      (info, _) => completer.complete(info.image),
      onError: (error, stackTrace) => completer.completeError(error),
    );
    
    imageStream.addListener(listener);
    return completer.future;
  }

  /// Runs performance test for a single theme
  static Future<int> testSingleTheme(ThemeIdentifier themeId, {int cardCount = 16}) async {
    final theme = game.CardTheme.fromIdentifier(themeId);
    final stopwatch = Stopwatch()..start();

    try {
      // Load and decode the image
      final image = await _loadImage(theme.cardBackAsset.assetPath);

      // Draw the cards
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      
      const size = Size(100, 150);
      for (int i = 0; i < cardCount; i++) {
        final rect = Rect.fromLTWH(
          (i % 4) * size.width,
          (i ~/ 4) * size.height,
          size.width,
          size.height,
        );
        
        // Draw card back image
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          rect,
          Paint(),
        );

        // Draw border
        final borderPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = theme.cardBackAsset.borderColor;
        canvas.drawRect(rect, borderPaint);
      }
      
      recorder.endRecording();
      stopwatch.stop();
      return stopwatch.elapsedMilliseconds;
    } catch (e) {
      print('Error testing theme ${theme.name}: $e');
      return -1;
    }
  }

  /// Runs performance test for all themes
  static Future<Map<ThemeIdentifier, int>> testAllThemes({int cardCount = 16}) async {
    results.clear();
    for (final themeId in ThemeIdentifier.values) {
      results[themeId] = await testSingleTheme(themeId, cardCount: cardCount);
    }
    return Map.unmodifiable(results);
  }

  /// Gets the average render time across all themes
  static double getAverageRenderTime() {
    if (results.isEmpty) return 0;
    final validResults = results.values.where((time) => time >= 0);
    if (validResults.isEmpty) return 0;
    
    final total = validResults.reduce((a, b) => a + b);
    return total / validResults.length;
  }
}
