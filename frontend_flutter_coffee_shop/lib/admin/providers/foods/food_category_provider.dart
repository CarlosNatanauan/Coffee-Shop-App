import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/foods/food_category_model.dart';
import '../../services/api_services.dart';

final foodCategoryProvider =
    StateNotifierProvider<FoodCategoryNotifier, List<FoodCategory>>((ref) {
  return FoodCategoryNotifier();
});

class FoodCategoryNotifier extends StateNotifier<List<FoodCategory>> {
  FoodCategoryNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      final data = await _apiService.getCategoriesFoods();
      state = data.map((item) => FoodCategory.fromJson(item)).toList();
      print("Fetched all categories successfully.");
    } catch (e) {
      print("Exception in fetching categories: $e");
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Fetch an individual category by documentId
  Future<FoodCategory?> fetchCategoryById(String documentId) async {
    try {
      final data = await _apiService.getCategoryByIdFoods(documentId);
      return FoodCategory.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch category by documentId: $e');
    }
  }

  // Add a new category
  Future<void> addCategory(String categoryName) async {
    try {
      final data = await _apiService.addCategoryFoods(categoryName);
      final newCategory =
          FoodCategory.fromJson(data); // Do not wrap in {'data': data}
      state = [...state, newCategory];
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Update a category by documentId
  Future<void> updateCategory(String documentId, String newCategoryName) async {
    try {
      // Assuming that the API service has an `updateCategory` method
      final updatedData = await _apiService.updateCategoryFoods(documentId, {
        'data': {
          'category_name': newCategoryName,
        }
      });
      final updatedCategory = FoodCategory.fromJson(updatedData);

      state = state.map((category) {
        if (category.documentId == documentId) {
          return updatedCategory.copyWith(selected: category.selected);
        }
        return category;
      }).toList();
    } catch (e) {
      throw Exception('Failed to update category: $e');
    }
  }

  // Delete a category by documentId
  Future<void> deleteCategory(String documentId) async {
    try {
      await _apiService.deleteCategoryFoods(documentId);
      state =
          state.where((category) => category.documentId != documentId).toList();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
