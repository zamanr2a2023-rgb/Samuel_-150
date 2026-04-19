import 'package:flutter/foundation.dart';

/// Writes to the console in debug builds only.
void appLog(String message) {
  if (kDebugMode) {
    debugPrint(message);
  }
}
