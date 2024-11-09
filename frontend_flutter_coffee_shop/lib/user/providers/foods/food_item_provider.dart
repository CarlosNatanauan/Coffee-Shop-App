import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/foods/food_item_model.dart';
import '../../services/api_services.dart';

final foodItemProvider =
    StateNotifierProvider<FoodItemNotifier, List<FoodItem>>((ref) {
  return FoodItemNotifier();
});

class FoodItemNotifier extends StateNotifier<List<FoodItem>> {
  final ApiService _apiService = ApiService();

  FoodItemNotifier() : super([]) {
    fetchAllFoodItems(); // Fetch items on initialization
  }

  // Fetch all food items
  Future<void> fetchAllFoodItems() async {
    try {
      final data = await _apiService.getAllFoodItems();
      state = data;
    } catch (e) {
      print("Error fetching food items: $e");
      throw Exception('Failed to fetch food items: $e');
    }
  }

  // Fetch an individual food item by documentId
  Future<FoodItem?> fetchFoodItemById(String documentId) async {
    try {
      return await _apiService.getFoodItemById(documentId);
    } catch (e) {
      throw Exception('Failed to fetch food item: $e');
    }
  }
}
