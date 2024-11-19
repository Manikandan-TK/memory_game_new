import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

class LoggingConfig {
  static void init() {
    if (kDebugMode) {
      // Override print to filter out EGL messages
      debugPrint = (String? message, {int? wrapWidth}) {
        if (message == null) return;
        if (message.contains('EGL_emulation')) return;
        if (message.contains('app_time_stats')) return;
        developer.log(message, name: 'App');
      };
    }
  }
}
