import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/providers/quiz_provider.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';
import 'package:antigravity_quiz/presentation/screens/results/quiz_results_screen.dart';
import 'package:antigravity_quiz/data/models/quiz_result.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(quizProvider.notifier).loadQuiz(1));
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);

    if (quizState.questions.isEmpty) {
      return const Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
      );
    }

    if (quizState.isFinished) {
      // Calcular resultados reales para la pantalla de trofeo
      int correct = 0;
      quizState.answers.forEach((index, ans) {
        if (ans == quizState.questions[index].correctOption) {
          correct++;
        }
      });

      final result = QuizResult(
        userId: 1,
        subcategoryId: 1,
        level: 'básico',
        score: correct * 15,
        correctCount: correct,
        totalQuestions: quizState.questions.length,
        percentage: correct / quizState.questions.length,
        timeSeconds: 154, // 2:34 ficticio
        completedAt: DateTime.now().toIso8601String(),
        xpEarned: 150,
      );

      return QuizResultsScreen(result: result);
    }

    final currentQuestion = quizState.questions[quizState.currentIndex];

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          'Pregunta ${quizState.currentIndex + 1}/${quizState.questions.length}',
          style: AppTextStyles.body,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value:
                    (quizState.currentIndex + 1) / quizState.questions.length,
                color: AppColors.cyan,
                backgroundColor: AppColors.surfaceBg,
                minHeight: 10,
              ),
            ),
            const SizedBox(height: 60),
            Text(
              currentQuestion.questionText,
              style: AppTextStyles.heading2,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 60),
            ..._buildOptions(ref, currentQuestion),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptions(WidgetRef ref, dynamic question) {
    final options = [
      {'key': 'A', 'text': question.optionA},
      {'key': 'B', 'text': question.optionB},
      {'key': 'C', 'text': question.optionC},
      {'key': 'D', 'text': question.optionD},
    ];

    return options
        .map(
          (opt) => Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () =>
                  ref.read(quizProvider.notifier).submitAnswer(opt['key']!),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.cyan,
                      ),
                      child: Center(
                        child: Text(
                          opt['key']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: Text(opt['text']!, style: AppTextStyles.body),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
