class QuestionsSeedAdvanced {
  static const List<Map<String, dynamic>> questions = [
    // CAT 3: Arquitectura
    {
      'subcategory_id': 17,
      'question_text':
          '¿Cómo se maneja la consistencia de estado entre Capa 2 y Capa 3 en sistemas distribuidos Antigravity?',
      'option_a': 'Con variables globales en memoria RAM',
      'option_b':
          'Mediante persistencia de checkpoints y validación de outputs',
      'option_c': 'Reiniciando el sistema cada 10 tokens',
      'option_d': 'No es necesaria la consistencia',
      'correct_option': 'B',
      'explanation':
          'La persistencia asegura que si un agente falla, el orquestador sepa exactamente dónde retomar.',
      'difficulty': 'dificil',
      'level': 'avanzado',
      'points': 20,
    },

    // CAT 4: Orquestación
    {
      'subcategory_id': 21,
      'question_text':
          'Al ejecutar agentes en paralelo, ¿qué estrategia se usa para reunir sus resultados?',
      'option_a': 'First-come-first-served',
      'option_b': 'Fan-in con un agente agregador o reductor',
      'option_c': 'Sobreescribir el mismo archivo a la vez',
      'option_d': 'Ignorar los resultados más lentos',
      'correct_option': 'B',
      'explanation':
          'El patrón Fan-in utiliza un nodo final para consolidar los outputs de los agentes paralelos.',
      'difficulty': 'dificil',
      'level': 'avanzado',
      'points': 20,
    },

    // CAT 5: MCP
    {
      'subcategory_id': 26,
      'question_text':
          'En la arquitectura MCP, ¿qué es un "Resource" (Recurso) a diferencia de una "Tool" (Herramienta)?',
      'option_a':
          'Un recurso es de solo lectura; una herramienta puede ejecutar acciones',
      'option_b': 'Son exactamente lo mismo',
      'option_c':
          'La herramienta es de solo lectura y el recurso es ejecutable',
      'option_d': 'Un recurso solo se usa en Python',
      'correct_option': 'A',
      'explanation':
          'Resources exponen datos; Tools exponen capacidades de acción (side effects).',
      'difficulty': 'dificil',
      'level': 'avanzado',
      'points': 20,
    },
  ];
}
