import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/providers/quiz_provider.dart';
import 'package:antigravity_quiz/presentation/providers/progress_provider.dart';

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

  void _finishQuiz() {
    // Al terminar el primer módulo (ID 1), desbloqueamos el segundo (ID 2)
    ref.read(progressProvider.notifier).unlockCategory(2);
    ref.read(progressProvider.notifier).addXP(250);
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.success,
        content: Text('¡Nivel 2 desbloqueado! Revisa tu base.'),
      ),
    );
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
      return Scaffold(
        backgroundColor: AppColors.darkBg,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars, size: 80, color: AppColors.starColor),
              const SizedBox(height: 24),
              Text('¡MISIÓN COMPLETADA!', style: AppTextStyles.heading1),
              const SizedBox(height: 12),
              Text(
                'Has ganado 250 XP y desbloqueado el siguiente nivel',
                style: AppTextStyles.bodySecondary,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: _finishQuiz,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'VOLVER A LA BASE',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
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
