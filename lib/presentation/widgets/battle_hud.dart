import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';

/// Widget para el modo Battle: quiz rápido contra el tiempo (V2)
class BattleHud extends StatelessWidget {
  final int timeRemaining; // Segundos restantes
  final int maxTime; // Tiempo máximo por pregunta
  final int currentStreak; // Racha actual
  final int multiplier; // Multiplicador activo (1, 2, 3)
  final int questionNumber; // Pregunta actual
  final int totalQuestions; // Total de preguntas

  const BattleHud({
    super.key,
    required this.timeRemaining,
    this.maxTime = 8,
    required this.currentStreak,
    required this.multiplier,
    required this.questionNumber,
    required this.totalQuestions,
  });

  @override
  Widget build(BuildContext context) {
    final timePercent = timeRemaining / maxTime;
    final isUrgent = timeRemaining <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUrgent
              ? AppColors.error.withOpacity(0.5)
              : AppColors.borderColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Fila superior: pregunta actual + timer + streak
          Row(
            children: [
              // Pregunta
              Text(
                '$questionNumber/$totalQuestions',
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
              ),
              const Spacer(),
              // Timer grande
              Text(
                '$timeRemaining',
                style: TextStyle(
                  color: isUrgent ? AppColors.error : AppColors.textPrimary,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Orbitron',
                ),
              ),
              const Spacer(),
              // Streak + multiplicador
              if (currentStreak > 0) ...[
                ...List.generate(
                  currentStreak.clamp(0, 5),
                  (i) => const Padding(
                    padding: EdgeInsets.only(right: 2),
                    child: Icon(
                      Icons.local_fire_department,
                      size: 18,
                      color: AppColors.warning,
                    ),
                  ),
                ),
                if (multiplier > 1)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.xpGold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '×$multiplier',
                      style: const TextStyle(
                        color: AppColors.xpGold,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ] else
                const Text(
                  '---',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
            ],
          ),
          const SizedBox(height: 8),
          // Barra de tiempo
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: timePercent,
              minHeight: 6,
              backgroundColor: AppColors.surfaceBg,
              valueColor: AlwaysStoppedAnimation<Color>(
                isUrgent
                    ? AppColors.error
                    : timePercent < 0.5
                    ? AppColors.warning
                    : AppColors.cyan,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
