import 'package:antigravity_quiz/data/models/exercise.dart';

/// Banco de ejercicios 100% Antigravity.
/// Módulo 1: IA Fundamentos (cultura general).
/// Módulos 2-5: Exclusivamente sobre la arquitectura Antigravity.
class ExerciseBank {
  static List<Exercise> getExercisesForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return _aiFoundations();
      case 2:
        return _fourLayerArchitecture();
      case 3:
        return _mcpAndGlobalRules();
      case 4:
        return _agentsAndSkills();
      case 5:
        return _advancedOrchestration();
      default:
        return _aiFoundations();
    }
  }

  // ───── MÓDULO 1: IA Fundamentos (cultura general — se mantiene) ─────
  static List<Exercise> _aiFoundations() => [
    Exercise(
      id: 101,
      subcategoryId: 1,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Quién propuso el test que evalúa si una máquina puede pensar?',
      optionA: 'Ada Lovelace',
      optionB: 'Alan Turing',
      optionC: 'John McCarthy',
      optionD: 'Marvin Minsky',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'Alan Turing propuso en 1950 el "Juego de la Imitación", conocido como el Test de Turing.',
    ),
    Exercise(
      id: 102,
      subcategoryId: 1,
      type: ExerciseType.dragAndDrop,
      questionText: 'Arrastra cada concepto a su definición correcta:',
      items: ['Machine Learning', 'Deep Learning', 'NLP', 'Computer Vision'],
      targets: [
        'Aprende de datos sin programación explícita',
        'Redes neuronales profundas',
        'Procesamiento de lenguaje natural',
        'Análisis de imágenes y video',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'ML es aprendizaje automático, DL usa redes profundas, NLP procesa lenguaje y CV analiza imágenes.',
    ),
    Exercise(
      id: 103,
      subcategoryId: 1,
      type: ExerciseType.multiSelect,
      questionText:
          '¿Cuáles son tipos de aprendizaje automático? (Selecciona los correctos)',
      options: [
        'Supervisado',
        'No supervisado',
        'Por refuerzo',
        'Cuántico',
        'Gravitacional',
      ],
      correctIndices: [0, 1, 2],
      points: 15,
      difficulty: 'medio',
      explanation:
          'Los 3 tipos clásicos de ML son: supervisado, no supervisado y por refuerzo.',
    ),
    Exercise(
      id: 104,
      subcategoryId: 1,
      type: ExerciseType.commandInput,
      questionText:
          '¿Qué siglas en inglés se usan para "Inteligencia Artificial"?',
      hint: 'Dos letras mayúsculas...',
      acceptedAnswers: ['AI', 'ai', 'A.I.', 'a.i.'],
      points: 10,
      difficulty: 'facil',
      explanation:
          'AI viene de "Artificial Intelligence", el término acuñado por John McCarthy en 1956.',
    ),
    Exercise(
      id: 105,
      subcategoryId: 1,
      type: ExerciseType.ordering,
      questionText: 'Ordena los pasos del proceso de Machine Learning:',
      items: [
        'Recolectar datos',
        'Preprocesar datos',
        'Entrenar modelo',
        'Evaluar modelo',
        'Desplegar',
      ],
      correctOrder: [0, 1, 2, 3, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'El flujo estándar es: datos → preprocesamiento → entrenamiento → evaluación → despliegue.',
    ),
    Exercise(
      id: 106,
      subcategoryId: 1,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué modelo de OpenAI popularizó la IA generativa de texto en 2022?',
      optionA: 'DALL-E',
      optionB: 'Whisper',
      optionC: 'ChatGPT',
      optionD: 'Codex',
      correctOption: 'C',
      points: 10,
      difficulty: 'facil',
      explanation:
          'ChatGPT, basado en GPT-3.5/4, democratizó el acceso a la IA conversacional.',
    ),
    Exercise(
      id: 107,
      subcategoryId: 1,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué técnica hace que un modelo de IA "piense paso a paso"?',
      optionA: 'Zero-shot',
      optionB: 'Chain of Thought',
      optionC: 'Fine-tuning',
      optionD: 'RAG',
      correctOption: 'B',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Chain of Thought (CoT) pide al modelo razonar paso a paso antes de dar una respuesta final.',
    ),
    Exercise(
      id: 108,
      subcategoryId: 1,
      type: ExerciseType.dragAndDrop,
      questionText: 'Conecta cada término con su aplicación:',
      items: ['GPT', 'DALL-E', 'Whisper', 'Stable Diffusion'],
      targets: [
        'Generación de texto',
        'Imágenes (cerrado)',
        'Transcripción de audio',
        'Imágenes (open-source)',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 15,
      difficulty: 'medio',
      explanation:
          'GPT genera texto, DALL-E genera imágenes (cerrado), Whisper transcribe audio, SD genera imágenes (abierto).',
    ),
  ];

  // ───── MÓDULO 2: Arquitectura de 4 Capas Antigravity ─────
  static List<Exercise> _fourLayerArchitecture() => [
    Exercise(
      id: 201,
      subcategoryId: 2,
      type: ExerciseType.multipleChoice,
      questionText: '¿Cuántas capas tiene la arquitectura Antigravity?',
      optionA: '2',
      optionB: '3',
      optionC: '4',
      optionD: '6',
      correctOption: 'C',
      points: 10,
      difficulty: 'facil',
      explanation:
          'Antigravity usa exactamente 4 capas: Directiva, Orquestación, Ejecución y Observabilidad.',
    ),
    Exercise(
      id: 202,
      subcategoryId: 2,
      type: ExerciseType.ordering,
      questionText: 'Ordena las 4 capas de Antigravity de arriba a abajo:',
      items: [
        'Directiva Maestra',
        'Orquestador',
        'Agentes de Ejecución',
        'Observabilidad',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Directiva define QUÉ → Orquestador decide CUÁNDO → Agentes ejecutan CÓMO → Observabilidad registra TODO.',
    ),
    Exercise(
      id: 203,
      subcategoryId: 2,
      type: ExerciseType.dragAndDrop,
      questionText: 'Empareja cada capa con su responsabilidad principal:',
      items: [
        'Capa 1 — Directiva',
        'Capa 2 — Orquestador',
        'Capa 3 — Agentes',
        'Capa 4 — Observabilidad',
      ],
      targets: [
        'Define el QUÉ construir',
        'Controla el CUÁNDO y el orden',
        'Ejecuta el CÓMO paso a paso',
        'Registra y audita TODO',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Cada capa tiene una responsabilidad clara y no debe mezclar funciones de otra capa.',
    ),
    Exercise(
      id: 204,
      subcategoryId: 2,
      type: ExerciseType.commandInput,
      questionText:
          '¿Cómo se llama el archivo principal que define el objetivo del proyecto?',
      hint: 'Pista: MASTER_...',
      acceptedAnswers: [
        'MASTER_DIRECTIVE',
        'MASTER_DIRECTIVA',
        'master_directive',
        'MASTER_DIRECTIVE.md',
        'MASTER_DIRECTIVA.md',
      ],
      points: 15,
      difficulty: 'medio',
      explanation:
          'MASTER_DIRECTIVE.md (o MASTER_DIRECTIVA.md) es el archivo sagrado que todo agente debe leer primero.',
    ),
    Exercise(
      id: 205,
      subcategoryId: 2,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué principio fundamental deben seguir los agentes en Antigravity?',
      optionA: 'Creatividad libre',
      optionB: 'Ejecución determinista',
      optionC: 'Improvisación adaptativa',
      optionD: 'Aprendizaje continuo',
      correctOption: 'B',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Los LLMs son probabilísticos, pero la ejecución y el monitoreo DEBEN ser deterministas.',
    ),
    Exercise(
      id: 206,
      subcategoryId: 2,
      type: ExerciseType.multiSelect,
      questionText:
          '¿Cuáles son archivos típicos de la Capa 1 (Directiva) en Antigravity?',
      options: [
        'MASTER_DIRECTIVE.md',
        'checkpoint_1.py',
        'app_colors.dart',
        'CLAUDE.md',
        'GEMINI.md',
        'logger.py',
      ],
      correctIndices: [0, 3, 4],
      points: 15,
      difficulty: 'medio',
      explanation:
          'La Capa 1 contiene las directivas: MASTER_DIRECTIVE.md, CLAUDE.md y GEMINI.md replican las reglas para cada IA.',
    ),
    Exercise(
      id: 207,
      subcategoryId: 2,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué debe hacer un agente si falla 2 veces consecutivas en un checkpoint?',
      optionA: 'Reintentar indefinidamente',
      optionB: 'Saltar al siguiente checkpoint',
      optionC: 'Marcar BLOCKED y notificar al humano',
      optionD: 'Eliminar el checkpoint',
      correctOption: 'C',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Tras 2 fallos → estado BLOCKED → notificar al humano. Nunca continuar con errores críticos.',
    ),
    Exercise(
      id: 208,
      subcategoryId: 2,
      type: ExerciseType.ordering,
      questionText: 'Ordena el flujo correcto de un checkpoint en Antigravity:',
      items: [
        '[INICIO] Log del checkpoint',
        'Leer directiva maestra',
        'Ejecutar la tarea',
        'Validar resultado',
        '[FIN] Log con COMPLETED o FAILED',
      ],
      correctOrder: [0, 1, 2, 3, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'Todo checkpoint: log inicio → leer directiva → ejecutar → validar → log fin. Sin excepciones.',
    ),
  ];

  // ───── MÓDULO 3: MCP y Reglas Globales ─────
  static List<Exercise> _mcpAndGlobalRules() => [
    Exercise(
      id: 301,
      subcategoryId: 3,
      type: ExerciseType.multipleChoice,
      questionText: '¿Qué significa MCP en el contexto de agentes de IA?',
      optionA: 'Master Control Program',
      optionB: 'Model Context Protocol',
      optionC: 'Multi-Channel Processor',
      optionD: 'Machine Code Pipeline',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'MCP = Model Context Protocol. Es el protocolo estándar para que los modelos accedan a herramientas y recursos.',
    ),
    Exercise(
      id: 302,
      subcategoryId: 3,
      type: ExerciseType.multiSelect,
      questionText:
          '¿Qué proporciona un servidor MCP a un agente? (Selecciona todos)',
      options: [
        'Herramientas (tools)',
        'Recursos (resources)',
        'Prompts reutilizables',
        'Entrenamiento del modelo',
        'Conexión a bases de datos mágicas',
      ],
      correctIndices: [0, 1, 2],
      points: 15,
      difficulty: 'medio',
      explanation:
          'MCP expone 3 primitivas: tools (funciones), resources (datos) y prompts (templates reutilizables).',
    ),
    Exercise(
      id: 303,
      subcategoryId: 3,
      type: ExerciseType.commandInput,
      questionText:
          '¿Qué formato de log se usa al INICIAR un checkpoint en Antigravity?',
      hint: 'Una etiqueta entre corchetes...',
      acceptedAnswers: ['[INICIO]', 'INICIO', '[inicio]'],
      points: 10,
      difficulty: 'facil',
      explanation:
          'El formato obligatorio es: [INICIO] Checkpoint X: nombre_del_checkpoint.',
    ),
    Exercise(
      id: 304,
      subcategoryId: 3,
      type: ExerciseType.dragAndDrop,
      questionText: 'Empareja cada etiqueta de log con su uso:',
      items: ['[INICIO]', '[ARCHIVO]', '[ERROR]', '[FIN]'],
      targets: [
        'Comienzo de un checkpoint',
        'Archivo creado o modificado',
        'Descripción de fallo en archivo:línea',
        'Checkpoint COMPLETED o FAILED',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Cada acción tiene su etiqueta: [INICIO], [ARCHIVO], [DB], [SEED], [XP], [BADGE], [ERROR], [FIN].',
    ),
    Exercise(
      id: 305,
      subcategoryId: 3,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Cuál es la regla sobre colores en el código de Antigravity?',
      optionA: 'Usar Color(0xFF...) donde sea necesario',
      optionB: 'Solo usar colores de AppColors, cero hardcodeados',
      optionC: 'Los colores se definen en cada widget',
      optionD: 'No hay regla específica',
      correctOption: 'B',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Regla absoluta: cero colores hardcodeados. Usar EXCLUSIVAMENTE AppColors y AppTextStyles.',
    ),
    Exercise(
      id: 306,
      subcategoryId: 3,
      type: ExerciseType.multiSelect,
      questionText: '¿Cuáles son reglas globales de código en Antigravity?',
      options: [
        'Riverpod para state management',
        'GoRouter para navegación',
        'Sin print() — usar logger',
        'Permitir setState para lógica de negocio',
        'dispose() en todos los StatefulWidgets con controllers',
      ],
      correctIndices: [0, 1, 2, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'setState para lógica de negocio está PROHIBIDO. Se usa Riverpod. El resto son reglas obligatorias.',
    ),
    Exercise(
      id: 307,
      subcategoryId: 3,
      type: ExerciseType.commandInput,
      questionText:
          '¿Qué etiqueta de log se usa cuando se inserta contenido en la base de datos?',
      hint: 'Relacionada con semillas...',
      acceptedAnswers: ['[SEED]', 'SEED', '[seed]'],
      points: 15,
      difficulty: 'medio',
      explanation:
          '[SEED] se usa para registrar contenido insertado con métricas (ej: "30 categorías insertadas").',
    ),
    Exercise(
      id: 308,
      subcategoryId: 3,
      type: ExerciseType.ordering,
      questionText: 'Ordena las reglas de manejo de errores en Antigravity:',
      items: [
        'Detectar el error en el checkpoint',
        'Máximo 1 reintento automático',
        'Si falla 2 veces → BLOCKED',
        'Notificar al humano',
        'Nunca avanzar al siguiente con errores',
      ],
      correctOrder: [0, 1, 2, 3, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'Error → 1 reintento → si falla de nuevo → BLOCKED → notificar → NUNCA continuar con errores.',
    ),
  ];

  // ───── MÓDULO 4: Agentes y Skills ─────
  static List<Exercise> _agentsAndSkills() => [
    Exercise(
      id: 401,
      subcategoryId: 4,
      type: ExerciseType.multipleChoice,
      questionText: '¿Qué es un "agente" en el contexto de Antigravity?',
      optionA: 'Un humano que supervisa',
      optionB: 'Un script especializado que ejecuta una tarea específica',
      optionC: 'Un modelo de IA sin instrucciones',
      optionD: 'Una base de datos',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'Un agente en Antigravity es un ejecutor de Capa 3: recibe instrucciones precisas y genera outputs deterministas.',
    ),
    Exercise(
      id: 402,
      subcategoryId: 4,
      type: ExerciseType.dragAndDrop,
      questionText: 'Empareja cada tipo de agente con su función:',
      items: [
        'Agente Architect',
        'Agente Developer',
        'Agente Reviewer',
        'Agente SEO',
      ],
      targets: [
        'Diseña estructura y decisiones técnicas',
        'Escribe el código fuente',
        'Valida calidad y estándares',
        'Optimiza para buscadores',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Cada agente tiene una responsabilidad única. No mezclar funciones entre agentes.',
    ),
    Exercise(
      id: 403,
      subcategoryId: 4,
      type: ExerciseType.multipleChoice,
      questionText: '¿Qué es un "Skill" en Antigravity?',
      optionA: 'Una habilidad personal del programador',
      optionB:
          'Una carpeta con instrucciones y scripts que extienden las capacidades del agente',
      optionC: 'Un archivo de configuración del tema',
      optionD: 'Un tipo de test unitario',
      correctOption: 'B',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Un Skill es una carpeta con SKILL.md (instrucciones), scripts/ y resources/ que el agente puede invocar.',
    ),
    Exercise(
      id: 404,
      subcategoryId: 4,
      type: ExerciseType.commandInput,
      questionText:
          '¿Cómo se llama el archivo principal obligatorio dentro de una carpeta de Skill?',
      hint: 'Es un archivo .md...',
      acceptedAnswers: ['SKILL.md', 'skill.md', 'SKILL'],
      points: 15,
      difficulty: 'medio',
      explanation:
          'Cada skill DEBE tener un archivo SKILL.md con frontmatter YAML (name, description) e instrucciones detalladas.',
    ),
    Exercise(
      id: 405,
      subcategoryId: 4,
      type: ExerciseType.multiSelect,
      questionText:
          '¿Qué puede contener una carpeta de Skill además de SKILL.md?',
      options: [
        'scripts/ — utilidades y helpers',
        'examples/ — implementaciones de referencia',
        'resources/ — templates y assets',
        'node_modules/ — dependencias npm',
        'models/ — modelos de IA locales',
      ],
      correctIndices: [0, 1, 2],
      points: 15,
      difficulty: 'medio',
      explanation:
          'Un skill puede tener scripts/, examples/ y resources/. No incluye node_modules ni modelos de IA.',
    ),
    Exercise(
      id: 406,
      subcategoryId: 4,
      type: ExerciseType.multipleChoice,
      questionText: '¿Qué es un "Workflow" en Antigravity?',
      optionA: 'Un diagrama de flujo visual',
      optionB:
          'Un archivo .md con pasos definidos que el agente puede ejecutar',
      optionC: 'Un tipo de base de datos',
      optionD: 'Un framework de JavaScript',
      correctOption: 'B',
      points: 15,
      difficulty: 'medio',
      explanation:
          'Un workflow es un archivo .md en .agent/workflows/ con frontmatter y pasos específicos para lograr una tarea.',
    ),
    Exercise(
      id: 407,
      subcategoryId: 4,
      type: ExerciseType.ordering,
      questionText: 'Ordena el ciclo de vida de un agente en Antigravity:',
      items: [
        'Recibir instrucciones de la directiva',
        'Leer el contexto del proyecto',
        'Ejecutar la tarea asignada',
        'Generar outputs estructurados',
        'Registrar resultado en el log',
      ],
      correctOrder: [0, 1, 2, 3, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'Un agente: lee directiva → obtiene contexto → ejecuta → genera output → log. Siempre en este orden.',
    ),
    Exercise(
      id: 408,
      subcategoryId: 4,
      type: ExerciseType.commandInput,
      questionText: '¿En qué carpeta se guardan los workflows del agente?',
      hint: 'Dentro de .agent/...',
      acceptedAnswers: [
        '.agent/workflows',
        '.agent/workflows/',
        'workflows',
        '.agents/workflows',
      ],
      points: 10,
      difficulty: 'facil',
      explanation:
          'Los workflows se almacenan en .agent/workflows/ (o .agents/workflows/) como archivos .md.',
    ),
  ];

  // ───── MÓDULO 5: Orquestación Avanzada ─────
  static List<Exercise> _advancedOrchestration() => [
    Exercise(
      id: 501,
      subcategoryId: 5,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué tipo de orquestación ejecuta agentes uno después del otro?',
      optionA: 'Paralela',
      optionB: 'Secuencial',
      optionC: 'Aleatoria',
      optionD: 'Recursiva',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'La orquestación secuencial ejecuta checkpoints en orden estricto: 1 → 2 → 3 → ... Sin saltar.',
    ),
    Exercise(
      id: 502,
      subcategoryId: 5,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué tipo de orquestación ejecuta múltiples agentes al mismo tiempo?',
      optionA: 'Secuencial',
      optionB: 'Paralela',
      optionC: 'Manual',
      optionD: 'Singleton',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'La orquestación paralela lanza varios agentes simultáneamente cuando no hay dependencias entre ellos.',
    ),
    Exercise(
      id: 503,
      subcategoryId: 5,
      type: ExerciseType.dragAndDrop,
      questionText: 'Empareja cada tipo de orquestación con su caso de uso:',
      items: ['Secuencial', 'Paralela', 'Pipeline', 'Fan-out/Fan-in'],
      targets: [
        'Checkpoints dependientes uno del otro',
        'Tareas independientes al mismo tiempo',
        'Output de uno es input del siguiente',
        'Dividir tarea, procesar en paralelo, reunir resultados',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'Secuencial=dependencias, Paralela=independencia, Pipeline=cadena, Fan-out/in=dividir y reunir.',
    ),
    Exercise(
      id: 504,
      subcategoryId: 5,
      type: ExerciseType.multiSelect,
      questionText: '¿Cuándo es correcto usar orquestación PARALELA?',
      options: [
        'Cuando los agentes no dependen entre sí',
        'Cuando se necesita máxima velocidad',
        'Cuando el checkpoint 2 necesita el output del 1',
        'Cuando hay tareas que pueden fallar independientemente',
        'Cuando solo hay un agente',
      ],
      correctIndices: [0, 1, 3],
      points: 15,
      difficulty: 'medio',
      explanation:
          'Paralelo cuando: no hay dependencias, se busca velocidad, y los fallos son independientes. NUNCA si hay dependencia.',
    ),
    Exercise(
      id: 505,
      subcategoryId: 5,
      type: ExerciseType.ordering,
      questionText:
          'Ordena el flujo de un orquestador secuencial en Antigravity:',
      items: [
        'Leer MAIN_ORCHESTRATOR.md',
        'Identificar el primer checkpoint pendiente',
        'Ejecutar el checkpoint con su agente',
        'Validar el output',
        'Avanzar al siguiente o marcar BLOCKED',
      ],
      correctOrder: [0, 1, 2, 3, 4],
      points: 20,
      difficulty: 'medio',
      explanation:
          'El orquestador: lee su config → encuentra checkpoint pendiente → ejecuta → valida → avanza o bloquea.',
    ),
    Exercise(
      id: 506,
      subcategoryId: 5,
      type: ExerciseType.commandInput,
      questionText:
          '¿Cómo se llama el archivo que controla el flujo secuencial de checkpoints?',
      hint: 'MAIN_...',
      acceptedAnswers: [
        'MAIN_ORCHESTRATOR',
        'MAIN_ORCHESTRATOR.md',
        'main_orchestrator',
        'ORQUESTADOR',
      ],
      points: 15,
      difficulty: 'medio',
      explanation:
          'MAIN_ORCHESTRATOR.md define todos los checkpoints, su orden y sus criterios de validación.',
    ),
    Exercise(
      id: 507,
      subcategoryId: 5,
      type: ExerciseType.multipleChoice,
      questionText:
          'En un pipeline Antigravity, ¿qué pasa si el Agente 2 falla?',
      optionA: 'El Agente 3 se ejecuta igual',
      optionB: 'Se salta y continúa con el 4',
      optionC: 'Todo el pipeline se detiene hasta resolver el fallo',
      optionD: 'Se reinicia desde el Agente 1',
      correctOption: 'C',
      points: 15,
      difficulty: 'medio',
      explanation:
          'En un pipeline secuencial, si un eslabón falla, toda la cadena se detiene. Nunca avanzar con errores.',
    ),
    Exercise(
      id: 508,
      subcategoryId: 5,
      type: ExerciseType.multiSelect,
      questionText: '¿Cuáles son componentes del archivo MAIN_ORCHESTRATOR.md?',
      options: [
        'Lista ordenada de checkpoints',
        'Criterios de validación por checkpoint',
        'Estado actual de cada checkpoint',
        'Código fuente de la aplicación',
        'Dependencias entre checkpoints',
      ],
      correctIndices: [0, 1, 2, 4],
      points: 20,
      difficulty: 'dificil',
      explanation:
          'El orquestador define: checkpoints, validaciones, estados y dependencias. El código va en Capa 3 (agentes).',
    ),
  ];
}
