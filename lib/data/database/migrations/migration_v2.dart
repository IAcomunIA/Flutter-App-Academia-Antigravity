import 'package:sqflite/sqflite.dart';

/// Migración V2: soporte para 3 niveles por módulo + ejercicios interactivos
class MigrationV2 {
  static Future<void> migrate(Database db) async {
    // Columna 'level' en questions (basico|intermedio|avanzado)
    await db.execute('''
      ALTER TABLE questions ADD COLUMN level TEXT DEFAULT 'basico'
    ''');

    // Progreso por nivel (básico/intermedio/avanzado)
    await db.execute('''
      CREATE TABLE IF NOT EXISTS level_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        subcategory_id INTEGER NOT NULL,
        level TEXT NOT NULL,
        stars INTEGER DEFAULT 0,
        best_score INTEGER DEFAULT 0,
        best_percentage REAL DEFAULT 0.0,
        attempts INTEGER DEFAULT 0,
        completed_at TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (subcategory_id) REFERENCES subcategories(id),
        UNIQUE(user_id, subcategory_id, level)
      )
    ''');

    // Ejercicios interactivos almacenados como JSON
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subcategory_id INTEGER NOT NULL,
        level TEXT NOT NULL,
        exercise_type TEXT NOT NULL,
        content TEXT NOT NULL,
        difficulty TEXT NOT NULL,
        points INTEGER DEFAULT 20,
        FOREIGN KEY (subcategory_id) REFERENCES subcategories(id)
      )
    ''');

    // Historial de ejercicios interactivos completados
    await db.execute('''
      CREATE TABLE IF NOT EXISTS exercise_results (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        exercise_item_id INTEGER NOT NULL,
        exercise_type TEXT NOT NULL,
        is_correct INTEGER NOT NULL,
        score INTEGER DEFAULT 0,
        time_seconds INTEGER,
        xp_earned INTEGER DEFAULT 0,
        completed_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id),
        FOREIGN KEY (exercise_item_id) REFERENCES exercise_items(id)
      )
    ''');
  }
}
