import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

class FlowOrderWidget extends StatefulWidget {
  final List<String> items;
  final List<int> correctOrder;
  final Function(bool) onComplete;

  const FlowOrderWidget({
    super.key,
    required this.items,
    required this.correctOrder,
    required this.onComplete,
  });

  @override
  State<FlowOrderWidget> createState() => _FlowOrderWidgetState();
}

class _FlowOrderWidgetState extends State<FlowOrderWidget> {
  late List<String> _currentItems;

  @override
  void initState() {
    super.initState();
    _currentItems = List.from(widget.items)..shuffle();
  }

  void _checkResult() {
    bool isCorrect = true;
    for (int i = 0; i < _currentItems.length; i++) {
      int originalIndex = widget.items.indexOf(_currentItems[i]);
      if (originalIndex != widget.correctOrder[i]) {
        isCorrect = false;
        break;
      }
    }
    widget.onComplete(isCorrect);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          'Reordena los elementos arrastrándolos:',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 400,
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (newIndex > oldIndex) newIndex -= 1;
                final item = _currentItems.removeAt(oldIndex);
                _currentItems.insert(newIndex, item);
              });
            },
            children: [
              for (int i = 0; i < _currentItems.length; i++)
                Container(
                  key: ValueKey(_currentItems[i]),
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
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
                        decoration: BoxDecoration(
                          color: AppColors.surfaceBg,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: const TextStyle(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          _currentItems[i],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.drag_handle,
                        color: AppColors.textSecondary,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _checkResult,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.cyan,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Verificar Orden',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
