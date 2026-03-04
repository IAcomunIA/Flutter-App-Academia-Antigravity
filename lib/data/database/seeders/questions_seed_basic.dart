class QuestionsSeedBasic {
  static const List<Map<String, dynamic>> questions = [
    // ──────────────────────────────────────────────────────────────────────────
    // CAT 1: Inteligencia Artificial Fundamentos (SUB 1 - 6)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 1: ¿Qué es la IA? (ID 1)
    {
      'subcategory_id': 1,
      'question_text': '¿Qué significa IA?',
      'option_a': 'Inteligencia Autodidacta',
      'option_b': 'Inteligencia Artificial',
      'option_c': 'Información Automatizada',
      'option_d': 'Interfaz Avanzada',
      'correct_option': 'B',
      'explanation':
          'La Inteligencia Artificial busca crear sistemas que simulen procesos de inteligencia humana.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 1,
      'question_text':
          '¿Cuál de estos NO es un tipo clásico de Machine Learning?',
      'option_a': 'Supervisado',
      'option_b': 'No supervisado',
      'option_c': 'Por refuerzo',
      'option_d': 'Por telepatía',
      'correct_option': 'D',
      'explanation':
          'Los tres pilares son supervisado, no supervisado y por refuerzo.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },

    // Sub 2: Modelos de Lenguaje (LLMs) (ID 2)
    {
      'subcategory_id': 2,
      'question_text': '¿Cuál de estos es un ejemplo de un LLM?',
      'option_a': 'Photoshop',
      'option_b': 'Claude',
      'option_c': 'Excel',
      'option_d': 'Spotify',
      'correct_option': 'B',
      'explanation':
          'Claude (de Anthropic) es un modelo de lenguaje de gran escala.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 2: Agentes IA — Metodología Antigravity (SUB 7 - 12)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 7: ¿Qué es un Agente IA? (ID 7)
    {
      'subcategory_id': 7,
      'question_text':
          '¿Cuál es la diferencia principal entre un chatbot y un agente?',
      'option_a': 'El chatbot es más inteligente',
      'option_b': 'El agente puede ejecutar acciones de forma autónoma',
      'option_c': 'El chatbot es siempre gratis',
      'option_d': 'No hay ninguna diferencia',
      'correct_option': 'B',
      'explanation':
          'Un agente tiene capacidad de acción (operar herramientas, crear archivos, etc.).',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 3: Arquitectura de 4 Capas Antigravity (SUB 13 - 18)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 13: La Capa Maestro / Directiva (ID 13)
    {
      'subcategory_id': 13,
      'question_text':
          '¿Qué documento contiene las instrucciones maestras del proyecto en Antigravity?',
      'option_a': 'README.md',
      'option_b': 'MASTER_DIRECTIVE.md',
      'option_c': 'CONFIG.yaml',
      'option_d': 'INDEX.html',
      'correct_option': 'B',
      'explanation':
          'La MASTER_DIRECTIVE define el objetivo, las reglas y el contexto global para todos los agentes.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 13,
      'question_text': '¿En qué capa se define el "QUÉ" se debe construir?',
      'option_a': 'Capa 2 (Orquestador)',
      'option_b': 'Capa 1 (Directiva)',
      'option_c': 'Capa 3 (Agentes)',
      'option_d': 'Capa 4 (Output)',
      'correct_option': 'B',
      'explanation':
          'La Capa 1 es la que establece los objetivos y la visión del proyecto.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 4: Orquestación y Agentes Paralelos (SUB 19 - 24)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 19: Orquestación Básica (ID 19)
    {
      'subcategory_id': 19,
      'question_text': '¿Qué hace un Orquestador en el sistema Antigravity?',
      'option_a': 'Escribe todo el código solo',
      'option_b': 'Organiza y asigna tareas a los agentes ejecutores',
      'option_c': 'Es el usuario final que usa la app',
      'option_d': 'Limpia la base de datos cada hora',
      'correct_option': 'B',
      'explanation':
          'El orquestador gestiona el flujo de trabajo y decide qué agente entra en acción.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 5: MCP, Skills y Reglas Globales (SUB 25 - 30)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 25: ¿Qué es MCP? (ID 25)
    {
      'subcategory_id': 25,
      'question_text': '¿Para qué sirve el estándar MCP?',
      'option_a': 'Para comprimir imágenes sin pérdida',
      'option_b': 'Para conectar Modelos de IA con herramientas externas',
      'option_c': 'Para crear animaciones en CSS',
      'option_d': 'Para minar criptomonedas',
      'correct_option': 'B',
      'explanation':
          'Model Context Protocol es el estándar para dar superpoderes (conexiones) a los modelos.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },
  ];
}
