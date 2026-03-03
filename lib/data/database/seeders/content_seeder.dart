import 'package:sqflite/sqflite.dart';
import 'categories_seed.dart';
import 'questions_seed.dart';

class ContentSeeder {
  static Future<void> seedIfNeeded(Database db) async {
    final count = Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM categories'));
    if (count == 0) {
      await _seed(db);
    }
  }

  static Future<void> _seed(Database db) async {
    for (var cat in CategoriesSeed.categories) {
      await db.insert('categories', cat);
    }
    for (var sub in CategoriesSeed.subcategories) {
      await db.insert('subcategories', sub);
    }
    for (var q in QuestionsSeed.questions) {
      await db.insert('questions', q);
    }
  }
}
