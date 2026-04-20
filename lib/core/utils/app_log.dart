import 'package:flutter/foundation.dart';

/// Debug-only trace (stripped in release).
void appLog(String message) {
  if (kDebugMode) {
    debugPrint('pm › $message');
  }
}
