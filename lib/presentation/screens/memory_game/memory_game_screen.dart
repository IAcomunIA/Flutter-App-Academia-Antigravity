import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/memory_game_widget.dart';

/// Pantalla del juego de memoria V2
class MemoryGameScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const MemoryGameScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  bool isCompleted = false;
  int finalErrors = 0;
  int finalTimeSeconds = 0;

  List<MapEntry<String, String>> get _memoryPairs {
    // Pares según categoría
    switch (widget.categoryId) {
      case 1:
        return const [
          MapEntry('Machine Learning', 'Aprende de datos'),
          MapEntry('Deep Learning', 'Redes neuronales profundas'),
          MapEntry('NLP', 'Procesamiento de lenguaje'),
          MapEntry('Computer Vision', 'Análisis de imágenes'),
          MapEntry('GPT', 'Generative Pre-trained Transformer'),
          MapEntry('DALL-E', 'Generación de imágenes'),
          MapEntry('Whisper', 'Transcripción de audio'),
          MapEntry('Context Window', 'Memoria de corto plazo'),
        ];
      case 2:
        return const [
          MapEntry('Agente IA', 'Sistema autónomo'),
          MapEntry('Autonomía', 'Decide sin intervención'),
          MapEntry('Skill', 'Habilidad especializada'),
          MapEntry('SKILL.md', 'Documento de instrucciones'),
          MapEntry('Workflow', 'Pasos para una tarea'),
          MapEntry('Reflection', 'Analiza su propio razonamiento'),
          MapEntry('Roles', 'Especialidad del agente'),
          MapEntry('Toolkit', 'Conjunto de herramientas'),
        ];
      case 3:
        return const [
          MapEntry('Capa 1', 'Maestro / Directiva'),
          MapEntry('Capa 2', 'Orquestador'),
          MapEntry('Capa 3', 'Agentes Ejecutores'),
          MapEntry('Capa 4', 'Observabilidad / Output'),
          MapEntry('Directiva', 'Define el QUÉ'),
          MapEntry('Orquestador', 'Controla el CUÁNDO'),
          MapEntry('Agentes', 'Ejecutan el CÓMO'),
          MapEntry('Validación', 'Verifica el output'),
        ];
      case 4:
        return const [
          MapEntry('Secuencial', 'Uno tras otro'),
          MapEntry('Paralelo', 'Varios simultáneos'),
          MapEntry('Pipeline', 'Cadena de outputs'),
          MapEntry('Fan-out/in', 'Dividir y reunir'),
          MapEntry('Race Condition', 'Conflicto por recursos'),
          MapEntry('Sincronización', 'Coordinar tiempos'),
          MapEntry('Handoff', 'Pasar contexto'),
          MapEntry('Retry', 'Reintento automático'),
        ];
      case 5:
        return const [
          MapEntry('MCP', 'Model Context Protocol'),
          MapEntry('Server', 'Expone herramientas'),
          MapEntry('Resource', 'Dato de lectura'),
          MapEntry('Tool', 'Función ejecutable'),
          MapEntry('Regla Global', 'Restricción general'),
          MapEntry('Logging', 'Registro de actividad'),
          MapEntry('Standard', 'Norma de calidad'),
          MapEntry('MCP Client', 'El que usa las herramientas'),
        ];
      default:
        return const [
          MapEntry('IA', 'Inteligencia Artificial'),
          MapEntry('ML', 'Machine Learning'),
          MapEntry('DL', 'Deep Learning'),
          MapEntry('NLP', 'Lenguaje Natural'),
          MapEntry('CV', 'Computer Vision'),
          MapEntry('LLM', 'Modelo de Lenguaje'),
          MapEntry('API', 'Interfaz de Programa'),
          MapEntry('SDK', 'Kit de Desarrollo'),
        ];
    }
  }

  void _onGameComplete(bool allMatched, int errors, int timeSeconds) {
    setState(() {
      isCompleted = true;
      finalErrors = errors;
      finalTimeSeconds = timeSeconds;
    });
  }

  int get _starsEarned {
    if (finalErrors == 0) return 3;
    if (finalErrors <= 3) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '🧠 Memoria — ${widget.categoryName}',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isCompleted ? _buildResults() : _buildGame(),
    );
  }

  Widget _buildGame() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Encuentra los pares concepto ↔ definición',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
          const SizedBox(height: 20),
          MemoryGameWidget(pairs: _memoryPairs, onComplete: _onGameComplete),
        ],
      ),
    );
  }

  Widget _buildResults() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              finalErrors == 0 ? Icons.emoji_events : Icons.check_circle,
              size: 80,
              color: finalErrors == 0 ? AppColors.xpGold : AppColors.success,
            ),
            const SizedBox(height: 20),
            Text(
              finalErrors == 0 ? '¡PERFECTO!' : '¡COMPLETADO!',
              style: TextStyle(
                color: finalErrors == 0 ? AppColors.xpGold : AppColors.success,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),
            // Estrellas
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: Icon(
                    i < _starsEarned ? Icons.star : Icons.star_border,
                    size: 40,
                    color: AppColors.starColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.cardBg,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _resultRow('Tiempo', '${finalTimeSeconds}s'),
                  const SizedBox(height: 8),
                  _resultRow('Errores', '$finalErrors'),
                  const SizedBox(height: 8),
                  _resultRow(
                    'XP ganado',
                    '+${finalErrors == 0 ? 50 : 30}',
                    valueColor: AppColors.xpGold,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Botones
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.cyan,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
