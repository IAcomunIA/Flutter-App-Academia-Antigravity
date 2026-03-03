class CategoriesSeed {
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Inteligencia Artificial Fundamentos',
      'description': 'Conceptos básicos, historia y tipos de IA',
      'icon': 'smart_toy',
      'color': '0xFF00D4FF',
      'difficulty': 'facil',
      'order_index': 0,
    },
    {
      'id': 2,
      'name': 'Agentes IA — Antigravity',
      'description': 'Arquitectura de 4 capas y orquestación',
      'icon': 'rocket_launch',
      'color': '0xFF7B2FBE',
      'difficulty': 'medio',
      'order_index': 1,
    },
    {
      'id': 3,
      'name': 'Programación con Python',
      'description': 'Variables, funciones y módulos para IA',
      'icon': 'terminal',
      'color': '0xFF10B981',
      'difficulty': 'medio',
      'order_index': 2,
    },
    {
      'id': 4,
      'name': 'Arquitecturas de Software',
      'description': 'Patrones, APIs y bases de datos',
      'icon': 'architecture',
      'color': '0xFFF59E0B',
      'difficulty': 'dificil',
      'order_index': 3,
    },
    {
      'id': 5,
      'name': 'Productividad con IA',
      'description': 'Prompt Engineering y herramientas',
      'icon': 'bolt',
      'color': '0xFFEC4899',
      'difficulty': 'facil',
      'order_index': 4,
    },
  ];

  static const List<Map<String, dynamic>> subcategories = [
    {'id': 1, 'category_id': 1, 'name': '¿Qué es la IA?', 'description': 'Historia y conceptos básicos', 'order_index': 0},
    {'id': 2, 'category_id': 1, 'name': 'Machine Learning', 'description': 'Aprendizaje automático', 'order_index': 1},
  ];
}
