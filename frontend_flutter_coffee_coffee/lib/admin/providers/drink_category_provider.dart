import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drinks/drink_category_model.dart';
import '../services/api_services.dart';

final drinkCategoryProvider =
    StateNotifierProvider<DrinkCategoryNotifier, List<DrinkCategory>>((ref) {
  return DrinkCategoryNotifier();
});

class DrinkCategoryNotifier extends StateNotifier<List<DrinkCategory>> {
  DrinkCategoryNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all categories
  Future<void> fetchCategories() async {
    try {
      final data = await _apiService.getCategories();
      state = data.map((item) => DrinkCategory.fromJson(item)).toList();
      print("Fetched all categories successfully.");
    } catch (e) {
      print("Exception in fetching categories: $e");
      throw Exception('Failed to fetch categories: $e');
    }
  }

  // Fetch an individual category by documentId
  Future<DrinkCategory?> fetchCategoryById(String documentId) async {
    try {
      final data = await _apiService.getCategoryById(documentId);
      return DrinkCategory.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch category by documentId: $e');
    }
  }

  // Add a new category
  Future<void> addCategory(String categoryName) async {
    try {
      final data = await _apiService.addCategory(categoryName);
      final newCategory =
          DrinkCategory.fromJson(data); // Do not wrap in {'data': data}
      state = [...state, newCategory];
    } catch (e) {
      throw Exception('Failed to add category: $e');
    }
  }

  // Update a category by documentId
  Future<void> updateCategory(String documentId, String newCategoryName) async {
    try {
      // Assuming that the API service has an `updateCategory` method
      final updatedData = await _apiService.updateCategory(documentId, {
        'data': {
          'category_name': newCategoryName,
        }
      });
      final updatedCategory = DrinkCategory.fromJson(updatedData);

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
      await _apiService.deleteCategory(documentId);
      state =
          state.where((category) => category.documentId != documentId).toList();
    } catch (e) {
      throw Exception('Failed to delete category: $e');
    }
  }
}
