class CategoriesSeed {
  static const List<Map<String, dynamic>> categories = [
    {
      'id': 1,
      'name': 'Inteligencia Artificial Fundamentos',
      'description':
          'Base conceptual de IA que todo agente Antigravity debe dominar.',
      'icon': 'smart_toy',
      'color': '0xFF00D4FF',
      'difficulty': 'facil',
      'order_index': 0,
    },
    {
      'id': 2,
      'name': 'Agentes IA — Metodología Antigravity',
      'description':
          'Todo sobre qué es un agente, cómo se construye y cómo se comporta dentro de Antigravity.',
      'icon': 'psychology',
      'color': '0xFF7B2FBE',
      'difficulty': 'medio',
      'order_index': 1,
    },
    {
      'id': 3,
      'name': 'Arquitectura de 4 Capas Antigravity',
      'description':
          'La arquitectura propia: Maestro Directiva → Orquestador → Agentes → Output.',
      'icon': 'layers',
      'color': '0xFFF97316',
      'difficulty': 'medio',
      'order_index': 2,
    },
    {
      'id': 4,
      'name': 'Orquestación y Agentes Paralelos',
      'description':
          'Orquestación básica y avanzada, agentes en paralelo, coordinación y sincronización.',
      'icon': 'account_tree',
      'color': '0xFF0891B2',
      'difficulty': 'dificil',
      'order_index': 3,
    },
    {
      'id': 5,
      'name': 'MCP, Skills y Reglas Globales',
      'description':
          'Model Context Protocol, construcción de skills, y diseño de reglas globales.',
      'icon': 'rule',
      'color': '0xFFA855F7',
      'difficulty': 'avanzado',
      'order_index': 4,
    },
  ];

  static const List<Map<String, dynamic>> subcategories = [
    // CAT 1
    {
      'id': 1,
      'category_id': 1,
      'name': '¿Qué es la IA?',
      'description': 'Historia y conceptos básicos',
      'order_index': 0,
    },
    {
      'id': 2,
      'category_id': 1,
      'name': 'Modelos de Lenguaje (LLMs)',
      'description': 'Conceptos de LLM',
      'order_index': 1,
    },
    {
      'id': 3,
      'category_id': 1,
      'name': 'Prompt Engineering',
      'description': 'Cómo comunicarse con IA',
      'order_index': 2,
    },
    {
      'id': 4,
      'category_id': 1,
      'name': 'Herramientas de IA actuales',
      'description': 'Herramientas',
      'order_index': 3,
    },
    {
      'id': 5,
      'category_id': 1,
      'name': 'Ética y Límites de la IA',
      'description': 'Límites éticos',
      'order_index': 4,
    },
    {
      'id': 6,
      'category_id': 1,
      'name': 'IA como herramienta Antigravity',
      'description': 'Uso diario',
      'order_index': 5,
    },

    // CAT 2
    {
      'id': 7,
      'category_id': 2,
      'name': '¿Qué es un Agente IA?',
      'description': 'Definiciones de agentes',
      'order_index': 0,
    },
    {
      'id': 8,
      'category_id': 2,
      'name': 'Skills de un Agente Antigravity',
      'description': 'Construcción de skills',
      'order_index': 1,
    },
    {
      'id': 9,
      'category_id': 2,
      'name': 'Reglas Globales del Agente',
      'description': 'Reglas generales',
      'order_index': 2,
    },
    {
      'id': 10,
      'category_id': 2,
      'name': 'Comportamiento y Toma de Decisiones',
      'description': 'Análisis y decisiones',
      'order_index': 3,
    },
    {
      'id': 11,
      'category_id': 2,
      'name': 'Memoria de Agentes',
      'description': 'Vectorización y memoria',
      'order_index': 4,
    },
    {
      'id': 12,
      'category_id': 2,
      'name': 'Casos Reales Antigravity',
      'description': 'Casos prácticos',
      'order_index': 5,
    },

    // CAT 3
    {
      'id': 13,
      'category_id': 3,
      'name': 'La Capa Maestro / Directiva',
      'description': 'Cómo crear directivas',
      'order_index': 0,
    },
    {
      'id': 14,
      'category_id': 3,
      'name': 'La Capa Orquestador',
      'description': 'Control central',
      'order_index': 1,
    },
    {
      'id': 15,
      'category_id': 3,
      'name': 'La Capa Agentes (ejecutores)',
      'description': 'Agentes especializados',
      'order_index': 2,
    },
    {
      'id': 16,
      'category_id': 3,
      'name': 'La Capa Output y Validación',
      'description': 'Outputs del sistema',
      'order_index': 3,
    },
    {
      'id': 17,
      'category_id': 3,
      'name': 'Flujo Completo de 4 Capas',
      'description': 'Integración',
      'order_index': 4,
    },
    {
      'id': 18,
      'category_id': 3,
      'name': 'Errores comunes en la Arquitectura',
      'description': 'Anti-patrones',
      'order_index': 5,
    },

    // CAT 4
    {
      'id': 19,
      'category_id': 4,
      'name': 'Orquestación Básica',
      'description': 'Flujos lineales',
      'order_index': 0,
    },
    {
      'id': 20,
      'category_id': 4,
      'name': 'Orquestación Avanzada y Patrones',
      'description': 'Patrones',
      'order_index': 1,
    },
    {
      'id': 21,
      'category_id': 4,
      'name': 'Agentes en Paralelo',
      'description': 'Sincronización',
      'order_index': 2,
    },
    {
      'id': 22,
      'category_id': 4,
      'name': 'Checkpoints y Validación',
      'description': 'Puntos de control',
      'order_index': 3,
    },
    {
      'id': 23,
      'category_id': 4,
      'name': 'Manejo de Errores',
      'description': 'Recuperación de flujos',
      'order_index': 4,
    },
    {
      'id': 24,
      'category_id': 4,
      'name': 'Diseño de Flujos Reales',
      'description': 'Diagramas',
      'order_index': 5,
    },

    // CAT 5
    {
      'id': 25,
      'category_id': 5,
      'name': '¿Qué es MCP?',
      'description': 'Protocolo',
      'order_index': 0,
    },
    {
      'id': 26,
      'category_id': 5,
      'name': 'MCP Servers y Herramientas',
      'description': 'Conexión a herramientas',
      'order_index': 1,
    },
    {
      'id': 27,
      'category_id': 5,
      'name': 'Skills Antigravity — Construcción',
      'description': 'Crear skills',
      'order_index': 2,
    },
    {
      'id': 28,
      'category_id': 5,
      'name': 'Skills Antigravity — Uso y Composición',
      'description': 'Uso dinámico',
      'order_index': 3,
    },
    {
      'id': 29,
      'category_id': 5,
      'name': 'Reglas Globales — Diseño',
      'description': 'Diseño de reglas',
      'order_index': 4,
    },
    {
      'id': 30,
      'category_id': 5,
      'name': 'Reglas Globales — Aplicación',
      'description': 'Aplicación de reglas',
      'order_index': 5,
    },
  ];
}
