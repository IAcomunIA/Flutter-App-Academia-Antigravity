import 'package:flutter/material.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';
import 'package:antigravity_quiz/core/constants/app_typography.dart';
import 'package:antigravity_quiz/data/models/simulator_models.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/agent_node_widget.dart';
import 'package:antigravity_quiz/presentation/widgets/exercises/connection_painter.dart';

class SimulatorScreen extends StatefulWidget {
  final int categoryId;
  final String categoryName;
  final Color categoryColor;

  const SimulatorScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
    required this.categoryColor,
  });

  @override
  State<SimulatorScreen> createState() => _SimulatorScreenState();
}

class _SimulatorScreenState extends State<SimulatorScreen> {
  final List<SimulatorNode> _nodes = [];
  final List<SimulatorConnection> _connections = [];
  String? _selectedNodeId;
  String? _firstNodeForConnection;

  bool _isValidateEnabled = false;

  String _getSimulatorTitle() {
    final name = widget.categoryName.toLowerCase();
    if (name.contains('agente')) {
      return 'Simulador de Agentes IA';
    } else if (name.contains('arquitectura') || name.contains('4 capas')) {
      return 'Simulador de Arquitectura';
    } else if (name.contains('orquestación') || name.contains('orquestacion')) {
      return 'Simulador de Orquestación';
    } else if (name.contains('mcp')) {
      return 'Simulador MCP';
    }
    return 'Simulador de Flujos';
  }

  List<Map<String, dynamic>> _getAvailableNodes() {
    final name = widget.categoryName.toLowerCase();
    if (name.contains('agente')) {
      return [
        {'type': NodeType.input, 'label': 'Directiva', 'icon': Icons.gavel, 'color': AppColors.catAI},
        {'type': NodeType.orchestrator, 'label': 'Orquestador', 'icon': Icons.hub, 'color': AppColors.catArch},
        {'type': NodeType.agent, 'label': 'Agente', 'icon': Icons.smart_toy, 'color': AppColors.catAgents},
        {'type': NodeType.output, 'label': 'Output', 'icon': Icons.check_circle, 'color': AppColors.catOrq},
      ];
    } else if (name.contains('arquitectura') || name.contains('4 capas')) {
      return [
        {'type': NodeType.input, 'label': 'Input', 'icon': Icons.input, 'color': AppColors.catAI},
        {'type': NodeType.orchestrator, 'label': 'Maestro', 'icon': Icons.psychology, 'color': AppColors.catArch},
        {'type': NodeType.agent, 'label': 'Agentes', 'icon': Icons.smart_toy, 'color': AppColors.catAgents},
        {'type': NodeType.output, 'label': 'Output', 'icon': Icons.output, 'color': AppColors.catOrq},
      ];
    } else if (name.contains('orquestación') || name.contains('orquestacion')) {
      return [
        {'type': NodeType.input, 'label': 'Entrada', 'icon': Icons.input, 'color': AppColors.catAI},
        {'type': NodeType.orchestrator, 'label': 'Orquestador', 'icon': Icons.account_tree, 'color': AppColors.catArch},
        {'type': NodeType.tool, 'label': 'Herramienta', 'icon': Icons.build, 'color': const Color(0xFFA855F7)},
        {'type': NodeType.agent, 'label': 'Agente', 'icon': Icons.smart_toy, 'color': AppColors.catAgents},
        {'type': NodeType.output, 'label': 'Resultado', 'icon': Icons.check_circle, 'color': AppColors.catOrq},
      ];
    }
    return [
      {'type': NodeType.input, 'label': 'Input', 'icon': Icons.input, 'color': AppColors.catAI},
      {'type': NodeType.orchestrator, 'label': 'Proceso', 'icon': Icons.hub, 'color': AppColors.catArch},
      {'type': NodeType.agent, 'label': 'Agente', 'icon': Icons.smart_toy, 'color': AppColors.catAgents},
      {'type': NodeType.output, 'label': 'Output', 'icon': Icons.output, 'color': AppColors.catOrq},
    ];
  }

