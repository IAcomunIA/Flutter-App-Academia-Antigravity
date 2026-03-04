import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/exercise_bank.dart';
import 'package:antigravity_quiz/data/models/exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/battle_hud.dart';

/// Pantalla del Modo Battle V2: quiz rápido contra el tiempo
class BattleModeScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const BattleModeScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<BattleModeScreen> createState() => _BattleModeScreenState();
}

class _BattleModeScreenState extends State<BattleModeScreen>
    with SingleTickerProviderStateMixin {
  static const int maxTimePerQuestion = 8;
  static const int totalBattleQuestions = 10;

  late List<Exercise> questions;
  int currentIndex = 0;
  int timeRemaining = maxTimePerQuestion;
  Timer? timer;
  int correctCount = 0;
  int currentStreak = 0;
  int bestStreak = 0;
  int totalScore = 0;
  bool isFinished = false;
  bool hasAnswered = false;
  String? selectedOption;

  @override
  void initState() {
    super.initState();
    _initQuestions();
    _startTimer();
  }

  void _initQuestions() {
    final allExercises = ExerciseBank.getExercisesForCategory(
      widget.categoryId,
    );
    // Filtrar solo multipleChoice para battle
    questions =
        allExercises
            .where((e) => e.type == ExerciseType.multipleChoice)
            .toList()
          ..shuffle();
    if (questions.length > totalBattleQuestions) {
      questions = questions.sublist(0, totalBattleQuestions);
    }
  }

  void _startTimer() {
    timer?.cancel();
    setState(() {
      timeRemaining = maxTimePerQuestion;
      hasAnswered = false;
      selectedOption = null;
    });

    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        timeRemaining--;
        if (timeRemaining <= 0) {
          t.cancel();
          _handleTimeout();
        }
      });
    });
  }

  void _handleTimeout() {
    HapticFeedback.heavyImpact();
    setState(() {
      currentStreak = 0;
      hasAnswered = true;
    });
    _advanceQuestion();
  }

  void _handleAnswer(String option) {
    if (hasAnswered || isFinished) return;
    timer?.cancel();

    final exercise = questions[currentIndex];
    final isCorrect = option == exercise.correctOption;

    setState(() {
      hasAnswered = true;
      selectedOption = option;

      if (isCorrect) {
        correctCount++;
        currentStreak++;
        if (currentStreak > bestStreak) bestStreak = currentStreak;

        // Calcular score con multiplicador
        int multiplier = 1;
        if (currentStreak >= 5) {
          multiplier = 3;
        } else if (currentStreak >= 3) {
          multiplier = 2;
        }
        totalScore += exercise.points * multiplier;
      } else {
        currentStreak = 0;
        HapticFeedback.mediumImpact();
      }
    });

    _advanceQuestion();
  }

  void _advanceQuestion() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (!mounted) return;
      if (currentIndex + 1 < questions.length) {
        setState(() {
          currentIndex++;
        });
        _startTimer();
      } else {
        timer?.cancel();
        setState(() {
          isFinished = true;
        });
      }
    });
  }

  int get _multiplier {
    if (currentStreak >= 5) return 3;
    if (currentStreak >= 3) return 2;
    return 1;
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished) return _buildResults();

    final exercise = questions[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '⚡ Battle Mode',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textSecondary),
            onPressed: () {
              timer?.cancel();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // HUD
            BattleHud(
              timeRemaining: timeRemaining,
              maxTime: maxTimePerQuestion,
              currentStreak: currentStreak,
              multiplier: _multiplier,
              questionNumber: currentIndex + 1,
              totalQuestions: questions.length,
            ),
            const SizedBox(height: 24),

            // Pregunta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    exercise.questionText,
                    style: AppTextStyles.heading2.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 24),

                  // Opciones
                  ...['A', 'B', 'C', 'D'].map((opt) {
                    String? text;
                    switch (opt) {
                      case 'A':
                        text = exercise.optionA;
                        break;
                      case 'B':
                        text = exercise.optionB;
                        break;
                      case 'C':
                        text = exercise.optionC;
                        break;
                      case 'D':
                        text = exercise.optionD;
                        break;
                    }
                    if (text == null) return const SizedBox.shrink();

                    final isSelected = selectedOption == opt;
                    final isCorrect = opt == exercise.correctOption;
                    Color borderColor = AppColors.borderColor;
                    Color bgColor = AppColors.cardBg;

                    if (hasAnswered) {
                      if (isCorrect) {
                        borderColor = AppColors.success;
                        bgColor = AppColors.success.withOpacity(0.1);
                      } else if (isSelected && !isCorrect) {
                        borderColor = AppColors.error;
                        bgColor = AppColors.error.withOpacity(0.1);
                      }
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        onTap: () => _handleAnswer(opt),
                        borderRadius: BorderRadius.circular(14),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: bgColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: borderColor, width: 1.5),
                          ),
                          child: Text(
                            text,
                            style: TextStyle(
                              color: hasAnswered && isCorrect
                                  ? AppColors.success
                                  : AppColors.textPrimary,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResults() {
    final percentage = questions.isEmpty
        ? 0.0
        : (correctCount / questions.length * 100);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                percentage >= 70 ? Icons.emoji_events : Icons.sports_score,
                size: 80,
                color: percentage >= 70 ? AppColors.xpGold : AppColors.cyan,
              ),
              const SizedBox(height: 20),
              Text(
                '¡BATALLA COMPLETADA!',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              // Stats grid
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _resultRow(
                      'Correctas',
                      '$correctCount/${questions.length}',
                    ),
                    const Divider(color: AppColors.borderColor, height: 20),
                    _resultRow('Mejor racha', '${bestStreak}🔥'),
                    const Divider(color: AppColors.borderColor, height: 20),
                    _resultRow(
                      'Score total',
                      '$totalScore pts',
                      valueColor: AppColors.xpGold,
                    ),
                    const Divider(color: AppColors.borderColor, height: 20),
                    _resultRow(
                      'XP ganado',
                      '+${(totalScore * 0.5).round()}',
                      valueColor: AppColors.xpGold,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Botones
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                      correctCount = 0;
                      currentStreak = 0;
                      bestStreak = 0;
                      totalScore = 0;
                      isFinished = false;
                    });
                    _initQuestions();
                    _startTimer();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    '⚡ Reintentar',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Volver',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
