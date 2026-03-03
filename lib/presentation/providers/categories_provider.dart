import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/category.dart';
import '../../data/models/subcategory.dart';
import '../../data/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider((ref) => CategoryRepository());

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  return ref.watch(categoryRepositoryProvider).getAllCategories();
});

final subcategoriesProvider = FutureProvider.family<List<Subcategory>, int>((ref, categoryId) async {
  return ref.watch(categoryRepositoryProvider).getSubcategories(categoryId);
});
