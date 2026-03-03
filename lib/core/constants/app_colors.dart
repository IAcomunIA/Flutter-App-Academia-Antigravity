import 'package:flutter/material.dart';

class AppColors {
  // Fondos
  static const darkBg = Color(0xFF0A0E1A);
  static const cardBg = Color(0xFF111827);
  static const surfaceBg = Color(0xFF1F2937);
  static const borderColor = Color(0xFF374151);

  // Primarios
  static const cyan = Color(0xFF00D4FF);
  static const purple = Color(0xFF7B2FBE);
  static const cyanDark = Color(0xFF0891B2);
  static const purpleLight = Color(0xFFA855F7);

  // Semánticos
  static const success = Color(0xFF10B981);
  static const error = Color(0xFFEF4444);
  static const warning = Color(0xFFF59E0B);
  static const xpGold = Color(0xFFFFD700);
  static const starColor = Color(0xFFFFB800);

  // Texto
  static const textPrimary = Color(0xFFFFFFFF);
  static const textSecondary = Color(0xFF9CA3AF);
  static const textMuted = Color(0xFF6B7280);

  // Categorías
  static const catAI = Color(0xFF00D4FF);
  static const catAgents = Color(0xFF7B2FBE);
  static const catPython = Color(0xFF10B981);
  static const catArch = Color(0xFFF59E0B);
  static const catProductivity = Color(0xFFEC4899);

  // Gradientes
  static const gradientCyan = LinearGradient(
    colors: [Color(0xFF00D4FF), Color(0xFF0891B2)],
  );
  static const gradientPurple = LinearGradient(
    colors: [Color(0xFF7B2FBE), Color(0xFFA855F7)],
  );
}
