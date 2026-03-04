import 'package:sqflite/sqflite.dart';

/// Seeder de los 16 badges V2
class BadgesSeed {
  static Future<void> seed(Database db) async {
    final badges = [
      {
        'id': 'primer_despegue',
        'name': 'Primer Despegue',
        'description': 'Completar tu primer quiz',
        'icon': 'rocket_launch',
        'condition_type': 'quiz_count',
        'condition_value': 1,
      },
      {
        'id': 'punteria_perfecta',
        'name': 'Puntería Perfecta',
        'description': '100% en cualquier quiz',
        'icon': 'military_tech',
        'condition_type': 'perfect_score',
        'condition_value': 100,
      },
      {
        'id': 'en_llamas',
        'name': 'En Llamas',
        'description': 'Racha de 7 días consecutivos',
        'icon': 'local_fire_department',
        'condition_type': 'streak_days',
        'condition_value': 7,
      },
      {
        'id': 'explorador',
        'name': 'Explorador',
        'description': '10 subcategorías completadas',
        'icon': 'explore',
        'condition_type': 'subcategories_completed',
        'condition_value': 10,
      },
      {
        'id': 'maestro_ia',
        'name': 'Maestro IA',
        'description': 'Todas las subcategorías nivel básico completadas',
        'icon': 'psychology',
        'condition_type': 'all_basic_completed',
        'condition_value': 1,
      },
      {
        'id': 'velocista',
        'name': 'Velocista',
        'description': 'Quiz completado en menos de 60 segundos',
        'icon': 'speed',
        'condition_type': 'fast_quiz',
        'condition_value': 60,
      },
      {
        'id': 'perfeccionista',
        'name': 'Perfeccionista',
        'description': '3 estrellas en 5 quizzes seguidos',
        'icon': 'workspace_premium',
        'condition_type': 'consecutive_3stars',
        'condition_value': 5,
      },
      {
        'id': 'comandante',
        'name': 'Comandante',
        'description': 'Alcanzar nivel 5',
        'icon': 'stars',
        'condition_type': 'user_level',
        'condition_value': 5,
      },
      {
        'id': 'arquitecto_digital',
        'name': 'Arquitecto de 4 Capas',
        'description':
            'Completar categoría Arquitectura 4 Capas nivel avanzado',
        'icon': 'architecture',
        'condition_type': 'category_advanced',
        'condition_value': 3,
      },
      {
        'id': 'orquestador',
        'name': 'Maestro Orquestador',
        'description': 'Completar categoría Orquestación nivel avanzado',
        'icon': 'hub',
        'condition_type': 'category_advanced',
        'condition_value': 4,
      },
      {
        'id': 'maestro_memoria',
        'name': 'Maestro de la Memoria',
        'description': 'Memory game sin errores',
        'icon': 'memory',
        'condition_type': 'memory_perfect',
        'condition_value': 1,
      },
      {
        'id': 'guerrero_battle',
        'name': 'Guerrero Battle',
        'description': 'Battle mode con racha x5',
        'icon': 'whatshot',
        'condition_type': 'battle_streak',
        'condition_value': 5,
      },
      {
        'id': 'mcp_master',
        'name': 'Dominio MCP',
        'description':
            'Completar categoría MCP, Skills y Reglas nivel avanzado',
        'icon': 'code',
        'condition_type': 'category_advanced',
        'condition_value': 5,
      },
      {
        'id': 'simulador_experto',
        'name': 'Simulador Experto',
        'description': 'Simulador correcto en todos los casos',
        'icon': 'precision_manufacturing',
        'condition_type': 'simulator_all_correct',
        'condition_value': 1,
      },
      {
        'id': 'maratonista',
        'name': 'Maratonista',
        'description': '50 quizzes completados',
        'icon': 'directions_run',
        'condition_type': 'quiz_count',
        'condition_value': 50,
      },
      {
        'id': 'leyenda_antigravity',
        'name': 'Leyenda Antigravity',
        'description': 'Alcanzar nivel 8 (Orquestador)',
        'icon': 'emoji_events',
        'condition_type': 'user_level',
        'condition_value': 8,
      },
    ];

    for (final badge in badges) {
      await db.insert(
        'badges',
        badge,
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
}
