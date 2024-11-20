import 'package:logging/logging.dart';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// A utility class for handling logging throughout the application.
/// 
/// Features:
/// - Emoji-based log levels for better visibility
/// - Debug mode filtering for system messages
/// - Performance optimized string handling
/// - Stack trace formatting
/// - Release mode safety
class GameLogger {
  static final Logger _logger = Logger('MemoryGame');
  static bool _initialized = false;
  
  // Get emoji for log level
  static String _getLogEmoji(Level level) {
    if (level == Level.SEVERE) return '🔥';   // Error
    if (level == Level.WARNING) return '⚠️';  // Warning
    if (level == Level.INFO) return '🎮';     // Game info
    if (level == Level.FINE) return '🔍';     // Debug
    if (level == Level.FINEST) return '🔬';   // Verbose
    return '📝';                              // Default
  }

  // Messages to filter in debug mode
  static const List<String> _filteredMessages = [
    'EGL_emulation',
    'app_time_stats',
    'FlutterEventChannel',
    'FlutterMethodChannel',
  ];

  /// Initialize the logger with the specified level.
  /// 
  /// Parameters:
  /// - [level]: The minimum log level to display (default: INFO)
  /// - [includeTimestamp]: Whether to include timestamps in logs (default: true)
  /// - [filterDebugMessages]: Whether to filter common debug messages (default: true)
  static void init({
    Level level = Level.INFO,
    bool includeTimestamp = true,
    bool filterDebugMessages = true,
  }) {
    if (_initialized) return;

    // Configure debug print filtering
    if (kDebugMode && filterDebugMessages) {
      debugPrint = (String? message, {int? wrapWidth}) {
        if (_shouldFilterMessage(message)) return;
        developer.log(message ?? '', name: 'MemoryGame');
      };
    }

    Logger.root.level = level;
    Logger.root.onRecord.listen((record) {
      if (!kDebugMode && record.level <= Level.INFO) return; // Limit logging in release mode
      
      final buffer = StringBuffer();
      
      // Add timestamp if enabled
      if (includeTimestamp) {
        final time = record.time.toLocal().toString().split(' ')[1];
        buffer.write('[$time] ');
      }
      
      // Add emoji and message
      final emoji = _getLogEmoji(record.level);
      buffer.write('$emoji ${record.message}');
      
      // Log the main message
      debugPrint(buffer.toString());
      
      // Log error and stack trace if present
      if (record.error != null) {
        debugPrint('❌ Error: ${record.error}');
      }
      
      if (record.stackTrace != null) {
        final stackTrace = record.stackTrace;
        if (stackTrace != null) {  
          _logStackTrace(stackTrace);
        }
      }
    });

    _initialized = true;
  }

  /// Checks if a debug message should be filtered
  static bool _shouldFilterMessage(String? message) {
    if (message == null) return true;
    return _filteredMessages.any((filter) => message.contains(filter));
  }

  /// Formats and logs a stack trace in a readable way
  static void _logStackTrace(StackTrace stackTrace) {
    final lines = stackTrace.toString().split('\n');
    final buffer = StringBuffer('📚 Stack trace:\n');
    
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();
      if (line.isEmpty) continue;
      
      // Add indentation for better readability
      buffer.write('    $line\n');
      
      // Limit stack trace length in release mode
      if (!kDebugMode && i >= 5) {
        buffer.write('    ...(${lines.length - i - 1} more lines)\n');
        break;
      }
    }
    
    debugPrint(buffer.toString());
  }

  /// Log a debug message with optional data
  static void d(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      message = '$message ${_formatData(data)}';
    }
    _logger.fine(message);
  }

  /// Log an info message with optional data
  static void i(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      message = '$message ${_formatData(data)}';
    }
    _logger.info(message);
  }

  /// Log a warning message with optional data
  static void w(String message, [Map<String, dynamic>? data]) {
    if (data != null) {
      message = '$message ${_formatData(data)}';
    }
    _logger.warning(message);
  }

  /// Log an error message with optional error object and stack trace
  static void e(String message, [Object? error, StackTrace? stackTrace, Map<String, dynamic>? data]) {
    if (data != null) {
      message = '$message ${_formatData(data)}';
    }
    _logger.severe(message, error, stackTrace);
  }

  /// Format additional data for logging
  static String _formatData(Map<String, dynamic> data) {
    return '| ${data.entries.map((e) => '${e.key}: ${e.value}').join(', ')}';
  }
}
