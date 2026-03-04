import 'package:flutter/material.dart';
import 'package:antigravity_quiz/data/models/simulator_models.dart';
import 'package:antigravity_quiz/core/constants/app_colors.dart';

class AgentNodeWidget extends StatelessWidget {
  final SimulatorNode node;
  final bool isSelected;
  final VoidCallback onTap;
  final Function(Offset) onDragUpdate;

  const AgentNodeWidget({
    super.key,
    required this.node,
    this.isSelected = false,
    required this.onTap,
    required this.onDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: node.position.dx,
      top: node.position.dy,
      child: Draggable(
        feedback: _buildNodeBody(opacity: 0.6),
        childWhenDragging: const SizedBox.shrink(),
        onDragUpdate: (details) => onDragUpdate(details.delta),
        child: GestureDetector(onTap: onTap, child: _buildNodeBody()),
      ),
    );
  }

  Widget _buildNodeBody({double opacity = 1.0}) {
    return Opacity(
      opacity: opacity,
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.white : node.color,
                width: isSelected ? 3 : 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: node.color.withOpacity(0.3),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Icon(node.icon, color: node.color, size: 32),
          ),
          const SizedBox(height: 8),
          Material(
            color: Colors.transparent,
            child: Text(
              node.label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
