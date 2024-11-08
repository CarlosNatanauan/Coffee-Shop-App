import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/foods/item/food_item_model.dart';
import '../../services/api_services.dart';

final foodItemProvider =
    StateNotifierProvider<FoodItemNotifier, List<FoodItem>>((ref) {
  return FoodItemNotifier();
});

class FoodItemNotifier extends StateNotifier<List<FoodItem>> {
  FoodItemNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all food items
  Future<void> fetchAllFoodItems() async {
    try {
      final data = await _apiService.getAllFoodItems();
      state = data;
      print("Fetched all food items successfully.");
    } catch (e) {
      print("Exception in fetching food items: $e");
      throw Exception('Failed to fetch food items: $e');
    }
  }

  // Fetch an individual food item by documentId
  Future<FoodItem?> fetchFoodItemById(String documentId) async {
    try {
      final data = await _apiService.getFoodItemById(documentId);
      return data;
    } catch (e) {
      print("Exception in fetching food item by documentId: $e");
      throw Exception('Failed to fetch food item by documentId: $e');
    }
  }

  // Add a new food item
  Future<void> addFoodItem(FoodItem foodItem) async {
    try {
      final newFood =
          await _apiService.createFoodItem(foodItem.toJson(isNew: true));

      if (newFood != null) {
        state = [...state, newFood];
        print("Added new food item successfully.");
      } else {
        throw Exception('API returned null for the new food item');
      }
    } catch (e) {
      print("Exception in adding food item: $e");
      throw Exception('Failed to add food item: $e');
    }
  }

  // Update an existing food item by its document ID (expects a Map<String, dynamic>)
  Future<void> updateFoodItem(
      String documentId, Map<String, dynamic> foodData) async {
    try {
      final updatedFood =
          await _apiService.updateFoodItem(documentId, foodData);
      if (updatedFood != null) {
        state = state
            .map((item) => item.documentId == documentId ? updatedFood : item)
            .toList();
        print("Updated food item successfully.");
      } else {
        throw Exception('API returned null for the updated food item');
      }
    } catch (e) {
      print("Exception in updating food item: $e");
      throw Exception('Failed to update food item: $e');
    }
  }

  // Delete a food item by documentId
  Future<void> deleteFoodItem(String documentId) async {
    try {
      await _apiService.deleteFoodItem(documentId);
      // Remove the deleted item from the state
      state = state.where((item) => item.documentId != documentId).toList();
      print("Deleted food item successfully in state.");
    } catch (e) {
      print("Exception in deleting food item: $e");
      throw Exception('Failed to delete food item: $e');
    }
  }
}
