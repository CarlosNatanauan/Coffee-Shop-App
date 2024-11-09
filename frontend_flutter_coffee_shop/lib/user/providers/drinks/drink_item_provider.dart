import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/drinks/drink_item_model.dart';
import '../../services/api_services.dart';

final drinkItemProvider =
    StateNotifierProvider<DrinkItemNotifier, List<DrinkItem>>((ref) {
  return DrinkItemNotifier();
});

class DrinkItemNotifier extends StateNotifier<List<DrinkItem>> {
  final ApiService _apiService = ApiService();

  DrinkItemNotifier() : super([]) {
    fetchAllDrinkItems(); // Fetch items on initialization
  }

  // Fetch all drink items
  Future<void> fetchAllDrinkItems() async {
    try {
      final data = await _apiService.getAllDrinkItems();
      state = data;
    } catch (e) {
      print("Error fetching drink items: $e");
      throw Exception('Failed to fetch drink items: $e');
    }
  }

  // Fetch an individual drink item by documentId
  Future<DrinkItem?> fetchDrinkItemById(String documentId) async {
    try {
      return await _apiService.getDrinkItemById(documentId);
    } catch (e) {
      throw Exception('Failed to fetch drink item: $e');
    }
  }
}
