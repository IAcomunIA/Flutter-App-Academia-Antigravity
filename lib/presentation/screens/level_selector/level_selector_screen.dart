import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/models/level_progress.dart';
import 'package:antigravity_quiz/presentation/providers/level_selector_provider.dart';
import 'package:antigravity_quiz/presentation/screens/mission/mission_screen.dart';

class LevelSelectorScreen extends ConsumerWidget {
  final int categoryId;
  final int subcategoryId;
  final String subcategoryName;
  final Color categoryColor;

  const LevelSelectorScreen({
    super.key,
    required this.categoryId,
    required this.subcategoryId,
    required this.subcategoryName,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(levelSelectorProvider(subcategoryId));

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              subcategoryName,
              style: AppTextStyles.heading2.copyWith(fontSize: 16),
            ),
            Text(
              'Selecciona tu nivel',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      body: state.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.cyan),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Ilustración superior
                  Container(
                    height: 120,
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 32),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          categoryColor.withOpacity(0.15),
                          AppColors.cardBg,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: categoryColor.withOpacity(0.3)),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.school, size: 40, color: categoryColor),
                          const SizedBox(height: 8),
                          Text(
                            subcategoryName,
                            style: TextStyle(
                              color: categoryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Nivel BÁSICO
                  _buildLevelCard(
                    context: context,
                    ref: ref,
                    level: 'basico',
                    title: 'BÁSICO',
                    subtitle: 'Conceptos fundamentales · 30s por pregunta',
                    icon: Icons.star_border,
                    color: AppColors.success,
                    isUnlocked: true,
                    progress: state.basicProgress,
                    xpMultiplier: '×1',
                  ),
                  const SizedBox(height: 16),

                  // Nivel INTERMEDIO
                  _buildLevelCard(
                    context: context,
                    ref: ref,
                    level: 'intermedio',
                    title: 'INTERMEDIO',
                    subtitle: 'Aplicación de conceptos · 20s por pregunta',
                    icon: Icons.star_half,
                    color: AppColors.warning,
                    isUnlocked: state.isIntermediateUnlocked,
                    progress: state.intermediateProgress,
                    xpMultiplier: '×1.5',
                  ),
                  const SizedBox(height: 16),

                  // Nivel AVANZADO
                  _buildLevelCard(
                    context: context,
                    ref: ref,
                    level: 'avanzado',
                    title: 'AVANZADO',
                    subtitle: 'Casos reales Antigravity · 15s por pregunta',
                    icon: Icons.star,
                    color: AppColors.error,
                    isUnlocked: state.isAdvancedUnlocked,
                    progress: state.advancedProgress,
                    xpMultiplier: '×2',
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildLevelCard({
    required BuildContext context,
    required WidgetRef ref,
    required String level,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isUnlocked,
    required LevelProgress? progress,
    required String xpMultiplier,
  }) {
    final stars = progress?.stars ?? 0;
    final hasCompleted = progress != null && progress.isCompleted;

    return InkWell(
      onTap: isUnlocked
          ? () {
              // Lógica de despacho dinámico Antigravity
              if (level == 'avanzado') {
                if (categoryId == 2) {
                  // Agentes -> Simulator
                  context.push(
                    '/simulator',
                    extra: {
                      'categoryId': categoryId,
                      'categoryName': subcategoryName,
                      'categoryColor': color,
                    },
                  );
                  return;
                } else if (categoryId == 3) {
                  // Arquitectura -> Code Challenge
                  context.push(
                    '/code-challenge',
                    extra: {
                      'categoryId': categoryId,
                      'categoryName': subcategoryName,
                      'categoryColor': color,
                    },
                  );
                  return;
                } else if (categoryId == 1 || categoryId == 4) {
                  // IA o Orquestación -> Battle Mode
                  context.push(
                    '/battle-mode',
                    extra: {
                      'categoryId': categoryId,
                      'categoryName': subcategoryName,
                      'categoryColor': color,
                    },
                  );
                  return;
                }
              }

              if (level == 'intermedio' && stars == 0) {
                // Primera vez intermedio -> Memory Game como intro
                context.push(
                  '/memory-game',
                  extra: {
                    'categoryId': categoryId,
                    'categoryName': subcategoryName,
                    'categoryColor': color,
                  },
                );
                return;
              }

              // Default: Mission Screen (Quiz interactivo)
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MissionScreen(
                    categoryId: categoryId,
                    subcategoryId: subcategoryId,
                    categoryName: '$subcategoryName — $title',
                    categoryColor: color,
                    selectedLevel: level,
                  ),
                ),
              ).then((_) {
                // Refrescar progreso al volver de la misión
                ref
                    .read(levelSelectorProvider(subcategoryId).notifier)
                    .refresh();
              });
            }
          : null,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isUnlocked ? AppColors.cardBg : AppColors.surfaceBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked
                ? (hasCompleted ? color : color.withOpacity(0.4))
                : AppColors.borderColor,
            width: hasCompleted ? 2 : 1,
          ),
          boxShadow: hasCompleted
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.15),
                    blurRadius: 12,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            // Icono/candado
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isUnlocked
                    ? color.withOpacity(0.15)
                    : AppColors.borderColor.withOpacity(0.3),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                isUnlocked ? icon : Icons.lock,
                size: 28,
                color: isUnlocked ? color : AppColors.textMuted,
              ),
            ),
            const SizedBox(width: 16),
            // Contenido
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          color: isUnlocked
                              ? AppColors.textPrimary
                              : AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Spacer(),
                      // XP multiplier chip
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: isUnlocked
                              ? AppColors.xpGold.withOpacity(0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          xpMultiplier,
                          style: TextStyle(
                            color: isUnlocked
                                ? AppColors.xpGold
                                : AppColors.textMuted,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isUnlocked
                        ? subtitle
                        : 'Completa el nivel anterior para desbloquear',
                    style: TextStyle(
                      color: isUnlocked
                          ? AppColors.textSecondary
                          : AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                  if (isUnlocked) ...[
                    const SizedBox(height: 10),
                    // Estrellas + estado
                    Row(
                      children: [
                        ...List.generate(
                          3,
                          (i) => Padding(
                            padding: const EdgeInsets.only(right: 4),
                            child: Icon(
                              i < stars ? Icons.star : Icons.star_border,
                              size: 20,
                              color: i < stars
                                  ? AppColors.starColor
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          hasCompleted
                              ? 'Mejor: ${progress!.bestPercentage.toStringAsFixed(0)}%'
                              : 'Sin completar',
                          style: TextStyle(
                            color: hasCompleted ? color : AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: hasCompleted
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        const Spacer(),
                        if (hasCompleted)
                          const Text(
                            'Reintentar →',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 11,
                            ),
                          )
                        else
                          Text(
                            'Iniciar →',
                            style: TextStyle(
                              color: color,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
