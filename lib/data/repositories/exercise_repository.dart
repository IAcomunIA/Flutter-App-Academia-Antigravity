import '../database/database_helper.dart';
import '../models/exercise_result.dart';

/// Repositorio para ejercicios interactivos (V2)
class ExerciseRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Obtener ejercicios por subcategoría y tipo
  Future<List<Map<String, dynamic>>> getExercisesByType(
    int subcategoryId,
    String exerciseType,
  ) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'exercise_items',
        where: 'subcategory_id = ? AND exercise_type = ?',
        whereArgs: [subcategoryId, exerciseType],
      );
      return maps;
    } catch (e) {
      return [];
    }
  }

  /// Obtener ejercicios por subcategoría y nivel
  Future<List<Map<String, dynamic>>> getExercisesByLevel(
    int subcategoryId,
    String level,
  ) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'exercise_items',
        where: 'subcategory_id = ? AND level = ?',
        whereArgs: [subcategoryId, level],
      );
      return maps;
    } catch (e) {
      return [];
    }
  }

  /// Guardar resultado de un ejercicio interactivo
  Future<void> saveExerciseResult(ExerciseResult result) async {
    try {
      final db = await _dbHelper.database;
      await db.insert('exercise_results', result.toMap()..remove('id'));
    } catch (e) {
      // Log error
    }
  }

  /// Historial de ejercicios de un usuario
  Future<List<ExerciseResult>> getExerciseHistory(
    int userId, {
    int limit = 10,
  }) async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query(
        'exercise_results',
        where: 'user_id = ?',
        whereArgs: [userId],
        orderBy: 'completed_at DESC',
        limit: limit,
      );
      return List.generate(maps.length, (i) => ExerciseResult.fromMap(maps[i]));
    } catch (e) {
      return [];
    }
  }

  /// Contar ejercicios completados correctamente por tipo
  Future<int> getCorrectCountByType(int userId, String exerciseType) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM exercise_results WHERE user_id = ? AND exercise_type = ? AND is_correct = 1',
        [userId, exerciseType],
      );
      return result.first['count'] as int;
    } catch (e) {
      return 0;
    }
  }
}
