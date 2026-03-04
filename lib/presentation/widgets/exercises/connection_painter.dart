import 'package:flutter/material.dart';
import 'package:antigravity_quiz/data/models/simulator_models.dart';

class ConnectionPainter extends CustomPainter {
  final List<SimulatorNode> nodes;
  final List<SimulatorConnection> connections;

  ConnectionPainter({required this.nodes, required this.connections});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (var conn in connections) {
      final fromNode = nodes.firstWhere((n) => n.id == conn.fromNodeId);
      final toNode = nodes.firstWhere((n) => n.id == conn.toNodeId);

      // Ajuste para centrar la línea en los nodos (70x70 nodes)
      final start = fromNode.position + const Offset(35, 35);
      final end = toNode.position + const Offset(35, 35);

      final path = Path();
      path.moveTo(start.dx, start.dy);

      // Dibujar curva Bezier simple para que se vea más tecnológico
      final controlPoint1 = Offset(
        start.dx + (end.dx - start.dx) / 2,
        start.dy,
      );
      final controlPoint2 = Offset(start.dx + (end.dx - start.dx) / 2, end.dy);

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        end.dx,
        end.dy,
      );

      canvas.drawPath(path, paint);

      // Dibujar flecha indicadora de dirección
      _drawArrowHead(canvas, end, start, paint.color);
    }
  }

  void _drawArrowHead(Canvas canvas, Offset tip, Offset from, Color color) {
    final arrowPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // Simplificado: punta de flecha básica
    canvas.drawCircle(tip, 4, arrowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
