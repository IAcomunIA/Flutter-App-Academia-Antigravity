import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/models/exercise.dart';
import 'package:antigravity_quiz/data/exercise_bank.dart';
import 'package:antigravity_quiz/presentation/widgets/drag_drop_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/multi_select_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/command_input_exercise.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/fill_blank_widget.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/flow_order_widget.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';

class MissionScreen extends StatefulWidget {
  final int categoryId;
  final int? subcategoryId;
  final String categoryName;
  final Color categoryColor;

  const MissionScreen({
    super.key,
    required this.categoryId,
    this.subcategoryId,
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
  bool lastAnswerCorrect = false;
  bool isFinished = false;

  @override
  void initState() {
    super.initState();
    exercises = ExerciseBank.getExercisesForCategory(widget.categoryId);
    exercises.shuffle(); // Nunca se repite el orden
  }

  bool _showFeedback = false;

  void _handleAnswer(bool isCorrect) {
    if (_showFeedback) return; // Evitar múltiples respuestas
    FocusScope.of(context).unfocus();

    setState(() {
      lastAnswerCorrect = isCorrect;
      _showFeedback = true; // Activar el overlay local
      if (isCorrect) {
        correctCount++;
        totalPoints += exercises[currentIndex].points;
      }
    });

    // Auto-dismiss mejorado
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _dismissFeedback();
    });
  }

  void _dismissFeedback() {
    if (!_showFeedback) return;
    setState(() {
      _showFeedback = false;
      if (currentIndex + 1 < exercises.length) {
        currentIndex++;
      } else {
        isFinished = true;
      }
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

          // OVERLAY DE FEEDBACK (Sustituye al Dialog)
          if (_showFeedback)
            Positioned.fill(
              child: GestureDetector(
                onTap: _dismissFeedback,
                child: Container(
                  color: Colors.black.withOpacity(0.85),
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Center(child: _buildFeedbackOverlay()),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildExerciseContent(Exercise exercise) {
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
        return FlowOrderWidget(
          items: exercise.items!,
          correctOrder: exercise.correctOrder!,
          onComplete: _handleAnswer,
        );
      case ExerciseType.fillBlank:
        return FillBlankWidget(
          text: exercise.questionText,
          correctBlanks: exercise.items ?? [],
          options: exercise.options ?? [],
          onComplete: _handleAnswer,
        );
      case ExerciseType.memory:
      case ExerciseType.battle:
      case ExerciseType.simulator:
      case ExerciseType.codeChallenge:
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.rocket_launch,
                size: 64,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 16),
              const Text(
                'Misión de Modo Especial',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Sal de la misión y usa el menú principal\npara ejecutar este desafío avanzado.',
                textAlign: TextAlign.center,
                style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.surfaceBg,
                ),
                child: const Text('Volver a la base'),
              ),
            ],
          ),
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
    return Container(
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: lastAnswerCorrect ? AppColors.success : AppColors.error,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (lastAnswerCorrect ? AppColors.success : AppColors.error)
                .withOpacity(0.3),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            lastAnswerCorrect ? Icons.check_circle : Icons.cancel,
            size: 80,
            color: lastAnswerCorrect ? AppColors.success : AppColors.error,
          ),
          const SizedBox(height: 20),
          Text(
            lastAnswerCorrect ? '¡CORRECTO!' : 'INCORRECTO',
            style: TextStyle(
              color: lastAnswerCorrect ? AppColors.success : AppColors.error,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            exercises[currentIndex].explanation,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          if (lastAnswerCorrect)
            Padding(
              padding: const EdgeInsets.only(top: 24),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.xpGold.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '+${exercises[currentIndex].points} pts',
                  style: const TextStyle(
                    color: AppColors.xpGold,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          // Botón opcional para skip manual
          Text(
            'Toca para continuar',
            style: TextStyle(
              color: AppColors.textSecondary.withOpacity(0.5),
              fontSize: 12,
            ),
          ),
        ],
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
      case ExerciseType.fillBlank:
        return Icons.edit_note;
      case ExerciseType.memory:
        return Icons.grid_view;
      case ExerciseType.battle:
        return Icons.whatshot;
      case ExerciseType.simulator:
        return Icons.account_tree;
      case ExerciseType.codeChallenge:
        return Icons.code;
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
      case ExerciseType.fillBlank:
        return 'COMPLETAR';
      case ExerciseType.memory:
        return 'MEMORIA';
      case ExerciseType.battle:
        return 'BATTLE';
      case ExerciseType.simulator:
        return 'SIMULADOR';
      case ExerciseType.codeChallenge:
        return 'CÓDIGO';
    }
  }
}
