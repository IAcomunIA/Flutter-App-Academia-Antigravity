import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/fill_blank_widget.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/flow_order_widget.dart';

class ExerciseDispatchScreen extends StatefulWidget {
  final String exerciseType; // 'fill_blank' | 'flow_order'
  final Map<String, dynamic> data;
  final String categoryName;

  const ExerciseDispatchScreen({
    super.key,
    required this.exerciseType,
    required this.data,
    required this.categoryName,
  });

  @override
  State<ExerciseDispatchScreen> createState() => _ExerciseDispatchScreenState();
}

class _ExerciseDispatchScreenState extends State<ExerciseDispatchScreen> {
  bool? _isCorrect;

  void _onComplete(bool correct) {
    setState(() {
      _isCorrect = correct;
    });

    if (correct) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ ¡Misión cumplida! Bonus de XP otorgado.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          '🎯 Ejercicio — ${widget.categoryName}',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Expanded(child: Center(child: _buildExerciseWidget())),
            if (_isCorrect == true)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseWidget() {
    if (widget.exerciseType == 'fill_blank') {
      return FillBlankWidget(
        text: widget.data['text'],
        correctBlanks: List<String>.from(widget.data['blanks']),
        options: List<String>.from(widget.data['options']),
        onComplete: _onComplete,
      );
    } else if (widget.exerciseType == 'flow_order') {
      return FlowOrderWidget(
        items: List<String>.from(widget.data['items']),
        correctOrder: List<int>.from(widget.data['correct_order']),
        onComplete: _onComplete,
      );
    }
    return const Text('Tipo de ejercicio no soportado');
  }
}
