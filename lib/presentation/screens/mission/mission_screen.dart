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
import 'package:antigravity_quiz/data/models/level_progress.dart';
import 'package:antigravity_quiz/data/repositories/quiz_repository.dart';
import 'package:intl/intl.dart';

class MissionScreen extends StatefulWidget {
  final int categoryId;
  final int? subcategoryId;
  final String categoryName;
  final Color categoryColor;
  final String? selectedLevel;

  const MissionScreen({
    super.key,
    required this.categoryId,
    this.subcategoryId,
    required this.categoryName,
    required this.categoryColor,
    this.selectedLevel,
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

  late AnimationController _feedbackTimerController;
  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();
    exercises = ExerciseBank.getExercisesForCategory(widget.categoryId);
    exercises.shuffle(); // Nunca se repite el orden

    _feedbackTimerController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              _dismissFeedback();
            }
          });
  }

  @override
  void dispose() {
    _feedbackTimerController.dispose();
    super.dispose();
  }

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

    // Iniciar auto-dismiss visual
    _feedbackTimerController.forward(from: 0.0);
  }

  void _dismissFeedback() {
    if (!_showFeedback) return;
    _feedbackTimerController.stop();
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
    if (isFinished) {
      return Consumer(
        builder: (context, ref, _) => _buildResultScreen(ref),
      );
    }

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
        return _buildDragDropWithShuffle(exercise);
      case ExerciseType.multiSelect:
        return _buildMultiSelectWithShuffle(exercise);
      case ExerciseType.commandInput:
        return CommandInputExercise(
          acceptedAnswers: exercise.acceptedAnswers!,
          hint: exercise.hint,
          onCompleted: _handleAnswer,
        );
      case ExerciseType.ordering:
        return _buildOrderingWithShuffle(exercise);
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
    final correctOptionKey = exercise.correctOption ?? 'A';
    
    final Map<String, String> optionTexts = {
      'A': exercise.optionA ?? '',
      'B': exercise.optionB ?? '',
      'C': exercise.optionC ?? '',
      'D': exercise.optionD ?? '',
    };
    
    final correctAnswerText = optionTexts[correctOptionKey] ?? '';
    
    var options = [
      {'key': 'A', 'text': optionTexts['A']!},
      {'key': 'B', 'text': optionTexts['B']!},
      {'key': 'C', 'text': optionTexts['C']!},
      {'key': 'D', 'text': optionTexts['D']!},
    ];
    
    options.shuffle();
    
    String shuffledCorrectKey = 'A';
    for (var opt in options) {
      if (opt['text'] == correctAnswerText) {
        shuffledCorrectKey = opt['key']!;
        break;
      }
    }

    return Column(
      children: options
          .map(
            (opt) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: InkWell(
                onTap: () {
                  final isCorrect = opt['text'] == correctAnswerText;
                  _handleMultipleChoiceAnswer(isCorrect ? shuffledCorrectKey : opt['key']!);
                },
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
          const SizedBox(height: 16),
          // Barra de tiempo retrocediendo
          AnimatedBuilder(
            animation: _feedbackTimerController,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(2),
                child: LinearProgressIndicator(
                  value: 1.0 - _feedbackTimerController.value,
                  backgroundColor: AppColors.surfaceBg,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    lastAnswerCorrect ? AppColors.success : AppColors.error,
                  ),
                  minHeight: 4,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultScreen(WidgetRef ref) {
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
          child: Column(
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
                onPressed: () async {
                  final repository = QuizRepository();
                  final userId = 1;

                  String levelKey = widget.selectedLevel ?? 'basico';
                  if (levelKey.isEmpty) {
                    final nameLower = widget.categoryName.toLowerCase();
                    if (nameLower.contains('intermedio')) {
                      levelKey = 'intermedio';
                    } else if (nameLower.contains('avanzado')) {
                      levelKey = 'avanzado';
                    } else {
                      levelKey = 'basico';
                    }
                  }

                  final progress = LevelProgress(
                    userId: userId,
                    subcategoryId:
                        widget.subcategoryId ?? widget.categoryId,
                    level: levelKey,
                    stars: stars,
                    bestScore: totalPoints,
                    bestPercentage: percentage,
                    completedAt: DateFormat(
                      'yyyy-MM-dd HH:mm',
                    ).format(DateTime.now()),
                  );

                  await repository.saveLevelProgress(progress);

                  if (mounted) {
                    final progressNotifier = ref.read(progressProvider.notifier);
                    progressNotifier.addXP(totalPoints);

                    String nextLevel = '';
                    if (levelKey == 'basico') {
                      nextLevel = 'Intermedio';
                    } else if (levelKey == 'intermedio') {
                      nextLevel = 'Avanzado';
                    }

                    if (stars >= 1 && nextLevel.isNotEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            '✨ ¡Progreso guardado! Nivel $nextLevel disponible.',
                          ),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    } else if (stars >= 1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('✨ ¡Progreso guardado!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }

                    Navigator.pop(context);
                  }
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

  Widget _buildDragDropWithShuffle(Exercise exercise) {
    final items = List<String>.from(exercise.items!);
    final targets = List<String>.from(exercise.targets!);
    final correctOrder = List<int>.from(exercise.correctOrder!);
    
    final indices = List.generate(items.length, (i) => i);
    indices.shuffle();
    
    final shuffledItems = indices.map((i) => items[i]).toList();
    final Map<int, int> originalToShuffled = {};
    final Map<int, int> shuffledToOriginal = {};
    for (int i = 0; i < indices.length; i++) {
      originalToShuffled[indices[i]] = i;
      shuffledToOriginal[i] = indices[i];
    }
    final shuffledCorrectOrder = correctOrder.map((i) => originalToShuffled[i] ?? i).toList();
    
    return DragDropExercise(
      items: shuffledItems,
      targets: targets,
      correctOrder: shuffledCorrectOrder,
      onCompleted: _handleAnswer,
    );
  }

  Widget _buildMultiSelectWithShuffle(Exercise exercise) {
    final options = List<String>.from(exercise.options!);
    final correctIndices = List<int>.from(exercise.correctIndices!);
    
    options.shuffle();
    
    final oldToNew = <int, int>{};
    final originalIndices = List.generate(exercise.options!.length, (i) => i);
    originalIndices.shuffle();
    for (int i = 0; i < originalIndices.length; i++) {
      oldToNew[originalIndices[i]] = i;
    }
    final newCorrectIndices = correctIndices.map((i) => oldToNew[i] ?? i).toList();
    
    return MultiSelectExercise(
      options: options,
      correctIndices: newCorrectIndices,
      onCompleted: _handleAnswer,
    );
  }

  Widget _buildOrderingWithShuffle(Exercise exercise) {
    final items = List<String>.from(exercise.items!);
    final correctOrder = List<int>.from(exercise.correctOrder!);
    
    items.shuffle();
    
    final indices = List.generate(exercise.items!.length, (i) => i);
    indices.shuffle();
    final oldToNew = <int, int>{};
    for (int i = 0; i < indices.length; i++) {
      oldToNew[indices[i]] = i;
    }
    final newCorrectOrder = correctOrder.map((i) => oldToNew[i] ?? i).toList();
    
    return FlowOrderWidget(
      items: items,
      correctOrder: newCorrectOrder,
      onComplete: _handleAnswer,
    );
  }
}
