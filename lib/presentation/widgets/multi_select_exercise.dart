import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget de selección múltiple: seleccionar todas las respuestas correctas
class MultiSelectExercise extends StatefulWidget {
  final List<String> options;
  final List<int> correctIndices;
  final void Function(bool isCorrect) onCompleted;

  const MultiSelectExercise({
    super.key,
    required this.options,
    required this.correctIndices,
    required this.onCompleted,
  });

  @override
  State<MultiSelectExercise> createState() => _MultiSelectExerciseState();
}

class _MultiSelectExerciseState extends State<MultiSelectExercise> {
  final Set<int> selected = {};

  void _checkAnswer() {
    bool isCorrect =
        selected.length == widget.correctIndices.length &&
        widget.correctIndices.every((i) => selected.contains(i));
    widget.onCompleted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ...List.generate(widget.options.length, (i) {
          bool isSelected = selected.contains(i);
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selected.remove(i);
                  } else {
                    selected.add(i);
                  }
                });
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.cyan.withOpacity(0.15)
                      : AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.cyan : AppColors.borderColor,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.cyan : Colors.transparent,
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.cyan
                              : AppColors.textMuted,
                        ),
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        widget.options[i],
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.textPrimary
                              : AppColors.textSecondary,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: selected.isNotEmpty ? _checkAnswer : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.cyan,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'VERIFICAR',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
