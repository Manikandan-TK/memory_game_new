import 'package:flutter/foundation.dart';
import 'dart:developer' as developer;

class AndroidLogger {
  static void init() {
    if (!kDebugMode) return;
    
    // Override default logging
    debugPrint = (String? message, {int? wrapWidth}) {
      if (message == null) return;
      if (message.contains('EGL_emulation')) return;
      if (message.contains('app_time_stats')) return;
      developer.log(message, name: 'App');
    };
  }
}
