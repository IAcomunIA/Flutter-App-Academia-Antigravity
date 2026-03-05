import 'dart:math';
import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';

/// Workflow Builder: Reemplazo del Code Challenge.
/// El usuario debe ordenar los pasos correctos de un flujo Antigravity.
class WorkflowBuilderScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const WorkflowBuilderScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<WorkflowBuilderScreen> createState() => _WorkflowBuilderScreenState();
}

class _WorkflowBuilderScreenState extends State<WorkflowBuilderScreen>
    with SingleTickerProviderStateMixin {
  late _WorkflowChallenge _challenge;
  late List<_WorkflowStep> _userOrder;
  bool _hasValidated = false;
  bool _isCorrect = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _challenge = _getChallengeForCategory(widget.categoryId);
    _userOrder = List.from(_challenge.steps)..shuffle(Random());
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  _WorkflowChallenge _getChallengeForCategory(int categoryId) {
    switch (categoryId) {
      case 1: // IA Fundamentos
        return _WorkflowChallenge(
          title: 'Flujo de Procesamiento de un LLM',
          description:
              'Ordena los pasos que sigue un modelo de lenguaje al procesar una petición:',
          steps: [
            _WorkflowStep(
              id: 0,
              label: 'Recibir prompt del usuario',
              icon: Icons.person,
              color: AppColors.catAI,
            ),
            _WorkflowStep(
              id: 1,
              label: 'Tokenizar el texto de entrada',
              icon: Icons.text_fields,
              color: AppColors.catAI,
            ),
            _WorkflowStep(
              id: 2,
              label: 'Procesar por la red neuronal',
              icon: Icons.psychology,
              color: AppColors.catAI,
            ),
            _WorkflowStep(
              id: 3,
              label: 'Generar tokens de respuesta',
              icon: Icons.auto_awesome,
              color: AppColors.catAI,
            ),
            _WorkflowStep(
              id: 4,
              label: 'Decodificar y entregar respuesta',
              icon: Icons.check_circle,
              color: AppColors.catAI,
            ),
          ],
        );
      case 2: // Agentes IA
        return _WorkflowChallenge(
          title: 'Ciclo de Vida de un Agente Antigravity',
          description:
              'Ordena el flujo de ejecución de un agente desde que recibe una tarea:',
          steps: [
            _WorkflowStep(
              id: 0,
              label: 'Recibir directiva del orquestador',
              icon: Icons.gavel,
              color: AppColors.catAgents,
            ),
            _WorkflowStep(
              id: 1,
              label: 'Leer reglas globales y skills',
              icon: Icons.menu_book,
              color: AppColors.catAgents,
            ),
            _WorkflowStep(
              id: 2,
              label: 'Planificar la ejecución',
              icon: Icons.route,
              color: AppColors.catAgents,
            ),
            _WorkflowStep(
              id: 3,
              label: 'Ejecutar herramientas (Tools)',
              icon: Icons.build,
              color: AppColors.catAgents,
            ),
            _WorkflowStep(
              id: 4,
              label: 'Validar output y reportar resultado',
              icon: Icons.verified,
              color: AppColors.catAgents,
            ),
          ],
        );
      case 3: // Arquitectura 4 Capas
        return _WorkflowChallenge(
          title: 'Flujo de las 4 Capas Antigravity',
          description:
              'Ordena las capas del sistema Antigravity de arriba hacia abajo:',
          steps: [
            _WorkflowStep(
              id: 0,
              label: 'CAPA 1 — Maestro / Directiva',
              icon: Icons.flag,
              color: const Color(0xFFEF4444),
            ),
            _WorkflowStep(
              id: 1,
              label: 'CAPA 2 — Orquestador',
              icon: Icons.account_tree,
              color: AppColors.catArch,
            ),
            _WorkflowStep(
              id: 2,
              label: 'CAPA 3 — Agentes Ejecutores',
              icon: Icons.groups,
              color: AppColors.catAgents,
            ),
            _WorkflowStep(
              id: 3,
              label: 'CAPA 4 — Output / Validación',
              icon: Icons.check_circle,
              color: AppColors.success,
            ),
          ],
        );
      case 4: // Orquestación
        return _WorkflowChallenge(
          title: 'Flujo de Orquestación Paralela',
          description: 'Ordena los pasos para ejecutar agentes en paralelo:',
          steps: [
            _WorkflowStep(
              id: 0,
              label: 'Orquestador recibe la tarea',
              icon: Icons.input,
              color: AppColors.catOrq,
            ),
            _WorkflowStep(
              id: 1,
              label: 'Dividir tarea en sub-tareas (Fan-out)',
              icon: Icons.call_split,
              color: AppColors.catOrq,
            ),
            _WorkflowStep(
              id: 2,
              label: 'Agentes ejecutan en paralelo',
              icon: Icons.groups,
              color: AppColors.catOrq,
            ),
            _WorkflowStep(
              id: 3,
              label: 'Sincronizar resultados (Fan-in)',
              icon: Icons.merge_type,
              color: AppColors.catOrq,
            ),
            _WorkflowStep(
              id: 4,
              label: 'Validar y entregar output final',
              icon: Icons.verified,
              color: AppColors.catOrq,
            ),
          ],
        );
      case 5: // MCP, Skills y Reglas
      default:
        return _WorkflowChallenge(
          title: 'Flujo MCP: Agente usa una Herramienta',
          description:
              'Ordena los pasos cuando un agente necesita usar una herramienta vía MCP:',
          steps: [
            _WorkflowStep(
              id: 0,
              label: 'Agente identifica necesidad de herramienta',
              icon: Icons.search,
              color: AppColors.catMCP,
            ),
            _WorkflowStep(
              id: 1,
              label: 'Consultar MCP Server disponible',
              icon: Icons.dns,
              color: AppColors.catMCP,
            ),
            _WorkflowStep(
              id: 2,
              label: 'Enviar request al Tool del MCP',
              icon: Icons.send,
              color: AppColors.catMCP,
            ),
            _WorkflowStep(
              id: 3,
              label: 'MCP Server ejecuta la herramienta',
              icon: Icons.settings,
              color: AppColors.catMCP,
            ),
            _WorkflowStep(
              id: 4,
              label: 'Agente recibe y procesa el resultado',
              icon: Icons.download_done,
              color: AppColors.catMCP,
            ),
          ],
        );
    }
  }

  void _validate() {
    bool correct = true;
    for (int i = 0; i < _userOrder.length; i++) {
      if (_userOrder[i].id != i) {
        correct = false;
        break;
      }
    }

    setState(() {
      _hasValidated = true;
      _isCorrect = correct;
    });
  }

  void _reset() {
    setState(() {
      _hasValidated = false;
      _isCorrect = false;
      _userOrder = List.from(_challenge.steps)..shuffle(Random());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          '🔄 Workflow — ${widget.categoryName}',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          if (_hasValidated && !_isCorrect)
            IconButton(
              icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
              onPressed: _reset,
            ),
        ],
      ),
      body: Column(
        children: [
          // Challenge header
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  widget.categoryColor.withOpacity(0.1),
                  AppColors.cardBg,
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: widget.categoryColor.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: widget.categoryColor.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.route,
                        color: widget.categoryColor,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        _challenge.title,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _challenge.description,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // Instrucción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cyan.withOpacity(
                      0.05 + _pulseController.value * 0.05,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.cyan.withOpacity(0.2)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: AppColors.cyan.withOpacity(0.7),
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Mantén presionado y arrastra para reordenar',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Reorderable list
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ReorderableListView.builder(
                proxyDecorator: (child, index, animation) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (context, child) {
                      final double elevation = Tween<double>(
                        begin: 0,
                        end: 12,
                      ).animate(animation).value;
                      return Material(
                        elevation: elevation,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        child: child,
                      );
                    },
                    child: child,
                  );
                },
                itemCount: _userOrder.length,
                onReorder: _hasValidated
                    ? (oldIndex, newIndex) {}
                    : (oldIndex, newIndex) {
                        setState(() {
                          if (oldIndex < newIndex) newIndex -= 1;
                          final item = _userOrder.removeAt(oldIndex);
                          _userOrder.insert(newIndex, item);
                        });
                      },
                itemBuilder: (context, index) {
                  final step = _userOrder[index];
                  final bool isCorrectPosition =
                      _hasValidated && step.id == index;
                  final bool isWrongPosition =
                      _hasValidated && step.id != index;

                  return Container(
                    key: ValueKey(step.id),
                    margin: const EdgeInsets.only(bottom: 10),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isCorrectPosition
                            ? AppColors.success.withOpacity(0.1)
                            : isWrongPosition
                            ? AppColors.error.withOpacity(0.1)
                            : AppColors.cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCorrectPosition
                              ? AppColors.success
                              : isWrongPosition
                              ? AppColors.error
                              : AppColors.borderColor,
                          width: _hasValidated ? 2 : 1,
                        ),
                        boxShadow: isCorrectPosition
                            ? [
                                BoxShadow(
                                  color: AppColors.success.withOpacity(0.15),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Row(
                        children: [
                          // Número de paso
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: isCorrectPosition
                                  ? AppColors.success.withOpacity(0.2)
                                  : isWrongPosition
                                  ? AppColors.error.withOpacity(0.2)
                                  : step.color.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isCorrectPosition
                                    ? AppColors.success
                                    : isWrongPosition
                                    ? AppColors.error
                                    : step.color.withOpacity(0.4),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: TextStyle(
                                  color: isCorrectPosition
                                      ? AppColors.success
                                      : isWrongPosition
                                      ? AppColors.error
                                      : step.color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          // Icono
                          Icon(
                            step.icon,
                            color: isCorrectPosition
                                ? AppColors.success
                                : isWrongPosition
                                ? AppColors.error
                                : step.color,
                            size: 22,
                          ),
                          const SizedBox(width: 12),
                          // Label
                          Expanded(
                            child: Text(
                              step.label,
                              style: TextStyle(
                                color: isCorrectPosition
                                    ? AppColors.success
                                    : isWrongPosition
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          // Feedback icon
                          if (_hasValidated)
                            Icon(
                              isCorrectPosition
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color: isCorrectPosition
                                  ? AppColors.success
                                  : AppColors.error,
                              size: 22,
                            )
                          else
                            const Icon(
                              Icons.drag_handle,
                              color: AppColors.textMuted,
                              size: 22,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // Botones
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              children: [
                if (!_hasValidated)
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _validate,
                      icon: const Icon(
                        Icons.verified_user,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'VALIDAR FLUJO',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.categoryColor,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                if (_hasValidated && _isCorrect)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.success),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.emoji_events,
                              color: AppColors.xpGold,
                              size: 32,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '¡Flujo Correcto!',
                                    style: TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    'Has dominado este flujo Antigravity',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.xpGold.withOpacity(0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '+40 XP',
                                style: TextStyle(
                                  color: AppColors.xpGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
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
                            'CONTINUAR MISIÓN',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_hasValidated && !_isCorrect)
                  Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.error.withOpacity(0.5),
                          ),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.error,
                              size: 24,
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Algunos pasos están en el orden incorrecto. Revisa las marcas rojas y reordena.',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          onPressed: _reset,
                          icon: const Icon(
                            Icons.refresh,
                            color: AppColors.cyan,
                          ),
                          label: const Text(
                            'REINTENTAR',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.cyan),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WorkflowChallenge {
  final String title;
  final String description;
  final List<_WorkflowStep> steps;

  _WorkflowChallenge({
    required this.title,
    required this.description,
    required this.steps,
  });
}

class _WorkflowStep {
  final int id; // Posición correcta (0-indexed)
  final String label;
  final IconData icon;
  final Color color;

  const _WorkflowStep({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
  });
}
