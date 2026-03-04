import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/models/exercise.dart';
import 'package:antigravity_quiz/data/exercise_bank.dart';
import 'package:antigravity_quiz/presentation/widgets/drag_drop_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/multi_select_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/command_input_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/ordering_exercise.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';

class MissionScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const MissionScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<MissionScreen> createState() => _MissionScreenState();
}

class _MissionScreenState extends State<MissionScreen>
    with TickerProviderStateMixin {
  late List<Exercise> exercises;
  int currentIndex = 0;
  int correctCount = 0;
  int totalPoints = 0;
  bool showFeedback = false;
  bool lastAnswerCorrect = false;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    exercises = ExerciseBank.getExercisesForCategory(widget.categoryId);
    exercises.shuffle(); // Nunca se repite el orden
  }

  void _handleAnswer(bool isCorrect) {
    // Cerramos el teclado por si estaba abierto (ejercicio de comandos)
    FocusScope.of(context).unfocus();

    setState(() {
      lastAnswerCorrect = isCorrect;
      showFeedback = true;
      if (isCorrect) {
        correctCount++;
        totalPoints += exercises[currentIndex].points;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        showFeedback = false;
        if (currentIndex + 1 < exercises.length) {
          currentIndex++;
        } else {
          isFinished = true;
        }
      });
    });
  }

  void _handleMultipleChoiceAnswer(String option) {
    bool isCorrect = option == exercises[currentIndex].correctOption;
    _handleAnswer(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    if (isFinished) return _buildResultScreen();

    final exercise = exercises[currentIndex];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Icon(
              _getTypeIcon(exercise.type),
              color: widget.categoryColor,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              _getTypeLabel(exercise.type),
              style: TextStyle(
                color: widget.categoryColor,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            Text(
              '${currentIndex + 1}/${exercises.length}',
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Barra de progreso
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: (currentIndex + 1) / exercises.length,
                    color: widget.categoryColor,
                    backgroundColor: AppColors.surfaceBg,
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$correctCount correctas',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      '$totalPoints pts',
                      style: TextStyle(
                        color: AppColors.xpGold,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                // Pregunta
                Text(
                  exercise.questionText,
                  style: AppTextStyles.heading2.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 32),
                // Contenido según tipo
                _buildExerciseContent(exercise),
              ],
            ),
          ),
          // Overlay de feedback
          if (showFeedback) _buildFeedbackOverlay(),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(Exercise exercise) {
    if (showFeedback) return const SizedBox.shrink();

    switch (exercise.type) {
      case ExerciseType.multipleChoice:
        return _buildMultipleChoice(exercise);
      case ExerciseType.dragAndDrop:
        return DragDropExercise(
          items: exercise.items!,
          targets: exercise.targets!,
          correctOrder: exercise.correctOrder!,
          onCompleted: _handleAnswer,
        );
      case ExerciseType.multiSelect:
        return MultiSelectExercise(
          options: exercise.options!,
          correctIndices: exercise.correctIndices!,
          onCompleted: _handleAnswer,
        );
      case ExerciseType.commandInput:
        return CommandInputExercise(
          acceptedAnswers: exercise.acceptedAnswers!,
          hint: exercise.hint,
          onCompleted: _handleAnswer,
        );
      case ExerciseType.ordering:
        return OrderingExercise(
          items: exercise.items!,
          correctOrder: exercise.correctOrder!,
          onCompleted: _handleAnswer,
        );
    }
  }

  Widget _buildMultipleChoice(Exercise exercise) {
    final options = [
      {'key': 'A', 'text': exercise.optionA!},
      {'key': 'B', 'text': exercise.optionB!},
      {'key': 'C', 'text': exercise.optionC!},
      {'key': 'D', 'text': exercise.optionD!},
    ];

    return Column(
      children: options
          .map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () => _handleMultipleChoiceAnswer(opt['key']!),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.cardBg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.borderColor),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: widget.categoryColor.withOpacity(0.15),
                          border: Border.all(
                            color: widget.categoryColor.withOpacity(0.4),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            opt['key']!,
                            style: TextStyle(
                              color: widget.categoryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          opt['text']!,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _buildFeedbackOverlay() {
    return Positioned.fill(
      child: Material(
        color: Colors.black.withOpacity(
          0.8,
        ), // Un poco más oscuro para mejor contraste
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                vertical: 40,
              ), // Espacio para no pegar a bordes
              child: Container(
                margin: const EdgeInsets.all(32),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: lastAnswerCorrect
                        ? AppColors.success
                        : AppColors.error,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          (lastAnswerCorrect
                                  ? AppColors.success
                                  : AppColors.error)
                              .withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      lastAnswerCorrect ? Icons.check_circle : Icons.cancel,
                      size: 72, // Un poco más grande para impacto visual
                      color: lastAnswerCorrect
                          ? AppColors.success
                          : AppColors.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      lastAnswerCorrect ? '¡CORRECTO!' : 'INCORRECTO',
                      style: TextStyle(
                        color: lastAnswerCorrect
                            ? AppColors.success
                            : AppColors.error,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      exercises[currentIndex].explanation,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (lastAnswerCorrect)
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.xpGold.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '+${exercises[currentIndex].points} pts',
                            style: const TextStyle(
                              color: AppColors.xpGold,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    double percentage = exercises.isNotEmpty
        ? (correctCount / exercises.length) * 100
        : 0;
    int stars = percentage >= 90
        ? 3
        : (percentage >= 70 ? 2 : (percentage >= 50 ? 1 : 0));

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(32),
          child: Consumer(
            builder: (context, ref, _) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.military_tech,
                    size: 80,
                    color: AppColors.xpGold,
                  ),
                  const SizedBox(height: 16),
                  Text('¡MISIÓN COMPLETADA!', style: AppTextStyles.heading1),
                  const SizedBox(height: 8),
                  Text(
                    widget.categoryName,
                    style: TextStyle(
                      color: widget.categoryColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Estrellas
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      3,
                      (i) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          i < stars ? Icons.star : Icons.star_border,
                          size: 48,
                          color: i < stars
                              ? AppColors.starColor
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Stats
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.borderColor),
                    ),
                    child: Column(
                      children: [
                        _statRow(
                          'Respuestas correctas',
                          '$correctCount/${exercises.length}',
                        ),
                        const Divider(color: AppColors.borderColor),
                        _statRow(
                          'Precisión',
                          '${percentage.toStringAsFixed(0)}%',
                        ),
                        const Divider(color: AppColors.borderColor),
                        _statRow('Puntos obtenidos', '$totalPoints'),
                        const Divider(color: AppColors.borderColor),
                        _statRow('Estrellas', '⭐' * stars),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      // Sumar XP
                      ref.read(progressProvider.notifier).addXP(totalPoints);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: widget.categoryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'VOLVER A LA BASE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _statRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary)),
          Text(
            value,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getTypeIcon(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice:
        return Icons.quiz;
      case ExerciseType.dragAndDrop:
        return Icons.swap_horiz;
      case ExerciseType.multiSelect:
        return Icons.check_box;
      case ExerciseType.commandInput:
        return Icons.terminal;
      case ExerciseType.ordering:
        return Icons.sort;
    }
  }

  String _getTypeLabel(ExerciseType type) {
    switch (type) {
      case ExerciseType.multipleChoice:
        return 'QUIZ';
      case ExerciseType.dragAndDrop:
        return 'DRAG & DROP';
      case ExerciseType.multiSelect:
        return 'SELECCIÓN';
      case ExerciseType.commandInput:
        return 'COMANDO';
      case ExerciseType.ordering:
        return 'ORDENAR';
    }
  }
}
