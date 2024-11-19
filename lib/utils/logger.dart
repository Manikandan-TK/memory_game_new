import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class for handling logging throughout the application.
class GameLogger {
  static final Logger _logger = Logger('MemoryGame');
  static bool _initialized = false;

  /// Initialize the logger with the specified level.
  static void init({Level level = Level.INFO}) {
    if (_initialized) return;

    // Configure debug print filtering
    if (kDebugMode) {
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message == null) return;
        if (message.contains('EGL_emulation')) return;
        if (message.contains('app_time_stats')) return;
        developer.log(message, name: 'MemoryGame');
      };
    }

    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      // Add timestamp and format the message
      final time = record.time.toLocal().toString().split(' ')[1];
      final emoji = _getLogEmoji(record.level);
      
      // Format: [Time] 🎮 Message
      debugPrint('[$time] $emoji ${record.message}');
      
      if (record.error != null) {
        debugPrint('[$time] ❌ Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        debugPrint('[$time] 📚 Stack trace:\n${record.stackTrace}');
      }
    });

    _initialized = true;
  }

  // Helper method to get emoji for log level
  static String _getLogEmoji(Level level) {
    if (level == Level.SEVERE) return '🔥';  // Error
    if (level == Level.WARNING) return '⚠️';  // Warning
    if (level == Level.INFO) return '🎮';     // Game info
    return '🔍';                              // Debug/Fine
  }

  /// Log a debug message
  static void d(String message) => _logger.fine(message);

  /// Log an info message
  static void i(String message) => _logger.info(message);

  /// Log a warning message
  static void w(String message) => _logger.warning(message);

  /// Log an error message
  static void e(String message, [Object? error, StackTrace? stackTrace]) =>
      _logger.severe(message, error, stackTrace);
}
