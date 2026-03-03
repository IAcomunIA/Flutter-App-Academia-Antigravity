import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';

class AppTheme {
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBg,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.cyan,
      secondary: AppColors.purple,
      surface: AppColors.cardBg,
      error: AppColors.error,
    ),
    cardTheme: CardThemeData(
      color: AppColors.cardBg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.borderColor),
      ),
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.heading1,
      titleLarge: AppTextStyles.heading2,
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodySecondary,
      labelSmall: AppTextStyles.caption,
    ),
  );
}
