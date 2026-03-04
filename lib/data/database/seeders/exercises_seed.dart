import 'dart:convert';
import 'package:sqflite/sqflite.dart';

class ExercisesSeed {
  static Future<void> seed(Database db) async {
    final exercises = [
      // CATEGORÍA 3 (Arq. 4 Capas) - Sub 14 (Orquestador) - AVANZADO
      {
        'subcategory_id': 14,
        'level': 'avanzado',
        'exercise_type': 'simulator',
        'content': jsonEncode({
          'title': 'Arquitectura de Agente Simple',
          'description':
              'Conecta los nodos para crear un flujo: Input -> Orquestador -> Agente -> Output',
          'nodes': [
            {'id': 'n1', 'type': 'input', 'label': 'Input'},
            {'id': 'n2', 'type': 'orchestrator', 'label': 'Orquestador'},
            {'id': 'n3', 'type': 'agent', 'label': 'Agente Ejecutor'},
            {'id': 'n4', 'type': 'output', 'label': 'Output'},
          ],
          'correct_connections': [
            {'from': 'n1', 'to': 'n2'},
            {'from': 'n2', 'to': 'n3'},
            {'from': 'n3', 'to': 'n4'},
          ],
        }),
        'difficulty': 'medio',
        'points': 50,
      },

      // CATEGORÍA 4 (Orquestación) - Sub 19 (Básica) - INTERMEDIO
      {
        'subcategory_id': 19,
        'level': 'intermedio',
        'exercise_type': 'flow_order',
        'content': jsonEncode({
          'question': 'Ordena los pasos de una orquestación secuencial:',
          'items': [
            'Leer MAIN_ORCHESTRATOR.md',
            'Identificar checkpoint pendiente',
            'Cargar el skill del agente necesario',
            'Ejecutar tarea y recibir output',
            'Validar y marcar como FIN',
          ],
          'correct_order': [0, 1, 2, 3, 4],
        }),
        'difficulty': 'medio',
        'points': 30,
      },

      // CATEGORÍA 2 (Agentes IA) - Sub 7 (¿Qué es?) - BÁSICO
      {
        'subcategory_id': 7,
        'level': 'basico',
        'exercise_type': 'fill_blank',
        'content': jsonEncode({
          'text':
              'Un agente en Antigravity es un sistema _____ que utiliza _____ para cumplir una _____ maestra.',
          'blanks': ['autónomo', 'skills', 'directiva'],
          'options': [
            'autónomo',
            'skills',
            'directiva',
            'manual',
            'herramientas',
            'variable',
          ],
        }),
        'difficulty': 'facil',
        'points': 20,
      },
    ];

    for (var ex in exercises) {
      await db.insert(
        'exercise_items',
        ex,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
}
