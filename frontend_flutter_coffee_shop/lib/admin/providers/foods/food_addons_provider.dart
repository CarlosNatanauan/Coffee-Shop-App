import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/foods/food_addons_models.dart';
import '../../services/api_services.dart';

final foodAddOnProvider =
    StateNotifierProvider<FoodAddOnNotifier, List<FoodAddOn>>((ref) {
  return FoodAddOnNotifier();
});

class FoodAddOnNotifier extends StateNotifier<List<FoodAddOn>> {
  FoodAddOnNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all add-ons
  Future<void> fetchAddOns() async {
    try {
      final data = await _apiService.getAddOnsFoods();
      state = data.map((item) => FoodAddOn.fromJson(item)).toList();
      print("Fetched all add-ons successfully.");
    } catch (e) {
      print("Exception in fetching add-ons: $e");
      throw Exception('Failed to fetch add-ons: $e');
    }
  }

  // Fetch an individual add-on by documentId
  Future<FoodAddOn?> fetchAddOnById(String documentId) async {
    try {
      final data = await _apiService.getAddOnByIdFoods(documentId);
      return FoodAddOn.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch add-on by documentId: $e');
    }
  }

  // Add a new add-on
  Future<void> addAddOn(String addonsName, int addonsPrice) async {
    try {
      final data = await _apiService.addAddOnFoods(addonsName, addonsPrice);
      final newAddOn = FoodAddOn.fromJson(data);
      state = [...state, newAddOn];
    } catch (e) {
      throw Exception('Failed to add add-on: $e');
    }
  }

  // Update an add-on by documentId
  Future<void> updateAddOn(
      String documentId, String newAddonsName, int newAddonsPrice) async {
    try {
      final updatedData = await _apiService.updateAddOnFoods(documentId, {
        'data': {
          'addons_name': newAddonsName,
          'addons_price': newAddonsPrice,
        }
      });
      final updatedAddOn = FoodAddOn.fromJson(updatedData);

      state = state.map((addOn) {
        if (addOn.documentId == documentId) {
          return updatedAddOn.copyWith(selected: addOn.selected);
        }
        return addOn;
      }).toList();
    } catch (e) {
      throw Exception('Failed to update add-on: $e');
    }
  }

  // Delete an add-on by documentId
  Future<void> deleteAddOn(String documentId) async {
    try {
      await _apiService.deleteAddOnFoods(documentId);
      state = state.where((addOn) => addOn.documentId != documentId).toList();
    } catch (e) {
      throw Exception('Failed to delete add-on: $e');
    }
  }
}
