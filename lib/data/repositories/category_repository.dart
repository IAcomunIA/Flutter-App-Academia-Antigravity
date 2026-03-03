import '../database/database_helper.dart';
import '../models/category.dart';
import '../models/subcategory.dart';

class CategoryRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<Category>> getAllCategories() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('categories');
    return List.generate(maps.length, (i) => Category.fromMap(maps[i]));
  }

  Future<List<Subcategory>> getSubcategories(int categoryId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('subcategories', where: 'category_id = ?', whereArgs: [categoryId]);
    return List.generate(maps.length, (i) => Subcategory.fromMap(maps[i]));
  }
}