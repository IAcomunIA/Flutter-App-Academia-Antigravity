import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';

/// Widget Drag & Drop: empareja items con targets
class DragDropExercise extends StatefulWidget {
  final List<String> items;
  final List<String> targets;
  final List<int> correctOrder;
  final void Function(bool isCorrect) onCompleted;

  const DragDropExercise({
    super.key,
    required this.items,
    required this.targets,
    required this.correctOrder,
    required this.onCompleted,
  });

  @override
  State<DragDropExercise> createState() => _DragDropExerciseState();
}

class _DragDropExerciseState extends State<DragDropExercise> {
  late Map<int, int?> assignments; // target index -> item index
  late List<bool> usedItems;

  @override
  void initState() {
    super.initState();
    assignments = {for (int i = 0; i < widget.targets.length; i++) i: null};
    usedItems = List.filled(widget.items.length, false);
  }

  void _checkAnswer() {
    bool allFilled = assignments.values.every((v) => v != null);
    if (!allFilled) return;

    bool isCorrect = true;
    for (int i = 0; i < widget.targets.length; i++) {
      if (assignments[i] != widget.correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }
    widget.onCompleted(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Items disponibles (drag sources)
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: List.generate(widget.items.length, (i) {
            if (usedItems[i]) return const SizedBox.shrink();
            return Draggable<int>(
              data: i,
              feedback: Material(
                color: Colors.transparent,
                child: _buildChip(widget.items[i], AppColors.cyan, true),
              ),
              childWhenDragging: _buildChip(
                widget.items[i],
                AppColors.textMuted,
                false,
              ),
              child: _buildChip(widget.items[i], AppColors.cyan, true),
            );
          }),
        ),
        const SizedBox(height: 32),
        // Targets (drop zones)
        ...List.generate(widget.targets.length, (targetIdx) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: DragTarget<int>(
              onAcceptWithDetails: (details) {
                setState(() {
                  // Si ya tenía un item, libéralo
                  if (assignments[targetIdx] != null) {
                    usedItems[assignments[targetIdx]!] = false;
                  }
                  assignments[targetIdx] = details.data;
                  usedItems[details.data] = true;
                });
              },
              builder: (context, candidateData, rejectedData) {
                bool hasItem = assignments[targetIdx] != null;
                bool isHovering = candidateData.isNotEmpty;
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isHovering
                        ? AppColors.cyan.withOpacity(0.15)
                        : AppColors.surfaceBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isHovering
                          ? AppColors.cyan
                          : (hasItem
                                ? AppColors.success
                                : AppColors.borderColor),
                      width: isHovering ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.targets[targetIdx],
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: hasItem
                              ? AppColors.cyan.withOpacity(0.2)
                              : AppColors.cardBg,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: hasItem
                                ? AppColors.cyan
                                : AppColors.borderColor,
                          ),
                        ),
                        child: Text(
                          hasItem
                              ? widget.items[assignments[targetIdx]!]
                              : 'Arrastra aquí',
                          style: TextStyle(
                            color: hasItem
                                ? AppColors.cyan
                                : AppColors.textMuted,
                            fontWeight: hasItem
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        }),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: assignments.values.every((v) => v != null)
              ? _checkAnswer
              : null,
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

  Widget _buildChip(String text, Color color, bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: active ? color.withOpacity(0.15) : AppColors.surfaceBg,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: active ? color : AppColors.borderColor),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: active ? color : AppColors.textMuted,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
