import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

/// Widget para ejercicios de tipo "Completar los huecos" (V2)
/// El texto tiene _____ marcados y un banco de palabras abajo
class FillBlankExercise extends StatefulWidget {
  final String blankText; // Texto con _____ para completar
  final List<String> wordBank; // Banco de palabras disponibles
  final List<String> correctWords; // Respuestas correctas en orden
  final Function(bool isCorrect) onAnswer;

  const FillBlankExercise({
    super.key,
    required this.blankText,
    required this.wordBank,
    required this.correctWords,
    required this.onAnswer,
  });

  @override
  State<FillBlankExercise> createState() => _FillBlankExerciseState();
}

class _FillBlankExerciseState extends State<FillBlankExercise> {
  late List<String?> filledWords; // Palabras insertadas en los huecos
  late List<bool> usedWords; // Marca qué palabras del banco ya se usaron
  bool hasSubmitted = false;
  List<bool>? results; // Resultado por hueco (correcto/incorrecto)

  @override
  void initState() {
    super.initState();
    final blankCount = '___'.allMatches(widget.blankText).length;
    filledWords = List.filled(blankCount, null);
    usedWords = List.filled(widget.wordBank.length, false);
  }

  void _insertWord(int wordIndex) {
    if (hasSubmitted || usedWords[wordIndex]) return;
    // Buscar el primer hueco vacío
    final emptySlot = filledWords.indexOf(null);
    if (emptySlot == -1) return; // Todos llenos

    setState(() {
      filledWords[emptySlot] = widget.wordBank[wordIndex];
      usedWords[wordIndex] = true;
    });
  }

  void _removeWord(int slotIndex) {
    if (hasSubmitted || filledWords[slotIndex] == null) return;
    final word = filledWords[slotIndex]!;
    final bankIndex = widget.wordBank.indexOf(word);

    setState(() {
      filledWords[slotIndex] = null;
      if (bankIndex != -1) usedWords[bankIndex] = false;
    });
  }

  void _submit() {
    if (filledWords.contains(null)) return; // No submit si hay huecos vacíos

    final checkResults = <bool>[];
    for (int i = 0; i < filledWords.length; i++) {
      checkResults.add(
        filledWords[i]?.toLowerCase().trim() ==
            widget.correctWords[i].toLowerCase().trim(),
      );
    }

    setState(() {
      hasSubmitted = true;
      results = checkResults;
    });

    final allCorrect = checkResults.every((r) => r);
    Future.delayed(const Duration(milliseconds: 800), () {
      widget.onAnswer(allCorrect);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Texto con huecos
        _buildTextWithBlanks(),
        const SizedBox(height: 24),

        // Banco de palabras
        const Text(
          'Banco de palabras:',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: List.generate(widget.wordBank.length, (i) {
            final isUsed = usedWords[i];
            return GestureDetector(
              onTap: () => _insertWord(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isUsed
                      ? AppColors.surfaceBg.withOpacity(0.3)
                      : AppColors.surfaceBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isUsed
                        ? AppColors.textMuted
                        : AppColors.cyan.withOpacity(0.5),
                  ),
                ),
                child: Text(
                  widget.wordBank[i],
                  style: TextStyle(
                    color: isUsed ? AppColors.textMuted : AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    decoration: isUsed ? TextDecoration.lineThrough : null,
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 28),

        // Botón confirmar
        if (!hasSubmitted)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: filledWords.contains(null) ? null : _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cyan,
                disabledBackgroundColor: AppColors.surfaceBg,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTextWithBlanks() {
    final parts = widget.blankText.split('___');
    final spans = <InlineSpan>[];

    for (int i = 0; i < parts.length; i++) {
      // Añadir texto normal
      spans.add(
        TextSpan(
          text: parts[i],
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
            height: 2.0,
          ),
        ),
      );

      // Añadir hueco si no es el último segmento
      if (i < filledWords.length) {
        final word = filledWords[i];
        final isCorrect = results != null ? results![i] : null;

        Color bgColor = AppColors.surfaceBg;
        Color borderColor = AppColors.cyan.withOpacity(0.5);
        if (isCorrect == true) {
          bgColor = AppColors.success.withOpacity(0.15);
          borderColor = AppColors.success;
        } else if (isCorrect == false) {
          bgColor = AppColors.error.withOpacity(0.15);
          borderColor = AppColors.error;
        }

        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => _removeWord(i),
              child: Container(
                constraints: const BoxConstraints(minWidth: 80),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: borderColor, width: 1.5),
                ),
                child: Text(
                  word ?? '______',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: word != null
                        ? AppColors.textPrimary
                        : AppColors.textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }

    return RichText(text: TextSpan(children: spans));
  }
}
