import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/models/quiz_result.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

class QuizResultsScreen extends ConsumerWidget {
  final QuizResult result;

  const QuizResultsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProgress = ref.watch(progressProvider);

    // Cálculos ficticios para el ejemplo basados en la imagen
    final correctXP = result.correctCount * 15;
    final streakXP = result.percentage == 1.0 ? 30 : 0;
    final velocityXP = 30; // Supongamos bono fijo
    final totalXPGot = correctXP + streakXP + velocityXP;

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Stack(
        children: [
          _buildStarField(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),

                  // Top Bar
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: AppColors.cyan.withOpacity(0.5),
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.flash_on,
                              color: AppColors.cyan,
                              size: 14,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'QUIZ MODE',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'IA Fundamentos · Básico',
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // Hero Area
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.cyan.withOpacity(0.15),
                                blurRadius: 60,
                                spreadRadius: 20,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            const Icon(
                                  Icons.workspace_premium,
                                  color: Colors.orange,
                                  size: 60,
                                )
                                .animate(
                                  onPlay: (controller) =>
                                      controller.repeat(reverse: true),
                                )
                                .scale(
                                  delay: 400.ms,
                                  duration: 600.ms,
                                  curve: Curves.elasticOut,
                                )
                                .moveY(
                                  begin: 10,
                                  end: -10,
                                  duration: 2000.ms,
                                  curve: Curves.easeInOut,
                                ),
                            Image.asset(
                                  'assets/images/astronauta_personaje_con_casco_flotando.png',
                                  height: 240,
                                )
                                .animate()
                                .fade(duration: 800.ms)
                                .slideY(begin: 0.1, end: 0),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Títulos
                  Text(
                    '¡PERFECTO!',
                    style: AppTextStyles.heading1.copyWith(
                      fontSize: 42,
                      color: AppColors.starColor,
                      shadows: [
                        Shadow(
                          color: AppColors.starColor.withOpacity(0.5),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                  ).animate().scale(
                    duration: 500.ms,
                    curve: Curves.easeOutBack,
                  ),

                  const Text(
                    'Misión completada sin errores. Leyenda.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // XP Main Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          const Color(0xFF1E3A8A).withOpacity(0.4),
                          const Color(0xFF0F172A),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: AppColors.cyan.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'EXPERIENCIA GANADA',
                          style: AppTextStyles.caption.copyWith(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '+$totalXPGot',
                              style: AppTextStyles.heading1.copyWith(
                                fontSize: 48,
                                color: Colors.orange,
                                shadows: [
                                  Shadow(
                                    color: Colors.orange.withOpacity(0.5),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'XP',
                              style: AppTextStyles.heading2.copyWith(
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Divider(color: Colors.white10),
                        const SizedBox(height: 16),
                        _buildXPLine(
                          'Respuestas correctas ${result.correctCount}/${result.totalQuestions}',
                          '+$correctXP XP',
                        ),
                        _buildXPLine('Racha perfecta x2', '+$streakXP XP'),
                        _buildXPLine('Bono de Velocidad', '+$velocityXP XP'),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'NIVEL 1 · RECLUTA',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${userProgress.totalXP} / ${userProgress.totalXP + 150} XP',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.cyan,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: const LinearProgressIndicator(
                            value: 0.85,
                            backgroundColor: Colors.white10,
                            color: AppColors.cyan,
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatItem(
                          'PRECISIÓN',
                          '${(result.percentage * 100).toInt()}%',
                          AppColors.cyan,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatItem('TIEMPO', '2:34', Colors.white),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatItem('RACHA', 'x3 🔥', Colors.orange),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // New Badge Section
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.white.withOpacity(0.05)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'NUEVA INSIGNIA',
                                style: AppTextStyles.caption.copyWith(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                              Text(
                                'Primer Despegue',
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('+50 XP bonus', style: AppTextStyles.caption),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Main Actions
                  ElevatedButton(
                    onPressed: () => context.go('/'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.cyan,
                      foregroundColor: Colors.black,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 10,
                      shadowColor: AppColors.cyan.withOpacity(0.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.play_arrow, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'SIGUIENTE LECCIÓN',
                          style: AppTextStyles.heading2.copyWith(
                            fontSize: 16,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white10),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'REINTENTAR',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white10),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'COMPARTIR',
                            style: AppTextStyles.bodySecondary.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildXPLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.heading2.copyWith(fontSize: 18, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildStarField() {
    return Stack(
      children: List.generate(30, (i) {
        final top = (i * 35.0) % 800;
        final left = (i * 70.0) % 400;
        final size = (i % 3) + 1.0;
        return Positioned(
          top: top,
          left: left,
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.4),
              shape: BoxShape.circle,
            ),
          ),
        );
      }),
    );
  }
}
