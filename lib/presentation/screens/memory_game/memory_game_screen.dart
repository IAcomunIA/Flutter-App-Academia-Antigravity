import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/presentation/widgets/memory_game_widget.dart';

/// Pantalla del juego de memoria con 3 niveles
/// Básico = iconos, Intermedio = mixto, Avanzado = texto
class MemoryGameScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;
  final String level; // 'basico' | 'intermedio' | 'avanzado'

  const MemoryGameScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
    this.level = 'intermedio',
  });

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  bool isCompleted = false;
  int finalErrors = 0;
  int finalTimeSeconds = 0;

  MemoryGameMode get _mode {
    switch (widget.level) {
      case 'basico':
        return MemoryGameMode.icon;
      case 'intermedio':
        return MemoryGameMode.mixed;
      case 'avanzado':
        return MemoryGameMode.text;
      default:
        return MemoryGameMode.mixed;
    }
  }

  String get _levelLabel {
    switch (widget.level) {
      case 'basico':
        return '🟢 BÁSICO — Visual';
      case 'intermedio':
        return '🟡 INTERMEDIO — Mixto';
      case 'avanzado':
        return '🔴 AVANZADO — Texto';
      default:
        return 'MEMORIA';
    }
  }

  List<MemoryPairData> get _memoryPairs {
    switch (widget.categoryId) {
      case 1: // IA Fundamentos
        return const [
          MemoryPairData(
            concept: 'Machine Learning',
            definition: 'Aprende de datos',
            icon: Icons.auto_graph,
            color: AppColors.catAI,
          ),
          MemoryPairData(
            concept: 'Deep Learning',
            definition: 'Redes neuronales profundas',
            icon: Icons.hub,
            color: AppColors.catAI,
          ),
          MemoryPairData(
            concept: 'NLP',
            definition: 'Procesamiento de lenguaje',
            icon: Icons.translate,
            color: AppColors.catAI,
          ),
          MemoryPairData(
            concept: 'Computer Vision',
            definition: 'Análisis de imágenes',
            icon: Icons.remove_red_eye,
            color: AppColors.catAI,
          ),
          MemoryPairData(
            concept: 'GPT',
            definition: 'Generative Pre-trained',
            icon: Icons.smart_toy,
            color: AppColors.catAI,
          ),
          MemoryPairData(
            concept: 'Context Window',
            definition: 'Memoria de corto plazo',
            icon: Icons.memory,
            color: AppColors.catAI,
          ),
        ];
      case 2: // Agentes IA
        return const [
          MemoryPairData(
            concept: 'Agente IA',
            definition: 'Sistema autónomo',
            icon: Icons.smart_toy,
            color: AppColors.catAgents,
          ),
          MemoryPairData(
            concept: 'Skill',
            definition: 'Habilidad especializada',
            icon: Icons.extension,
            color: AppColors.catAgents,
          ),
          MemoryPairData(
            concept: 'SKILL.md',
            definition: 'Documento de instrucciones',
            icon: Icons.description,
            color: AppColors.catAgents,
          ),
          MemoryPairData(
            concept: 'Workflow',
            definition: 'Pasos para una tarea',
            icon: Icons.route,
            color: AppColors.catAgents,
          ),
          MemoryPairData(
            concept: 'Reflection',
            definition: 'Auto-análisis del agente',
            icon: Icons.psychology,
            color: AppColors.catAgents,
          ),
          MemoryPairData(
            concept: 'Toolkit',
            definition: 'Conjunto de herramientas',
            icon: Icons.handyman,
            color: AppColors.catAgents,
          ),
        ];
      case 3: // Arquitectura 4 Capas
        return const [
          MemoryPairData(
            concept: 'Capa 1',
            definition: 'Maestro / Directiva',
            icon: Icons.gavel,
            color: AppColors.catArch,
          ),
          MemoryPairData(
            concept: 'Capa 2',
            definition: 'Orquestador',
            icon: Icons.account_tree,
            color: AppColors.catArch,
          ),
          MemoryPairData(
            concept: 'Capa 3',
            definition: 'Agentes Ejecutores',
            icon: Icons.groups,
            color: AppColors.catArch,
          ),
          MemoryPairData(
            concept: 'Capa 4',
            definition: 'Output / Validación',
            icon: Icons.verified,
            color: AppColors.catArch,
          ),
          MemoryPairData(
            concept: 'Directiva',
            definition: 'Define el QUÉ',
            icon: Icons.flag,
            color: AppColors.catArch,
          ),
          MemoryPairData(
            concept: 'Validación',
            definition: 'Verifica el output',
            icon: Icons.check_circle,
            color: AppColors.catArch,
          ),
        ];
      case 4: // Orquestación
        return const [
          MemoryPairData(
            concept: 'Secuencial',
            definition: 'Uno tras otro',
            icon: Icons.linear_scale,
            color: AppColors.catOrq,
          ),
          MemoryPairData(
            concept: 'Paralelo',
            definition: 'Varios simultáneos',
            icon: Icons.call_split,
            color: AppColors.catOrq,
          ),
          MemoryPairData(
            concept: 'Pipeline',
            definition: 'Cadena de outputs',
            icon: Icons.trending_flat,
            color: AppColors.catOrq,
          ),
          MemoryPairData(
            concept: 'Fan-out/in',
            definition: 'Dividir y reunir',
            icon: Icons.merge_type,
            color: AppColors.catOrq,
          ),
          MemoryPairData(
            concept: 'Handoff',
            definition: 'Pasar contexto',
            icon: Icons.swap_horiz,
            color: AppColors.catOrq,
          ),
          MemoryPairData(
            concept: 'Retry',
            definition: 'Reintento automático',
            icon: Icons.replay,
            color: AppColors.catOrq,
          ),
        ];
      case 5: // MCP & Skills
        return const [
          MemoryPairData(
            concept: 'MCP',
            definition: 'Model Context Protocol',
            icon: Icons.cloud_sync,
            color: AppColors.catMCP,
          ),
          MemoryPairData(
            concept: 'Server',
            definition: 'Expone herramientas',
            icon: Icons.dns,
            color: AppColors.catMCP,
          ),
          MemoryPairData(
            concept: 'Resource',
            definition: 'Dato de lectura',
            icon: Icons.folder_open,
            color: AppColors.catMCP,
          ),
          MemoryPairData(
            concept: 'Tool',
            definition: 'Función ejecutable',
            icon: Icons.build,
            color: AppColors.catMCP,
          ),
          MemoryPairData(
            concept: 'Regla Global',
            definition: 'Restricción general',
            icon: Icons.shield,
            color: AppColors.catMCP,
          ),
          MemoryPairData(
            concept: 'MCP Client',
            definition: 'Usa las herramientas',
            icon: Icons.devices,
            color: AppColors.catMCP,
          ),
        ];
      default:
        return const [
          MemoryPairData(
            concept: 'IA',
            definition: 'Inteligencia Artificial',
            icon: Icons.auto_awesome,
            color: AppColors.cyan,
          ),
          MemoryPairData(
            concept: 'ML',
            definition: 'Machine Learning',
            icon: Icons.auto_graph,
            color: AppColors.cyan,
          ),
          MemoryPairData(
            concept: 'LLM',
            definition: 'Modelo de Lenguaje',
            icon: Icons.smart_toy,
            color: AppColors.cyan,
          ),
          MemoryPairData(
            concept: 'API',
            definition: 'Interfaz de Programa',
            icon: Icons.api,
            color: AppColors.cyan,
          ),
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

  int get _xpEarned {
    int baseXP = finalErrors == 0 ? 50 : 30;
    switch (widget.level) {
      case 'intermedio':
        return (baseXP * 1.5).round();
      case 'avanzado':
        return baseXP * 2;
      default:
        return baseXP;
    }
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
          // Level badge
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: widget.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: widget.categoryColor.withOpacity(0.3),
                ),
              ),
              child: Text(
                _levelLabel,
                style: TextStyle(
                  color: widget.categoryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _mode == MemoryGameMode.icon
                ? 'Encuentra los pares de iconos iguales'
                : _mode == MemoryGameMode.mixed
                ? 'Empareja cada icono con su definición'
                : 'Encuentra los pares concepto ↔ definición',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          MemoryGameWidget(
            pairs: _memoryPairs,
            mode: _mode,
            onComplete: _onGameComplete,
          ),
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
                  _resultRow('Nivel', _levelLabel),
                  const SizedBox(height: 8),
                  _resultRow('Tiempo', '${finalTimeSeconds}s'),
                  const SizedBox(height: 8),
                  _resultRow('Errores', '$finalErrors'),
                  const SizedBox(height: 8),
                  _resultRow(
                    'XP ganado',
                    '+$_xpEarned',
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
