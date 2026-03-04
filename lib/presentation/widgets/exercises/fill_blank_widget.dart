import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

class FillBlankWidget extends StatefulWidget {
  final String text;
  final List<String> correctBlanks;
  final List<String> options;
  final Function(bool) onComplete;

  const FillBlankWidget({
    super.key,
    required this.text,
    required this.correctBlanks,
    required this.options,
    required this.onComplete,
  });

  @override
  State<FillBlankWidget> createState() => _FillBlankWidgetState();
}

class _FillBlankWidgetState extends State<FillBlankWidget> {
  final List<String?> _userAnswers = [];
  late List<String> _shuffledOptions;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.correctBlanks.length; i++) {
      _userAnswers.add(null);
    }
    _shuffledOptions = List.from(widget.options)..shuffle();
  }

  void _onOptionTap(String option) {
    setState(() {
      int emptyIndex = _userAnswers.indexOf(null);
      if (emptyIndex != -1) {
        _userAnswers[emptyIndex] = option;
      }
    });

    if (!_userAnswers.contains(null)) {
      _checkResult();
    }
  }

  void _onAnswerTap(int index) {
    setState(() {
      _userAnswers[index] = null;
    });
  }

  void _checkResult() {
    bool isCorrect = true;
    for (int i = 0; i < widget.correctBlanks.length; i++) {
      if (_userAnswers[i] != widget.correctBlanks[i]) {
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
        _buildSentence(),
        const SizedBox(height: 32),
        const Text(
          'Opciones disponibles:',
          style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
        const SizedBox(height: 12),
        _buildOptions(),
      ],
    );
  }

  Widget _buildSentence() {
    final parts = widget.text.split('_____');
    List<Widget> spans = [];

    for (int i = 0; i < parts.length; i++) {
      spans.add(
        Text(
          parts[i],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            height: 1.8,
          ),
        ),
      );

      if (i < widget.correctBlanks.length) {
        final answer = _userAnswers[i];
        spans.add(
          GestureDetector(
            onTap: () => _onAnswerTap(i),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: answer == null
                    ? Colors.white10
                    : AppColors.cyan.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: answer == null ? Colors.white24 : AppColors.cyan,
                  width: 1,
                ),
              ),
              child: Text(
                answer ?? '        ',
                style: const TextStyle(
                  color: AppColors.cyan,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
      }
    }

    return Wrap(
      alignment: WrapAlignment.center,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: spans,
    );
  }

  Widget _buildOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _shuffledOptions.map((opt) {
        final isUsed = _userAnswers.contains(opt);
        return GestureDetector(
          onTap: isUsed ? null : () => _onOptionTap(opt),
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isUsed ? 0.3 : 1.0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Text(
                opt,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
