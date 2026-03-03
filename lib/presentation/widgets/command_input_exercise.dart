import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget de entrada de comandos / respuesta corta
class CommandInputExercise extends StatefulWidget {
  final List<String> acceptedAnswers;
  final String? hint;
  final void Function(bool isCorrect) onCompleted;

  const CommandInputExercise({
    super.key,
    required this.acceptedAnswers,
    this.hint,
    required this.onCompleted,
  });

  @override
  State<CommandInputExercise> createState() => _CommandInputExerciseState();
}

class _CommandInputExerciseState extends State<CommandInputExercise> {
  final TextEditingController _controller = TextEditingController();

  void _checkAnswer() {
    String input = _controller.text.trim();
    bool isCorrect = widget.acceptedAnswers.any(
      (a) => a.toLowerCase() == input.toLowerCase(),
    );
    widget.onCompleted(isCorrect);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF0D1117),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderColor),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF5F56),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFFBD2E),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 12,
                    height: 12,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF27C93F),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Text(
                    'terminal',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text(
                    '\$ > ',
                    style: TextStyle(
                      color: Color(0xFF27C93F),
                      fontFamily: 'monospace',
                      fontSize: 16,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'monospace',
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: widget.hint ?? 'Escribe tu respuesta...',
                        hintStyle: const TextStyle(
                          color: AppColors.textMuted,
                          fontFamily: 'monospace',
                        ),
                      ),
                      onSubmitted: (_) => _checkAnswer(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton.icon(
          onPressed: _checkAnswer,
          icon: const Icon(Icons.send, color: Colors.white, size: 18),
          label: const Text(
            'EJECUTAR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF27C93F),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}
