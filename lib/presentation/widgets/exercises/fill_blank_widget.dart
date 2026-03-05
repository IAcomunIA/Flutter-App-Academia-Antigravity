import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget para completar huecos en un texto.
/// El texto debe contener marcadores _____ donde van las respuestas.
class FillBlankWidget extends StatefulWidget {
  final String text;
  final List<String> correctBlanks; // Respuestas correctas en orden
  final List<String> options; // Opciones disponibles (incluye distractores)
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
  late List<String?> _userAnswers;
  late List<String> _shuffledOptions;
  bool _hasChecked = false;
  bool _isCorrect = false;
  int _activeBlankIndex = 0;

  @override
  void initState() {
    super.initState();
    _userAnswers = List.filled(widget.correctBlanks.length, null);
    _shuffledOptions = List.from(widget.options)..shuffle();

    // Encontrar el primer blank vacío
    _activeBlankIndex = 0;
  }

  void _onOptionTap(String option) {
    if (_hasChecked) return;

    setState(() {
      // Colocar en el blank activo
      if (_activeBlankIndex < _userAnswers.length) {
        _userAnswers[_activeBlankIndex] = option;

        // Avanzar al siguiente blank vacío
        _moveToNextBlank();
      }
    });

    // Verificar si todos están llenos
    if (!_userAnswers.contains(null)) {
      _checkResult();
    }
  }

  void _moveToNextBlank() {
    for (int i = 0; i < _userAnswers.length; i++) {
      if (_userAnswers[i] == null) {
        _activeBlankIndex = i;
        return;
      }
    }
    _activeBlankIndex = _userAnswers.length; // Todos llenos
  }

  void _onBlankTap(int index) {
    if (_hasChecked) return;
    if (_userAnswers[index] != null) {
      setState(() {
        _userAnswers[index] = null;
        _activeBlankIndex = index;
      });
    }
  }

  void _checkResult() {
    bool correct = true;
    for (int i = 0; i < widget.correctBlanks.length; i++) {
      if (_userAnswers[i]?.toLowerCase().trim() !=
          widget.correctBlanks[i].toLowerCase().trim()) {
        correct = false;
        break;
      }
    }

    setState(() {
      _hasChecked = true;
      _isCorrect = correct;
    });

    // Pequeño delay para que el usuario vea el feedback visual
    Future.delayed(const Duration(milliseconds: 600), () {
      widget.onComplete(correct);
    });
  }

  void _resetAnswers() {
    setState(() {
      _userAnswers = List.filled(widget.correctBlanks.length, null);
      _activeBlankIndex = 0;
      _hasChecked = false;
      _isCorrect = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Instrucción
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.purple.withOpacity(0.2)),
            ),
            child: const Row(
              children: [
                Icon(Icons.edit_note, color: AppColors.purpleLight, size: 20),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Completa la oración tocando las palabras correctas',
                    style: TextStyle(
                      color: AppColors.purpleLight,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // La oración con blanks
          _buildSentenceWithBlanks(),

          const SizedBox(height: 32),

          // Opciones
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'BANCO DE PALABRAS',
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                _buildOptions(),
              ],
            ),
          ),

          // Botón de reset si ya se verificó y fue incorrecto
          if (_hasChecked && !_isCorrect) ...[
            const SizedBox(height: 16),
            Center(
              child: TextButton.icon(
                onPressed: _resetAnswers,
                icon: const Icon(
                  Icons.refresh,
                  color: AppColors.cyan,
                  size: 18,
                ),
                label: const Text(
                  'Reintentar',
                  style: TextStyle(color: AppColors.cyan),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSentenceWithBlanks() {
    final parts = widget.text.split('_____');
    List<InlineSpan> spans = [];

    for (int i = 0; i < parts.length; i++) {
      // Texto normal
      if (parts[i].isNotEmpty) {
        spans.add(
          TextSpan(
            text: parts[i],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              height: 2.0,
            ),
          ),
        );
      }

      // Blank interactivo
      if (i < widget.correctBlanks.length) {
        final answer = _userAnswers[i];
        final isActive = i == _activeBlankIndex && !_hasChecked;
        final isCorrectAnswer =
            _hasChecked &&
            answer?.toLowerCase().trim() ==
                widget.correctBlanks[i].toLowerCase().trim();
        final isWrongAnswer = _hasChecked && !isCorrectAnswer && answer != null;

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _onBlankTap(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: isCorrectAnswer
                      ? AppColors.success.withOpacity(0.15)
                      : isWrongAnswer
                      ? AppColors.error.withOpacity(0.15)
                      : isActive
                      ? AppColors.cyan.withOpacity(0.15)
                      : answer != null
                      ? AppColors.cyan.withOpacity(0.1)
                      : Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCorrectAnswer
                        ? AppColors.success
                        : isWrongAnswer
                        ? AppColors.error
                        : isActive
                        ? AppColors.cyan
                        : answer != null
                        ? AppColors.cyan.withOpacity(0.5)
                        : Colors.white24,
                    width: isActive ? 2 : 1,
                  ),
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: AppColors.cyan.withOpacity(0.15),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isCorrectAnswer)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.check,
                          color: AppColors.success,
                          size: 14,
                        ),
                      ),
                    if (isWrongAnswer)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.close,
                          color: AppColors.error,
                          size: 14,
                        ),
                      ),
                    Text(
                      answer ?? '          ',
                      style: TextStyle(
                        color: isCorrectAnswer
                            ? AppColors.success
                            : isWrongAnswer
                            ? AppColors.error
                            : AppColors.cyan,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceBg.withOpacity(0.5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: RichText(
        text: TextSpan(children: spans),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _buildOptions() {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: _shuffledOptions.map((opt) {
        final isUsed = _userAnswers.contains(opt);
        return GestureDetector(
          onTap: isUsed || _hasChecked ? null : () => _onOptionTap(opt),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUsed
                  ? AppColors.surfaceBg.withOpacity(0.3)
                  : AppColors.surfaceBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isUsed
                    ? AppColors.borderColor.withOpacity(0.3)
                    : AppColors.cyan.withOpacity(0.3),
              ),
            ),
            child: Text(
              opt,
              style: TextStyle(
                color: isUsed ? AppColors.textMuted : Colors.white,
                fontSize: 14,
                fontWeight: isUsed ? FontWeight.normal : FontWeight.w500,
                decoration: isUsed ? TextDecoration.lineThrough : null,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
