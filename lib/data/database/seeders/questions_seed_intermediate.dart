class QuestionsSeedIntermediate {
  static const List<Map<String, dynamic>> questions = [
    // CAT 1: IA Fundamentos
    {
      'subcategory_id': 2,
      'question_text':
          '¿Cómo afecta una "Temperatura" alta el output de un LLM?',
      'option_a': 'Hace que el servidor se caliente',
      'option_b': 'Hace que el modelo sea más creativo y aleatorio',
      'option_c': 'Hace que el modelo sea más determinista y aburrido',
      'option_d': 'Reduce el costo de los tokens',
      'correct_option': 'B',
      'explanation':
          'La temperatura controla la aleatoriedad. >0.7 es creativo, <0.3 es preciso.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // CAT 2: Agentes IA
    {
      'subcategory_id': 8,
      'question_text':
          '¿Qué información debe contener obligatoriamente un archivo SKILL.md?',
      'option_a': 'El número de teléfono del desarrollador',
      'option_b':
          'Instrucciones detalladas y herramientas disponibles del skill',
      'option_c': 'Una lista de memes de programación',
      'option_d': 'La política de privacidad de la empresa',
      'correct_option': 'B',
      'explanation':
          'SKILL.md define el prompt del sistema para una habilidad específica.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // CAT 3: Arquitectura 4 Capas
    {
      'subcategory_id': 14,
      'question_text':
          'En Antigravity, ¿qué ocurre si un checkpoint falla dos veces?',
      'option_a': 'Se intenta una tercera vez automáticamente',
      'option_b': 'Se marca el flujo como BLOCKED y se notifica al humano',
      'option_c': 'Se borra todo el proyecto',
      'option_d': 'Se reinicia desde la Capa 1',
      'correct_option': 'B',
      'explanation':
          'La regla de oro: después de 2 fallos se bloquea para evitar bucles infinitos de tokens.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // CAT 4: Orquestación
    {
      'subcategory_id': 20,
      'question_text':
          '¿Qué es un "Pipeline" en el contexto de orquestación de agentes?',
      'option_a': 'Un tubo de drenaje físico',
      'option_b':
          'Un flujo donde el output de un agente es el input del siguiente',
      'option_c': 'Una lista de tareas sin orden específico',
      'option_d': 'Un agente que solo lee logs',
      'correct_option': 'B',
      'explanation':
          'El pipeline conecta agentes en una cadena de procesamiento secuencial.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },

    // CAT 5: MCP y Reglas
    {
      'subcategory_id': 25,
      'question_text':
          '¿Qué ventaja principal ofrece usar MCP Servers locales sobre APIs REST directas?',
      'option_a': 'Ninguna, es lo mismo',
      'option_b': 'Estandarización de herramientas para múltiples modelos',
      'option_c': 'Que no requieren internet nunca',
      'option_d': 'Que son más baratos que ChatGPT',
      'correct_option': 'B',
      'explanation':
          'MCP permite que cualquier modelo (Claude, GPT, etc.) use la misma herramienta sin recodificar.',
      'difficulty': 'medio',
      'level': 'intermedio',
      'points': 15,
    },
  ];
}
