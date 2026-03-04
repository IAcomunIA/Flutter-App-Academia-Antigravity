class QuestionsSeed {
  static const List<Map<String, dynamic>> questions = [
    // ──────────────────────────────────────────────────────────────────────────
    // CAT 1: Inteligencia Artificial Fundamentos (SUB 1 - 6)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 1: ¿Qué es la IA? (ID 1)
    {
      'subcategory_id': 1,
      'question_text':
          '¿Quién propuso en 1950 la prueba de imitación para determinar si una máquina puede pensar?',
      'option_a': 'John McCarthy',
      'option_b': 'Alan Turing',
      'option_c': 'Marvin Minsky',
      'option_d': 'Andrew Ng',
      'correct_option': 'B',
      'explanation':
          'Alan Turing propuso el "Turing Test" en su artículo "Computing Machinery and Intelligence".',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 1,
      'question_text':
          '¿En qué año se acuñó el término "Inteligencia Artificial" durante la conferencia de Dartmouth?',
      'option_a': '1945',
      'option_b': '1956',
      'option_c': '1962',
      'option_d': '1950',
      'correct_option': 'B',
      'explanation':
          'La conferencia de Dartmouth en 1956 es considerada el nacimiento oficial de la IA.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // Sub 2: Modelos de Lenguaje (LLMs) (ID 2)
    {
      'subcategory_id': 2,
      'question_text': '¿Qué significa la sigla GPT en el mundo de la IA?',
      'option_a': 'General Purpose Transformer',
      'option_b': 'Generative Pre-trained Transformer',
      'option_c': 'Global Process Training',
      'option_d': 'Generative Python Tool',
      'correct_option': 'B',
      'explanation':
          'GPT se refiere a modelos de lenguaje que son pre-entrenados y usan la arquitectura Transformer.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 2,
      'question_text':
          '¿Cuál de estos conceptos se refiere a la capacidad de un modelo de procesar una cantidad limitada de información a la vez?',
      'option_a': 'Temperature',
      'option_b': 'Top_p',
      'option_c': 'Context Window',
      'option_d': 'Hallucinacion',
      'correct_option': 'C',
      'explanation':
          'La "ventana de contexto" define cuántos tokens puede ver y recordar el modelo simultáneamente.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 2: Agentes IA — Metodología Antigravity (SUB 7 - 12)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 7: ¿Qué es un Agente IA? (ID 7)
    {
      'subcategory_id': 7,
      'question_text':
          'A diferencia de un Chatbot, ¿cuál es la característica principal de un Agente IA en la metodología Antigravity?',
      'option_a': 'Tener una voz humana',
      'option_b': 'Autonomía para ejecutar acciones',
      'option_c': 'Responder más rápido',
      'option_d': 'Usar emojis',
      'correct_option': 'B',
      'explanation':
          'Un agente no solo charla, sino que puede tomar decisiones y ejecutar tareas de forma autónoma.',
      'difficulty': 'facil',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 7,
      'question_text':
          'En Antigravity, un agente que analiza su propio razonamiento antes de actuar está realizando:',
      'option_a': 'Memory Access',
      'option_b': 'Reflection',
      'option_c': 'Hardcoding',
      'option_d': 'Tokenization',
      'correct_option': 'B',
      'explanation':
          'La reflexión permite al agente evaluar su plan y corregirlo antes de ejecutarlo.',
      'difficulty': 'dificil',
      'level': 'avanzado',
      'points': 20,
    },

    // Sub 8: Skills de un Agente (ID 8)
    {
      'subcategory_id': 8,
      'question_text':
          '¿Cómo se llama el archivo central que define las capacidades de una skill en Antigravity?',
      'option_a': 'SKILL.json',
      'option_b': 'SKILL.md',
      'option_c': 'MANIFEST.yaml',
      'option_d': 'README.txt',
      'correct_option': 'B',
      'explanation':
          'La metodología Antigravity utiliza archivos SKILL.md en Markdown para documentar las capacidades.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 3: Arquitectura de 4 Capas (SUB 13 - 18)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 13: La Capa Maestro / Directiva (ID 13)
    {
      'subcategory_id': 13,
      'question_text':
          '¿Cuál es el rol principal de la capa "Maestro" o "Directiva" en la arquitectura Antigravity?',
      'option_a': 'Ejecutar el código Python',
      'option_b': 'Establecer los objetivos y restricciones globales',
      'option_c': 'Almacenar la base de datos',
      'option_d': 'Mostrar la interfaz de usuario',
      'correct_option': 'B',
      'explanation':
          'La Directiva define el "qué" y el "cómo" a alto nivel, guiando a todo el sistema.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 14,
      'question_text':
          '¿Qué componente se encarga de asignar tareas específicas a los agentes y gestionar el flujo de trabajo?',
      'option_a': 'La Directiva',
      'option_b': 'El Orquestador',
      'option_c': 'El Usuario',
      'option_d': 'El Driver de SQL',
      'correct_option': 'B',
      'explanation':
          'El Orquestador actúa como el director de orquesta, coordinando las acciones de los agentes.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 5: MCP, Skills y Reglas (SUB 25 - 30)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 25: ¿Qué es MCP? (ID 25)
    {
      'subcategory_id': 25,
      'question_text':
          '¿Qué significa la sigla MCP en la arquitectura de agentes modernos?',
      'option_a': 'Multi-Core Processing',
      'option_b': 'Model Context Protocol',
      'option_c': 'Master Control Program',
      'option_d': 'MetaData Connection Path',
      'correct_option': 'B',
      'explanation':
          'MCP es el estándar para conectar modelos de IA con herramientas y datos externos.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 25,
      'question_text':
          '¿Quién es el creador principal de la especificación Model Context Protocol?',
      'option_a': 'OpenAI',
      'option_b': 'Anthropic',
      'option_c': 'Google DeepMind',
      'option_d': 'Meta',
      'correct_option': 'B',
      'explanation':
          'Anthropic lanzó MCP para estandarizar cómo los modelos acceden a herramientas.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // ──────────────────────────────────────────────────────────────────────────
    // CAT 4: Orquestación y Agentes Paralelos (SUB 19 - 24)
    // ──────────────────────────────────────────────────────────────────────────

    // Sub 19: Orquestación Básica (ID 19)
    {
      'subcategory_id': 19,
      'question_text':
          '¿Cuál es la principal ventaja de ejecutar agentes en paralelo en un flujo Antigravity?',
      'option_a': 'Consumir más tokens',
      'option_b': 'Reducir el tiempo total de ejecución (latencia)',
      'option_c': 'Hacer el código más difícil de leer',
      'option_d': 'Evitar usar el Orquestador',
      'correct_option': 'B',
      'explanation':
          'El paralelismo permite que múltiples tareas se realicen al mismo tiempo.',
      'difficulty': 'medio',
      'level': 'basico',
      'points': 10,
    },
    {
      'subcategory_id': 19,
      'question_text':
          '¿Qué patrón de orquestación se usa cuando el output de un Agente A es necesario como input para el Agente B?',
      'option_a': 'Paralelo',
      'option_b': 'Secuencial (Pipeline)',
      'option_c': 'Broadcast',
      'option_d': 'Fan-out',
      'correct_option': 'B',
      'explanation':
          'La orquestación secuencial asegura que la información fluya correctamente entre pasos dependientes.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },
  ];
}
