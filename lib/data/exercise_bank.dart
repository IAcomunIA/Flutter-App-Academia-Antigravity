import 'package:antigravity_quiz/data/models/exercise.dart';

/// Banco de ejercicios 100% Antigravity.
/// Módulos actualizados según parche CP-05.
class ExerciseBank {
  static List<Exercise> getExercisesForCategory(int categoryId) {
    switch (categoryId) {
      case 1:
        return _aiFoundations();
      case 2:
        return _agentsAndSkills();
      case 3:
        return _fourLayerArchitecture();
      case 4:
        return _orchestrationAndParallel();
      case 5:
        return _mcpAndRules();
      default:
        return _aiFoundations();
    }
  }

  // ───── MÓDULO 1: Inteligencia Artificial Fundamentos (SUB 1 - 6) ─────
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
      subcategoryId: 2,
      type: ExerciseType.dragAndDrop,
      questionText: 'Arrastra cada concepto a su definición correcta:',
      items: ['Context Window', 'Tokens', 'Hallucinacion', 'Temperature'],
      targets: [
        'Límite de memoria del modelo',
        'Unidades de procesamiento de texto',
        'Información falsa generada con seguridad',
        'Control de aleatoriedad en el output',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation: 'Conceptos clave para dominar cualquier LLM en Antigravity.',
    ),
    Exercise(
      id: 103,
      subcategoryId: 2,
      type: ExerciseType.multiSelect,
      questionText:
          '¿Cuáles son parámetros de control en un LLM? (Selecciona los correctos)',
      options: [
        'Temperature',
        'Top_p',
        'Max Tokens',
        'Tokenization',
        'Fine-tuning',
      ],
      correctIndices: [0, 1, 2],
      points: 15,
      difficulty: 'medio',
      explanation:
          'Temperature, Top_p y Max Tokens son hiperparámetros de inferencia.',
    ),
  ];

  // ───── MÓDULO 2: Agentes IA — Metodología Antigravity (SUB 7 - 12) ─────
  static List<Exercise> _agentsAndSkills() => [
    Exercise(
      id: 201,
      subcategoryId: 7,
      type: ExerciseType.multipleChoice,
      questionText: '¿Qué define principalmente a un "agente" en Antigravity?',
      optionA: 'Una interfaz gráfica bonita',
      optionB: 'Autonomía para ejecutar tareas y tomar decisiones',
      optionC: 'Estar conectado siempre a internet',
      optionD: 'Ser desarrollado exclusivamente en Python',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation:
          'Un agente es un sistema autónomo que percibe, razona y actúa para cumplir una directiva.',
    ),
    Exercise(
      id: 202,
      subcategoryId: 8,
      type: ExerciseType.fillBlank,
      questionText: 'Completa la oración sobre Skills en Antigravity:',
      blankText:
          'Para definir capacidades nuevas, creamos un archivo llamado _____.md dentro de la carpeta de _____.',
      correctWords: ['SKILL', 'skills'],
      wordBank: ['SKILL', 'skills', 'README', 'TOOL', 'agents', 'API'],
      points: 15,
      difficulty: 'medio',
      explanation:
          'El archivo SKILL.md es el estándar para documentar qué puede hacer un agente.',
    ),
    Exercise(
      id: 203,
      subcategoryId: 7,
      type: ExerciseType.dragAndDrop,
      questionText: 'Empareja los tipos de agentes Antigravity:',
      items: ['Arquitecto', 'Developer', 'Reviewer', 'SEO'],
      targets: [
        'Diseña la estructura del proyecto',
        'Escribe el código funcional',
        'Valida la calidad y busca errores',
        'Optimización para buscadores',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Cada agente tiene un rol especializado dentro de la metodología.',
    ),
  ];

  // ───── MÓDULO 3: Arquitectura de 4 Capas Antigravity (SUB 13 - 18) ─────
  static List<Exercise> _fourLayerArchitecture() => [
    Exercise(
      id: 301,
      subcategoryId: 13,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Cuál es la primera capa (Capa 1) de la arquitectura Antigravity?',
      optionA: 'Agentes de Ejecución',
      optionB: 'Maestro / Directiva',
      optionC: 'Orquestador',
      optionD: 'Output / Validación',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation: 'La Directiva define el objetivo sagrado del sistema.',
    ),
    Exercise(
      id: 302,
      subcategoryId: 14,
      type: ExerciseType.ordering,
      questionText: 'Ordena el flujo de control de arriba hacia abajo:',
      items: ['Directiva', 'Orquestador', 'Agentes', 'Output'],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'El flujo siempre desciende: Quién manda -> Quién organiza -> Quién hace -> Qué sale.',
    ),
    Exercise(
      id: 303,
      subcategoryId: 16,
      type: ExerciseType.multipleChoice,
      questionText:
          'En Capa 4 (Output), ¿qué etiqueta indica que el sistema terminó con éxito?',
      optionA: '[INICIO]',
      optionB: '[FIN]',
      optionC: '[ERROR]',
      optionD: '[BLOCKED]',
      correctOption: 'B',
      points: 10,
      difficulty: 'facil',
      explanation: '[FIN] marca el cierre exitoso del flujo orquestado.',
    ),
  ];

  // ───── MÓDULO 4: Orquestación y Agentes Paralelos (SUB 19 - 24) ─────
  static List<Exercise> _orchestrationAndParallel() => [
    Exercise(
      id: 401,
      subcategoryId: 19,
      type: ExerciseType.multipleChoice,
      questionText:
          '¿Qué patrón de orquestación se usa para tareas sin dependencias entre sí?',
      optionA: 'Secuencial',
      optionB: 'Paralelo',
      optionC: 'Pipeline',
      optionD: 'Manual',
      correctOption: 'B',
      points: 10,
      difficulty: 'medio',
      explanation:
          'El paralelismo optimiza tiempos cuando los agentes pueden trabajar de forma independiente.',
    ),
    Exercise(
      id: 402,
      subcategoryId: 20,
      type: ExerciseType.dragAndDrop,
      questionText: 'Coordina los tipos de orquestación:',
      items: ['Secuencial', 'Paralelo', 'Pipeline', 'Fan-out'],
      targets: [
        'Uno después de otro',
        'Varios a la vez',
        'Output -> Input siguiente',
        'Dividir tarea en partes',
      ],
      correctOrder: [0, 1, 2, 3],
      points: 20,
      difficulty: 'medio',
      explanation:
          'Diferentes flujos para diferentes necesidades de orquestación.',
    ),
  ];

  // ───── MÓDULO 5: MCP, Skills y Reglas Globales (SUB 25 - 30) ─────
  static List<Exercise> _mcpAndRules() => [
    Exercise(
      id: 501,
      subcategoryId: 25,
      type: ExerciseType.multipleChoice,
      questionText: '¿Para qué sirve el Model Context Protocol (MCP)?',
      optionA: 'Para que los agentes hablen entre sí',
      optionB: 'Para conectar modelos con herramientas y datos externos',
      optionC: 'Para comprimir el contexto de los prompts',
      optionD: 'Para reemplazar a Python',
      correctOption: 'B',
      points: 10,
      difficulty: 'medio',
      explanation:
          'MCP es el puente estándar entre la inteligencia del modelo y el mundo real.',
    ),
    Exercise(
      id: 502,
      subcategoryId: 27,
      type: ExerciseType.fillBlank,
      questionText: 'Completa la oración sobre Reglas Antigravity:',
      blankText:
          'Las reglas que todo agente debe seguir se llaman Reglas _____. Estas se definen en el archivo de _____ del proyecto.',
      correctWords: ['Globales', 'configuración'],
      wordBank: [
        'Globales',
        'configuración',
        'Locales',
        'Simples',
        'ejecución',
        'Hardcoded',
      ],
      points: 15,
      difficulty: 'facil',
      explanation:
          'Las Reglas Globales aseguran la consistencia en todo el ecosistema Antigravity.',
    ),
  ];
}
