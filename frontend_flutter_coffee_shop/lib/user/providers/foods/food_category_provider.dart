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

  // Fetch all food categories
  Future<void> fetchCategories() async {
    try {
      final data = await _apiService.getFoodCategories();
      List<FoodCategory> categories =
          data.map((item) => FoodCategory.fromJson(item)).toList();

      // Add "All Foods" pseudo-category at the start
      categories.insert(
          0, FoodCategory(id: 0, documentId: 'all', categoryName: 'All Foods'));

      state = categories;
      print("Fetched all food categories successfully, including All Foods.");
    } catch (e) {
      print("Exception in fetching categories: $e");
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
