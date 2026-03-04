import '../database/database_helper.dart';

/// Repositorio para gestión de usuario (V2)
class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Obtener usuario actual (el primero)
  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> maps = await db.query('users', limit: 1);
      if (maps.isEmpty) return null;
      return maps.first;
    } catch (e) {
      return null;
    }
  }

  /// Crear nuevo usuario
  Future<int> createUser(String name, String avatar) async {
    try {
      final db = await _dbHelper.database;
      return await db.insert('users', {
        'name': name,
        'avatar': avatar,
        'xp': 0,
        'level': 1,
        'streak': 0,
        'best_streak': 0,
        'last_active': DateTime.now().toIso8601String(),
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      return -1;
    }
  }

  /// Actualizar XP del usuario
  Future<void> updateUserXP(int userId, int xpToAdd) async {
    try {
      final db = await _dbHelper.database;
      final user = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (user.isEmpty) return;

      final currentXP = user.first['xp'] as int;
      final newXP = currentXP + xpToAdd;
      final newLevel = getUserLevelFromXP(newXP);

      await db.update(
        'users',
        {
          'xp': newXP,
          'level': newLevel,
          'last_active': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      // Log error
    }
  }

  /// Actualizar racha del usuario
  Future<void> updateStreak(int userId) async {
    try {
      final db = await _dbHelper.database;
      final user = await db.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );
      if (user.isEmpty) return;

      final lastActive = user.first['last_active'] as String?;
      final currentStreak = user.first['streak'] as int;
      final bestStreak = user.first['best_streak'] as int;

      // Solo contar racha si no se ha registrado hoy
      if (lastActive != null) {
        final lastDate = DateTime.parse(lastActive);
        final today = DateTime.now();
        if (lastDate.year == today.year &&
            lastDate.month == today.month &&
            lastDate.day == today.day) {
          return; // Ya se registró hoy
        }
      }

      final newStreak = currentStreak + 1;
      final newBestStreak = newStreak > bestStreak ? newStreak : bestStreak;

      await db.update(
        'users',
        {
          'streak': newStreak,
          'best_streak': newBestStreak,
          'last_active': DateTime.now().toIso8601String(),
        },
        where: 'id = ?',
        whereArgs: [userId],
      );
    } catch (e) {
      // Log error
    }
  }

  /// V2: Tabla de niveles de usuario
  static int getUserLevelFromXP(int xp) {
    if (xp >= 12000) return 8; // Orquestador
    if (xp >= 6000) return 7; // Arquitecto
    if (xp >= 3000) return 6; // Maestro IA
    if (xp >= 1500) return 5; // Comandante
    if (xp >= 700) return 4; // Capitán
    if (xp >= 300) return 3; // Piloto
    if (xp >= 100) return 2; // Cadete
    return 1; // Recluta
  }

  /// V2: Nombre del nivel
  static String getLevelName(int level) {
    const names = {
      1: 'Recluta',
      2: 'Cadete',
      3: 'Piloto',
      4: 'Capitán',
      5: 'Comandante',
      6: 'Maestro IA',
      7: 'Arquitecto',
      8: 'Orquestador',
    };
    return names[level] ?? 'Recluta';
  }

  /// V2: XP requerido para el siguiente nivel
  static int getXPForNextLevel(int currentLevel) {
    const thresholds = {
      1: 100,
      2: 300,
      3: 700,
      4: 1500,
      5: 3000,
      6: 6000,
      7: 12000,
      8: 99999, // Max level
    };
    return thresholds[currentLevel] ?? 99999;
  }

  /// Obtener el conteo total de quizzes completados
  Future<int> getQuizCount(int userId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM quiz_history WHERE user_id = ?',
        [userId],
      );
      return result.first['count'] as int;
    } catch (e) {
      return 0;
    }
  }

  /// Obtener precisión global
  Future<double> getGlobalAccuracy(int userId) async {
    try {
      final db = await _dbHelper.database;
      final result = await db.rawQuery(
        'SELECT AVG(percentage) as avg_pct FROM quiz_history WHERE user_id = ?',
        [userId],
      );
      final avg = result.first['avg_pct'];
      if (avg == null) return 0.0;
      return (avg as num).toDouble();
    } catch (e) {
      return 0.0;
    }
  }
}
