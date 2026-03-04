import 'package:flutter/material.dart';

enum NodeType { input, orchestrator, agent, tool, output }

class SimulatorNode {
  final String id;
  final NodeType type;
  final String label;
  final IconData icon;
  final Color color;
  Offset position;

  SimulatorNode({
    required this.id,
    required this.type,
    required this.label,
    required this.icon,
    required this.color,
    this.position = const Offset(100, 100),
  });
}

class SimulatorConnection {
  final String fromNodeId;
  final String toNodeId;

  SimulatorConnection({required this.fromNodeId, required this.toNodeId});
}
