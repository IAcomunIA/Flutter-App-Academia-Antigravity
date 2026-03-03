import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget de ordenamiento: reordenar pasos arrastrando
class OrderingExercise extends StatefulWidget {
  final List<String> items;
  final List<int> correctOrder;
  final void Function(bool isCorrect) onCompleted;

  const OrderingExercise({
    super.key,
    required this.items,
    required this.correctOrder,
    required this.onCompleted,
  });

  @override
  State<OrderingExercise> createState() => _OrderingExerciseState();
}

class _OrderingExerciseState extends State<OrderingExercise> {
  late List<String> currentOrder;

  @override
  void initState() {
    super.initState();
    currentOrder = List.from(widget.items);
    currentOrder.shuffle();
  }

  void _checkAnswer() {
    bool isCorrect = true;
    for (int i = 0; i < currentOrder.length; i++) {
      if (currentOrder[i] != widget.items[widget.correctOrder[i]]) {
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
        const Text(
          'Arrastra para reordenar:',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 16),
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: currentOrder.length,
          onReorder: (oldIndex, newIndex) {
            setState(() {
              if (newIndex > oldIndex) newIndex--;
              final item = currentOrder.removeAt(oldIndex);
              currentOrder.insert(newIndex, item);
            });
          },
          itemBuilder: (context, i) {
            return Container(
              key: ValueKey('$i-${currentOrder[i]}'),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.purple.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '${i + 1}',
                        style: const TextStyle(
                          color: AppColors.purple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      currentOrder[i],
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const Icon(Icons.drag_handle, color: AppColors.textMuted),
                ],
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _checkAnswer,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.purple,
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'VERIFICAR ORDEN',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
