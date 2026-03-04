import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/question.dart';
import '../models/quiz_result.dart';
import '../models/level_progress.dart';

class QuizRepository {
  static SharedPreferences? _prefs;
  static bool _isWeb = kIsWeb;

  Future<SharedPreferences> get _preferences async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  String _progressKey(int userId, int subcategoryId, String level) =>
      'progress_${userId}_${subcategoryId}_$level';

  /// Obtiene preguntas por subcategoría
  Future<List<Question>> getQuestions(int subcategoryId) async {
    return _getMockQuestions(subcategoryId);
  }

  /// V2: Obtiene preguntas filtradas por subcategoría Y nivel
  Future<List<Question>> getQuestionsByLevel(
    int subcategoryId,
    String level,
  ) async {
    return _getMockQuestions(subcategoryId);
  }

  /// V2: Obtiene N preguntas aleatorias de un nivel
  Future<List<Question>> getRandomQuestions(
    int subcategoryId,
    String level,
    int count,
  ) async {
    return _getMockQuestions(subcategoryId).take(count).toList();
  }

  /// V2: Guardar resultado de quiz
  Future<void> saveQuizResult(QuizResult result) async {
    // No implementado en esta versión
  }

  /// V2: Obtener progreso por nivel
  Future<LevelProgress?> getLevelProgress(
    int userId,
    int subcategoryId,
    String level,
  ) async {
    if (_isWeb) {
      return _getProgressFromPrefs(userId, subcategoryId, level);
    }
    return null;
  }

  Future<LevelProgress?> _getProgressFromPrefs(
    int userId,
    int subcategoryId,
    String level,
  ) async {
    try {
      final prefs = await _preferences;
      final key = _progressKey(userId, subcategoryId, level);
      final json = prefs.getString(key);
      if (json == null) return null;
      return LevelProgress.fromMap(jsonDecode(json));
    } catch (e) {
      debugPrint('Error getting progress: $e');
      return null;
    }
  }

  /// V2: Obtener progreso de todos los niveles de una subcategoría
  Future<Map<String, LevelProgress?>> getAllLevelProgress(
    int userId,
    int subcategoryId,
  ) async {
    if (_isWeb) {
      return _getAllProgressFromPrefs(userId, subcategoryId);
    }
    return {'basico': null, 'intermedio': null, 'avanzado': null};
  }

  Future<Map<String, LevelProgress?>> _getAllProgressFromPrefs(
    int userId,
    int subcategoryId,
  ) async {
    final basico = await getLevelProgress(userId, subcategoryId, 'basico');
    final intermedio = await getLevelProgress(userId, subcategoryId, 'intermedio');
    final avanzado = await getLevelProgress(userId, subcategoryId, 'avanzado');
    return {'basico': basico, 'intermedio': intermedio, 'avanzado': avanzado};
  }

  /// V2: Guardar/actualizar progreso de un nivel
  Future<void> saveLevelProgress(LevelProgress progress) async {
    if (_isWeb) {
      await _saveProgressToPrefs(progress);
    }
  }

  Future<void> _saveProgressToPrefs(LevelProgress progress) async {
    try {
      final prefs = await _preferences;
      final key = _progressKey(progress.userId, progress.subcategoryId, progress.level);
      
      // Verificar si existe y si el nuevo es mejor
      final existing = await getLevelProgress(
        progress.userId,
        progress.subcategoryId,
        progress.level,
      );
      
      LevelProgress toSave = progress;
      if (existing != null) {
        // Solo guardar si mejora
        if (progress.stars > existing.stars ||
            (progress.stars == existing.stars && progress.bestScore > existing.bestScore)) {
          toSave = progress;
        } else {
          toSave = existing;
        }
      }
      
      await prefs.setString(key, jsonEncode(toSave.toMap()));
      debugPrint('GUARDADO en prefs: $key -> stars=${toSave.stars}');
    } catch (e) {
      debugPrint('Error guardando progreso: $e');
    }
  }

  /// V2: Obtener historial de quizzes
  Future<List<QuizResult>> getQuizHistory(int userId, {int limit = 10}) async {
    return [];
  }

  List<Question> _getMockQuestions(int subcategoryId) {
    return [
      Question(
        id: 1,
        subcategoryId: subcategoryId,
        questionText: '¿Cuál es la capa que gestiona la lógica principal?',
        optionA: 'Maestro',
        optionB: 'Orquestador',
        optionC: 'Agentes',
        optionD: 'Salida',
        correctOption: 'B',
        explanation: 'El orquestador coordina la comunicación.',
      ),
      Question(
        id: 2,
        subcategoryId: subcategoryId,
        questionText: '¿Qué tecnología usa Antigravity para Flutter?',
        optionA: 'Bloc',
        optionB: 'Provider',
        optionC: 'Riverpod',
        optionD: 'Redux',
        correctOption: 'C',
        explanation: 'Riverpod es el estándar moderno.',
      ),
      Question(
        id: 3,
        subcategoryId: subcategoryId,
        questionText: '¿Quién propuso el test de Turing?',
        optionA: 'Ada Lovelace',
        optionB: 'Alan Turing',
        optionC: 'John McCarthy',
        optionD: 'Marvin Minsky',
        correctOption: 'B',
        explanation: 'Alan Turing propuso el test en 1950.',
      ),
    ];
  }
}
