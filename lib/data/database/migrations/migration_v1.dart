import 'package:sqflite/sqflite.dart';

class MigrationV1 {
  static Future<void> migrate(Database db) async {
    // Users
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        avatar TEXT DEFAULT 'astronaut_1',
        xp INTEGER DEFAULT 0,
        level INTEGER DEFAULT 1,
        streak INTEGER DEFAULT 0,
        best_streak INTEGER DEFAULT 0,
        last_active TEXT,
        created_at TEXT NOT NULL
      )
    ''');

    // Categories
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        description TEXT,
        icon TEXT NOT NULL,
        color TEXT NOT NULL,
        difficulty TEXT DEFAULT 'medio',
        order_index INTEGER NOT NULL,
        is_active INTEGER DEFAULT 1
      )
    ''');

    // Subcategories
    await db.execute('''
      CREATE TABLE subcategories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL REFERENCES categories(id),
        name TEXT NOT NULL,
        description TEXT,
        question_count INTEGER DEFAULT 10,
        order_index INTEGER NOT NULL,
        is_locked INTEGER DEFAULT 0,
        unlock_condition INTEGER REFERENCES subcategories(id)
      )
    ''');

    // Questions
    await db.execute('''
      CREATE TABLE questions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        subcategory_id INTEGER NOT NULL REFERENCES subcategories(id),
        question_text TEXT NOT NULL,
        option_a TEXT NOT NULL,
        option_b TEXT NOT NULL,
        option_c TEXT NOT NULL,
        option_d TEXT NOT NULL,
        correct_option TEXT NOT NULL CHECK(correct_option IN ('A','B','C','D')),
        explanation TEXT,
        difficulty TEXT DEFAULT 'medio',
        points INTEGER DEFAULT 10,
        time_limit_seconds INTEGER DEFAULT 30
      )
    ''');

    // User Progress
    await db.execute('''
      CREATE TABLE user_progress (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id),
        subcategory_id INTEGER NOT NULL REFERENCES subcategories(id),
        completed INTEGER DEFAULT 0,
        stars INTEGER DEFAULT 0,
        best_score INTEGER DEFAULT 0,
        best_percentage REAL DEFAULT 0.0,
        attempts INTEGER DEFAULT 0,
        last_attempt TEXT,
        UNIQUE(user_id, subcategory_id)
      )
    ''');

    // Quiz History
    await db.execute('''
      CREATE TABLE quiz_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id),
        subcategory_id INTEGER NOT NULL REFERENCES subcategories(id),
        score INTEGER NOT NULL,
        correct_count INTEGER NOT NULL,
        total_questions INTEGER NOT NULL,
        percentage REAL NOT NULL,
        time_seconds INTEGER,
        xp_earned INTEGER DEFAULT 0,
        stars_earned INTEGER DEFAULT 0,
        completed_at TEXT NOT NULL
      )
    ''');

    // Badges
    await db.execute('''
      CREATE TABLE badges (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        icon TEXT NOT NULL,
        condition_type TEXT NOT NULL,
        condition_value INTEGER
      )
    ''');

    // User Badges
    await db.execute('''
      CREATE TABLE user_badges (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL REFERENCES users(id),
        badge_id TEXT NOT NULL REFERENCES badges(id),
        earned_at TEXT NOT NULL,
        UNIQUE(user_id, badge_id)
      )
    ''');

    // User Settings
    await db.execute('''
      CREATE TABLE user_settings (
        user_id INTEGER PRIMARY KEY REFERENCES users(id),
        sound_enabled INTEGER DEFAULT 1,
        vibration_enabled INTEGER DEFAULT 1,
        timer_enabled INTEGER DEFAULT 1,
        default_timer_seconds INTEGER DEFAULT 30,
        notifications_enabled INTEGER DEFAULT 1
      )
    ''');
  }
}
