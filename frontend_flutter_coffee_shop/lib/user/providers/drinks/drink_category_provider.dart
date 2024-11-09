import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/drinks/drink_category_model.dart';
import '../../services/api_services.dart';

final drinkCategoryProvider =
    StateNotifierProvider<DrinkCategoryNotifier, List<DrinkCategory>>((ref) {
  return DrinkCategoryNotifier();
});

class DrinkCategoryNotifier extends StateNotifier<List<DrinkCategory>> {
  DrinkCategoryNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all drink categories
  Future<void> fetchCategories() async {
    try {
      final data = await _apiService.getDrinkCategories();
      List<DrinkCategory> categories =
          data.map((item) => DrinkCategory.fromJson(item)).toList();

      // Add "All Drinks" pseudo-category at the start
      categories.insert(0,
          DrinkCategory(id: 0, documentId: 'all', categoryName: 'All Drinks'));

      state = categories;
      print("Fetched all drink categories successfully, including All Drinks.");
    } catch (e) {
      print("Exception in fetching categories: $e");
      throw Exception('Failed to fetch categories: $e');
    }
  }
}
