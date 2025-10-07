import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:product/models/category_model.dart';
import 'package:product/services/api_service.dart';

class CategoryNotifier extends AsyncNotifier<List<CategoryModel>> {
  @override
  Future<List<CategoryModel>> build() async {
    return await fetchCategories();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    try {
      state = const AsyncValue.loading();
      final categories = await ApiService.fetchCategories();
      state = AsyncValue.data(categories);
      return categories;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      rethrow;
    }
  }
  

  Future<void> refresh() async {
    await fetchCategories();
  }
}

// Provider instance
final categoryProvider = AsyncNotifierProvider<CategoryNotifier, List<CategoryModel>>(
  () => CategoryNotifier(),
);

// Selected category provider with default selection logic
final selectedCategoryProvider = StateProvider<CategoryModel?>((ref) {
  // Listen to categories and set default when loaded
  final categoriesAsync = ref.watch(categoryProvider);
  return categoriesAsync.when(
    data: (categories) {
      // Set default to first category (usually "Clothes")
      if (categories.isNotEmpty) {
        return categories.first;
      }
      return null;
    },
    loading: () => null,
    error: (_, __) => null,
  );
});