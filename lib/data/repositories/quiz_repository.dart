import 'package:flutter/foundation.dart';
import '../database/database_helper.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../models/level_progress.dart';

class QuizRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Obtiene preguntas por subcategoría (retrocompat V1)
  Future<List<Question>> getQuestions(int subcategoryId) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'questions',
        where: 'subcategory_id = ?',
        whereArgs: [subcategoryId],
      );
      if (maps.isEmpty) return _getMockQuestions(subcategoryId);
      return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    } catch (e) {
      return _getMockQuestions(subcategoryId);
    }
  }

  /// V2: Obtiene preguntas filtradas por subcategoría Y nivel
  Future<List<Question>> getQuestionsByLevel(
    int subcategoryId,
    String level,
  ) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'questions',
        where: 'subcategory_id = ? AND level = ?',
        whereArgs: [subcategoryId, level],
      );
      if (maps.isEmpty) return _getMockQuestions(subcategoryId);
      return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    } catch (e) {
      return _getMockQuestions(subcategoryId);
    }
  }

  /// V2: Obtiene N preguntas aleatorias de un nivel
  Future<List<Question>> getRandomQuestions(
    int subcategoryId,
    String level,
    int count,
  ) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.rawQuery(
        'SELECT * FROM questions WHERE subcategory_id = ? AND level = ? ORDER BY RANDOM() LIMIT ?',
        [subcategoryId, level, count],
      );
      if (maps.isEmpty) return _getMockQuestions(subcategoryId);
      return List.generate(maps.length, (i) => Question.fromMap(maps[i]));
    } catch (e) {
      return _getMockQuestions(subcategoryId);
    }
  }

  /// V2: Guarda resultado de quiz
  Future<void> saveQuizResult(QuizResult result) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('quiz_history', result.toMap()..remove('id'));
    } catch (e) {
      // Log error
    }
  }

  /// V2: Obtener progreso por nivel
  Future<LevelProgress?> getLevelProgress(
    int userId,
    int subcategoryId,
    String level,
  ) async {
    try {
      final db = await _dbHelper.database;
      debugPrint('QUERY: userId=$userId, subcategoryId=$subcategoryId, level=$level');
      
      final List<Map<String, dynamic>> maps = await db.query(
        'level_progress',
        where: 'user_id = ? AND subcategory_id = ? AND level = ?',
        whereArgs: [userId, subcategoryId, level],
      );
      debugPrint('QUERY RESULT: ${maps.length} rows');
      if (maps.isEmpty) return null;
      debugPrint('QUERY DATA: ${maps.first}');
      return LevelProgress.fromMap(maps.first);
    } catch (e) {
      debugPrint('QUERY ERROR: $e');
      return null;
    }
  }

  /// V2: Obtener progreso de todos los niveles de una subcategoría
  Future<Map<String, LevelProgress?>> getAllLevelProgress(
    int userId,
    int subcategoryId,
  ) async {
    final basico = await getLevelProgress(userId, subcategoryId, 'basico');
    final intermedio = await getLevelProgress(
      userId,
      subcategoryId,
      'intermedio',
    );
    final avanzado = await getLevelProgress(userId, subcategoryId, 'avanzado');
    return {'basico': basico, 'intermedio': intermedio, 'avanzado': avanzado};
  }

  /// V2: Guardar/actualizar progreso de un nivel
  Future<void> saveLevelProgress(LevelProgress progress) async {
    try {
      final db = await _dbHelper.database;
      final existing = await getLevelProgress(
        progress.userId,
        progress.subcategoryId,
        progress.level,
      );

      if (existing != null) {
        // Actualizar siempre - guardar el mejor resultado
        final newStars = progress.stars > existing.stars ? progress.stars : existing.stars;
        final newScore = progress.bestScore > existing.bestScore ? progress.bestScore : existing.bestScore;
        final newPercentage = progress.bestPercentage > existing.bestPercentage ? progress.bestPercentage : existing.bestPercentage;
        
        await db.update(
          'level_progress',
          {
            'stars': newStars,
            'best_score': newScore,
            'best_percentage': newPercentage,
            'attempts': existing.attempts + 1,
            'completed_at': progress.completedAt,
          },
          where: 'id = ?',
          whereArgs: [existing.id],
        );
      } else {
        await db.insert('level_progress', {
          'user_id': progress.userId,
          'subcategory_id': progress.subcategoryId,
          'level': progress.level,
          'stars': progress.stars,
          'best_score': progress.bestScore,
          'best_percentage': progress.bestPercentage,
          'attempts': 1,
          'completed_at': progress.completedAt,
        });
      }
    } catch (e) {
      debugPrint('Error guardando progreso: $e');
    }
  }

  /// V2: Obtener historial de quizzes
  Future<List<QuizResult>> getQuizHistory(int userId, {int limit = 10}) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'quiz_history',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'completed_at DESC',
        limit: limit,
      );
      return List.generate(maps.length, (i) => QuizResult.fromMap(maps[i]));
    } catch (e) {
      return [];
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
