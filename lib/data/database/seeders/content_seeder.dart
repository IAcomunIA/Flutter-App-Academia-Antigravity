import 'package:sqflite/sqflite.dart';
import 'categories_seed.dart';
import 'questions_seed_basic.dart';
import 'questions_seed_intermediate.dart';
import 'questions_seed_advanced.dart';
import 'badges_seed.dart';
import 'exercises_seed.dart';

class ContentSeeder {
  static Future<void> seedIfNeeded(Database db) async {
    try {
      final catCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM categories'),
      );

      // Si no hay categorías o son las viejas (menos de 5), re-seedear
      if (catCount == 0 || catCount == null || catCount < 5) {
        await _seed(db);
      }

      // Siempre verificar badges
      final badgeCount = Sqflite.firstIntValue(
        await db.rawQuery('SELECT COUNT(*) FROM badges'),
      );
      if (badgeCount == 0 || badgeCount == null || badgeCount < 16) {
        await BadgesSeed.seed(db);
      }
    } catch (e) {
      // Log error silent
    }
  }

  static Future<void> _seed(Database db) async {
    // Limpiar tablas para evitar duplicados si es un re-seed
    await db.delete('categories');
    await db.delete('subcategories');
    await db.delete('questions');

    // Categorías
    for (var cat in CategoriesSeed.categories) {
      await db.insert('categories', cat);
    }

    // Subcategorías
    for (var sub in CategoriesSeed.subcategories) {
      await db.insert('subcategories', sub);
    }

    // Preguntas BÁSICAS
    for (var q in QuestionsSeedBasic.questions) {
      await db.insert('questions', q);
    }

    // Preguntas INTERMEDIAS
    for (var q in QuestionsSeedIntermediate.questions) {
      await db.insert('questions', q);
    }

    // Preguntas AVANZADAS
    for (var q in QuestionsSeedAdvanced.questions) {
      await db.insert('questions', q);
    }

    // Badges
    await BadgesSeed.seed(db);

    // Ejercicios interactivos
    await ExercisesSeed.seed(db);
  }
}