  String _getValidationHint() {
    final name = widget.categoryName.toLowerCase();
    if (name.contains('agente')) {
      return 'Crea el flujo: Directiva → Orquestador → Agente → Output';
    } else if (name.contains('arquitectura') || name.contains('4 capas')) {
      return 'Conecta: Input → Maestro → Agentes → Output';
    } else if (name.contains('orquestación') || name.contains('orquestacion')) {
      return 'Construye un flujo de orquestación con múltiples agentes';
    }
    return 'Conecta los nodos para crear un flujo válido';
  }

  void _addNode(NodeType type, String label, IconData icon, Color color) {
    setState(() {
      final id = 'node_${DateTime.now().millisecondsSinceEpoch}';
      _nodes.add(
        SimulatorNode(
          id: id,
          type: type,
          label: label,
          icon: icon,
          color: color,
          position: Offset(
            50 + (MediaQuery.of(context).size.width - 100) * 0.1,
            100 + _nodes.length * 20.0,
          ),
        ),
      );
      _checkValidationReady();
    });
  }

  void _checkValidationReady() {
    setState(() {
      _isValidateEnabled = _nodes.length >= 2 && _connections.isNotEmpty;
    });
  }

  void _handleNodeTap(String id) {
    setState(() {
      if (_firstNodeForConnection == null) {
        _selectedNodeId = id;
        _firstNodeForConnection = id;
      } else {
        if (_firstNodeForConnection != id) {
          bool exists = _connections.any(
            (c) =>
                (c.fromNodeId == _firstNodeForConnection && c.toNodeId == id) ||
                (c.fromNodeId == id && c.toNodeId == _firstNodeForConnection),
          );

          if (!exists) {
            _connections.add(
              SimulatorConnection(
                fromNodeId: _firstNodeForConnection!,
                toNodeId: id,
              ),
            );
          }
        }
        _firstNodeForConnection = null;
        _selectedNodeId = null;
      }
      _checkValidationReady();
    });
  }

