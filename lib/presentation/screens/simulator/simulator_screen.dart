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
          position: const Offset(50, 100),
        ),
      );
    });
  }

  void _handleNodeTap(String id) {
    setState(() {
      if (_firstNodeForConnection == null) {
        _selectedNodeId = id;
        _firstNodeForConnection = id;
      } else {
        if (_firstNodeForConnection != id) {
          // Crear conexión
          _connections.add(
            SimulatorConnection(
              fromNodeId: _firstNodeForConnection!,
              toNodeId: id,
            ),
          );
        }
        _firstNodeForConnection = null;
        _selectedNodeId = null;
      }
    });
  }

  void _validateFlow() {
    // Lógica de validación simplificada para la demo
    bool hasDirectiva = _nodes.any((n) => n.type == NodeType.input);
    bool hasOrchestrator = _nodes.any((n) => n.type == NodeType.orchestrator);
    bool hasAgent = _nodes.any((n) => n.type == NodeType.agent);

    if (hasDirectiva &&
        hasOrchestrator &&
        hasAgent &&
        _connections.length >= 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ ¡Arquitectura Antigravity validada con éxito!'),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            '❌ Flujo incompleto. Asegúrate de conectar Capa 1, 2 y 3.',
          ),
          backgroundColor: AppColors.error,
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
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.check_circle, color: AppColors.success),
            onPressed: _validateFlow,
          ),
        ],
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
