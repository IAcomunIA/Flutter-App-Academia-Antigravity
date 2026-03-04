import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';

class CodeChallengeScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const CodeChallengeScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<CodeChallengeScreen> createState() => _CodeChallengeScreenState();
}

class _CodeChallengeScreenState extends State<CodeChallengeScreen> {
  int? _selectedLine;
  bool _hasValidated = false;
  final int _correctLine = 3; // El error está en la línea 3

  final List<String> _codeLines = [
    '// Checkpoint: Validación de Salida',
    'Future<void> validate(Output out) async {',
    '  if (out.isValid) {',
    '    await orchestrator.markAsPending(currentCP); // BUG AQUI',
    '  } else {',
    '    await orchestrator.retry(currentCP);',
    '  }',
    '}',
  ];

  void _validate() {
    setState(() {
      _hasValidated = true;
    });

    bool isCorrect = _selectedLine == _correctLine;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isCorrect
              ? '✅ ¡Correcto! El orquestador debería marcar como FIN, no como PENDING.'
              : '❌ Ese no es el error. Busca una contradicción lógica en el flujo.',
        ),
        backgroundColor: isCorrect ? AppColors.success : AppColors.error,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          '💻 Code Challenge — ${widget.categoryName}',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encuentra el error lógico en este flujo del Orquestador:',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.borderColor),
                ),
                child: ListView.builder(
                  itemCount: _codeLines.length,
                  itemBuilder: (context, index) {
                    bool isSelected = _selectedLine == index;
                    bool showCorrect = _hasValidated && index == _correctLine;
                    bool showWrong =
                        _hasValidated && isSelected && index != _correctLine;

                    return GestureDetector(
                      onTap: _hasValidated
                          ? null
                          : () => setState(() => _selectedLine = index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: showCorrect
                              ? AppColors.success.withOpacity(0.2)
                              : showWrong
                              ? AppColors.error.withOpacity(0.2)
                              : isSelected
                              ? Colors.white10
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 30,
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white24,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Text(
                              _codeLines[index],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.white70,
                                fontFamily: 'Courier',
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selectedLine == null || _hasValidated
                    ? null
                    : _validate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Validar Bug',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_hasValidated)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Center(
                    child: Text(
                      'Continuar misión',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
