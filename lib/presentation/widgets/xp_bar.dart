import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_typography.dart';

class XPBar extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final int currentXP;
  final int nextLevelXP;

  const XPBar({super.key, required this.progress, required this.currentXP, required this.nextLevelXP});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progreso de Nivel', style: AppTextStyles.bodySecondary),
            Text('$currentXP / $nextLevelXP XP', style: AppTextStyles.xpCounter.copyWith(fontSize: 14)),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: AppColors.surfaceBg,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.cyan),
            minHeight: 12,
          ),
        ),
      ],
    );
  }
}