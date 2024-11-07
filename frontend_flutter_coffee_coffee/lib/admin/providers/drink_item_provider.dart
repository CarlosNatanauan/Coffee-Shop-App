import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drinks/item/drink_item_model.dart';
import '../services/api_services.dart';

final drinkItemProvider =
    StateNotifierProvider<DrinkItemNotifier, List<DrinkItem>>((ref) {
  return DrinkItemNotifier();
});

class DrinkItemNotifier extends StateNotifier<List<DrinkItem>> {
  DrinkItemNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all drink items
  Future<void> fetchAllDrinkItems() async {
    try {
      final data = await _apiService.getAllDrinkItems();
      state = data;
      print("Fetched all drink items successfully.");
    } catch (e) {
      print("Exception in fetching drink items: $e");
      throw Exception('Failed to fetch drink items: $e');
    }
  }

  // Fetch an individual drink item by documentId
  Future<DrinkItem?> fetchDrinkItemById(String documentId) async {
    try {
      final data = await _apiService.getDrinkItemById(documentId);
      return data;
    } catch (e) {
      print("Exception in fetching drink item by documentId: $e");
      throw Exception('Failed to fetch drink item by documentId: $e');
    }
  }

// Add a new drink item
  Future<void> addDrinkItem(DrinkItem drinkItem) async {
    try {
      final newDrink =
          await _apiService.createDrinkItem(drinkItem.toJson(isNew: true));

      if (newDrink != null) {
        state = [...state, newDrink];
        print("Added new drink item successfully.");
      } else {
        throw Exception('API returned null for the new drink item');
      }
    } catch (e) {
      print("Exception in adding drink item: $e");
      throw Exception('Failed to add drink item: $e');
    }
  }

  // Update an existing drink item by its document ID (expects a Map<String, dynamic>)
  Future<void> updateDrinkItem(
      String documentId, Map<String, dynamic> drinkData) async {
    try {
      final updatedDrink =
          await _apiService.updateDrinkItem(documentId, drinkData);
      if (updatedDrink != null) {
        state = state
            .map((item) => item.documentId == documentId ? updatedDrink : item)
            .toList();
        print("Updated drink item successfully.");
      } else {
        throw Exception('API returned null for the updated drink item');
      }
    } catch (e) {
      print("Exception in updating drink item: $e");
      throw Exception('Failed to update drink item: $e');
    }
  }

  // Delete a drink item by documentId
  Future<void> deleteDrinkItem(String documentId) async {
    try {
      await _apiService.deleteDrinkItem(documentId);
      // Remove the deleted item from the state
      state = state.where((item) => item.documentId != documentId).toList();
      print("Deleted drink item successfully in state.");
    } catch (e) {
      print("Exception in deleting drink item: $e");
      throw Exception('Failed to delete drink item: $e');
    }
  }
}
