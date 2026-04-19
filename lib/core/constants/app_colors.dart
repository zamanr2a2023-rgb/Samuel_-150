import 'package:flutter/material.dart';

/// Brand, surfaces, and a few feature-specific accents used across the UI.
abstract final class AppColors {
  static const Color primary = Color(0xFFFF8C42);
  /// Slightly deeper orange for gradients and pressed states.
  static const Color primaryDeep = Color(0xFFE8702E);
  static const Color secondary = Color(0xFF27AE60);
  static const Color scaffold = Color(0xFF2C3E50);
  static const Color surface = Color(0xFF34495E);
  /// Cards / panels lifted above [scaffold].
  static const Color surfaceElevated = Color(0xFF3D566E);
  static const Color accentBlue = Color(0xFF1E5BA8);
  static const Color facebook = Color(0xFF1877F2);

  /// Settings / privacy screens (darker navy than [scaffold]).
  static const Color settingsBackground = Color(0xFF1E3252);

  /// Map route / transport accent (Material blue).
  static const Color mapRoute = Color(0xFF2196F3);

  static const Color sliderActive = Color(0xFF3A8EEA);
  static const Color sliderOverlay = Color(0x223A8EEA);
}
