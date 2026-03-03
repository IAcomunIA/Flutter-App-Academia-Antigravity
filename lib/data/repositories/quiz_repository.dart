import '../database/database_helper.dart';
import '../models/question.dart';

class QuizRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Question>> getQuestions(int subcategoryId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'questions',
        where: 'subcategory_id = ?',
        whereArgs: [subcategoryId],
      );

      if (maps.isEmpty) {
        return _getMockQuestions(subcategoryId);
      }

      return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    } catch (e) {
      // Fallback para web o errores de DB
      return _getMockQuestions(subcategoryId);
    }
  }

  List<Question> _getMockQuestions(int subcategoryId) {
    return [
      Question(
        id: 1,
        subcategoryId: subcategoryId,
        questionText:
            '¿Cuál es la capa que gestiona la lógica principal y el flujo entre capas?',
        optionA: 'Maestro',
        optionB: 'Orquestador',
        optionC: 'Agentes',
        optionD: 'Salida',
        correctOption: 'B',
        explanation:
            'El orquestador coordina la comunicación entre la directiva maestra y los agentes de ejecución.',
      ),
      Question(
        id: 2,
        subcategoryId: subcategoryId,
        questionText:
            '¿Qué tecnología usa Antigravity para el estado de la aplicación Flutter?',
        optionA: 'Bloc',
        optionB: 'Provider',
        optionC: 'Riverpod',
        optionD: 'Redux',
        correctOption: 'C',
        explanation:
            'Riverpod es el estándar moderno elegido por su seguridad y flexibilidad.',
      ),
      Question(
        id: 3,
        subcategoryId: subcategoryId,
        questionText:
            '¿Quién propuso la máquina que sentó las bases de la IA en 1950?',
        optionA: 'Steve Jobs',
        optionB: 'Alan Turing',
        optionC: 'Ada Lovelace',
        optionD: 'John von Neumann',
        correctOption: 'B',
        explanation:
            'Alan Turing es el visionario detrás del concepto de máquinas pensantes.',
      ),
    ];
  }
}
