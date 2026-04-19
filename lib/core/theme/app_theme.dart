import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

ThemeData buildAppTheme() {
  final scheme = ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.secondary,
    brightness: Brightness.dark,
  );
  return ThemeData(
    primaryColor: AppColors.primary,
    colorScheme: scheme.copyWith(
      surface: AppColors.scaffold,
    ),
    scaffoldBackgroundColor: AppColors.scaffold,
    canvasColor: AppColors.scaffold,
    useMaterial3: true,
  );
}
