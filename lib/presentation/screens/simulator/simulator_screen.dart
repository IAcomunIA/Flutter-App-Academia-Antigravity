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
          // Evitar conexiones duplicadas
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
    // Lógica de validación dinámica por tema
    bool isCorrect = false;
    String message = "";

    // Simplificamos la detección del tema basado en el nombre o ID
    final name = widget.categoryName.toLowerCase();

    if (name.contains('agente') || widget.categoryId == 2) {
      bool hasDirective = _nodes.any((n) => n.type == NodeType.input);
      bool hasOrch = _nodes.any((n) => n.type == NodeType.orchestrator);
      bool hasAgent = _nodes.any((n) => n.type == NodeType.agent);
      isCorrect =
          hasDirective && hasOrch && hasAgent && _connections.length >= 2;
      message = isCorrect
          ? "✅ Flujo de Agentes validado con éxito."
          : "❌ Falta conectar Directiva -> Orquestador -> Agente.";
    } else if (name.contains('arquitectura') || widget.categoryId == 3) {
      bool hasInput = _nodes.any((n) => n.type == NodeType.input);
      bool hasOrch = _nodes.any((n) => n.type == NodeType.orchestrator);
      bool hasOutput = _nodes.any((n) => n.type == NodeType.output);
      isCorrect = hasInput && hasOrch && hasOutput && _connections.length >= 2;
      message = isCorrect
          ? "✅ Arquitectura de 4 capas validada con éxito."
          : "❌ Asegúrate de conectar Input, Orquestador y Output.";
    } else {
      isCorrect = _nodes.length >= 3 && _connections.length >= 2;
      message = isCorrect
          ? "✅ Simulación completada correctamente."
          : "❌ Construye un flujo más robusto.";
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(isCorrect ? "¡Validación Exitosa!" : "Flujo Incompleto"),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (isCorrect) Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isCorrect
                  ? AppColors.success
                  : AppColors.surfaceBg,
            ),
            child: const Text("ENTENDIDO"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        title: Text(
          '🤖 Simulador — ${widget.categoryName}',
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isValidateEnabled ? _validateFlow : null,
        backgroundColor: _isValidateEnabled
            ? AppColors.success
            : AppColors.surfaceBg,
        icon: Icon(
          Icons.check_circle,
          color: _isValidateEnabled ? Colors.white : AppColors.textMuted,
        ),
        label: Text(
          'VALIDAR FLUJO',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _isValidateEnabled ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
      body: Stack(
        children: [
          // Canvas para las líneas
          CustomPaint(
            painter: ConnectionPainter(
              nodes: _nodes,
              connections: _connections,
            ),
            size: Size.infinite,
          ),

          // Los nodos
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

          // Paleta de componentes (Lateral)
          Positioned(
            left: 10,
            bottom: 20,
            child: Column(
              children: [
                _buildPaletteItem(
                  NodeType.input,
                  'Directiva',
                  Icons.gavel,
                  AppColors.catAI,
                ),
                const SizedBox(height: 10),
                _buildPaletteItem(
                  NodeType.orchestrator,
                  'Orquestador',
                  Icons.hub,
                  AppColors.catArch,
                ),
                const SizedBox(height: 10),
                _buildPaletteItem(
                  NodeType.agent,
                  'Agente',
                  Icons.smart_toy,
                  AppColors.catAgents,
                ),
                const SizedBox(height: 10),
                _buildPaletteItem(
                  NodeType.output,
                  'Output',
                  Icons.check_circle,
                  AppColors.catOrq,
                ),
              ],
            ),
          ),

          // Instrucción
          Positioned(
            top: 10,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _firstNodeForConnection == null
                      ? 'Selecciona un nodo para iniciar conexión'
                      : 'Selecciona el nodo destino',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
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
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Icon(icon, color: color),
      ),
    );
  }
}