  void _validateFlow() {
    bool isCorrect = false;
    String message = "";
    String title = "";

    final name = widget.categoryName.toLowerCase();

    if (name.contains('agente')) {
      bool hasDirective = _nodes.any((n) => n.type == NodeType.input);
      bool hasOrch = _nodes.any((n) => n.type == NodeType.orchestrator);
      bool hasAgent = _nodes.any((n) => n.type == NodeType.agent);
      bool hasOutput = _nodes.any((n) => n.type == NodeType.output);
      
      if (!hasDirective) {
        message = "❌ Falta el nodo 'Directiva' (input)";
      } else if (!hasOrch) {
        message = "❌ Falta el nodo 'Orquestador'";
      } else if (!hasAgent) {
        message = "❌ Falta el nodo 'Agente'";
      } else if (_connections.length < 2) {
        message = "❌ Conecta los nodos: Directiva → Orquestador → Agente";
      } else if (!hasOutput) {
        message = "❌ Falta el nodo 'Output' para completar el flujo";
      } else {
        isCorrect = true;
        message = "✅ ¡Excelente! Flujo de Agentes IA validado correctamente.\n\nDirectiva → Orquestador → Agente → Output";
      }
      title = isCorrect ? "¡Validación Exitosa!" : "Flujo Incompleto";
    } else if (name.contains('arquitectura') || name.contains('4 capas')) {
      bool hasInput = _nodes.any((n) => n.type == NodeType.input);
      bool hasMaestro = _nodes.any((n) => n.type == NodeType.orchestrator);
      bool hasAgentes = _nodes.any((n) => n.type == NodeType.agent);
      bool hasOutput = _nodes.any((n) => n.type == NodeType.output);
      
      if (!hasInput) {
        message = "❌ Falta la Capa Input";
      } else if (!hasMaestro) {
        message = "❌ Falta la Capa Maestro/Orquestador";
      } else if (!hasAgentes) {
        message = "❌ Falta la Capa de Agentes";
      } else if (_connections.length < 3) {
        message = "❌ Conecta todas las capas en orden: Input → Maestro → Agentes → Output";
      } else if (!hasOutput) {
        message = "❌ Falta la Capa Output";
      } else {
        isCorrect = true;
        message = "✅ ¡Arquitectura de 4 Capas validada!\n\nInput → Maestro → Agentes → Output";
      }
      title = isCorrect ? "¡Arquitectura Correcta!" : "Arquitectura Incompleta";
    } else if (name.contains('orquestación') || name.contains('orquestacion')) {
      bool hasInput = _nodes.any((n) => n.type == NodeType.input);
      bool hasOrch = _nodes.any((n) => n.type == NodeType.orchestrator);
      bool hasAgent = _nodes.any((n) => n.type == NodeType.agent);
      
      if (!hasInput) {
        message = "❌ Falta el nodo de Entrada";
      } else if (!hasOrch) {
        message = "❌ Falta el Orquestador";
      } else if (!hasAgent) {
        message = "❌ Falta al menos un Agente";
      } else if (_connections.length < 2) {
        message = "❌ Conecta los nodos del flujo de orquestación";
      } else {
        isCorrect = true;
        message = "✅ ¡Orquestación validada correctamente!\n\nEntrada → Orquestador → Agente(s)";
      }
      title = isCorrect ? "¡Orquestación Correcta!" : "Orquestación Incompleta";
    } else {
      isCorrect = _nodes.length >= 3 && _connections.length >= 2;
      title = isCorrect ? "¡Validación Exitosa!" : "Flujo Incompleto";
      message = isCorrect
          ? "✅ Simulación completada correctamente."
          : "❌ Construye un flujo más robusto (mínimo 3 nodos y 2 conexiones)";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(
              isCorrect ? Icons.check_circle : Icons.error_outline,
              color: isCorrect ? AppColors.success : AppColors.error,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(title)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 15,
            height: 1.5,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) {
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect ? AppColors.success : AppColors.surfaceBg,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              isCorrect ? "CONTINUAR" : "REINTENTAR",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final availableNodes = _getAvailableNodes();

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          '🤖 ${_getSimulatorTitle()}',
          style: AppTextStyles.heading2.copyWith(fontSize: 16),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.textSecondary),
            onPressed: () {
              setState(() {
                _nodes.clear();
                _connections.clear();
                _isValidateEnabled = false;
              });
            },
          ),
        ],
      ),
      floatingActionButton: Container(
        width: 180,
        height: 56,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          boxShadow: _isValidateEnabled
              ? [
                  BoxShadow(
                    color: AppColors.success.withOpacity(0.4),
                    blurRadius: 16,
                    spreadRadius: 2,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: FloatingActionButton.extended(
          onPressed: _isValidateEnabled ? _validateFlow : null,
          backgroundColor: _isValidateEnabled
              ? AppColors.success
              : AppColors.surfaceBg.withOpacity(0.8),
          elevation: _isValidateEnabled ? 8 : 2,
          icon: Icon(
            Icons.verified_user,
            color: _isValidateEnabled ? Colors.white : AppColors.textMuted,
            size: 24,
          ),
          label: Text(
            'VALIDAR',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: _isValidateEnabled ? Colors.white : AppColors.textMuted,
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Stack(
        children: [
          CustomPaint(
            painter: ConnectionPainter(
              nodes: _nodes,
              connections: _connections,
            ),
            size: Size.infinite,
          ),

          ..._nodes.map(
            (node) => AgentNodeWidget(
              key: ValueKey(node.id),
              node: node,
              isSelected:
                  _selectedNodeId == node.id ||
                  _firstNodeForConnection == node.id,
              onTap: () => _handleNodeTap(node.id),
              onDragUpdate: (delta) {
                setState(() {
                  node.position += delta;
                });
              },
            ),
          ),

          Positioned(
            left: 10,
            bottom: 100,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cardBg.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.borderColor),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: availableNodes.map((nodeData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: _buildPaletteItem(
                      nodeData['type'] as NodeType,
                      nodeData['label'] as String,
                      nodeData['icon'] as IconData,
                      nodeData['color'] as Color,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: widget.categoryColor.withOpacity(0.5)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _getValidationHint(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Nodos: ${_nodes.length} | Conexiones: ${_connections.length}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          if (_firstNodeForConnection != null)
            Positioned(
              bottom: 100,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: widget.categoryColor,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'Selecciona el nodo DESTINO para conectar',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaletteItem(
    NodeType type,
    String label,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () => _addNode(type, label, icon, color),
      child: Tooltip(
        message: label,
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 24),
              const SizedBox(height: 2),
              Text(
                label.length > 6 ? label.substring(0, 6) : label,
                style: TextStyle(
                  color: color,
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
