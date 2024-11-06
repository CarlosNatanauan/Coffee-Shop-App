import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/drinks/drink_addons_model.dart';
import '../services/api_services.dart';

final drinkAddOnsProvider =
    StateNotifierProvider<DrinkAddOnsNotifier, List<DrinkAddOn>>((ref) {
  return DrinkAddOnsNotifier();
});

class DrinkAddOnsNotifier extends StateNotifier<List<DrinkAddOn>> {
  DrinkAddOnsNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all add-ons
  Future<void> fetchAddOns() async {
    try {
      final data = await _apiService.getAddOns();
      state = data.map((item) => DrinkAddOn.fromJson(item)).toList();
    } catch (e) {
      throw Exception('Failed to fetch add-ons: $e');
    }
  }

  // Fetch an individual add-on by documentId
  Future<DrinkAddOn?> fetchAddOnById(String documentId) async {
    try {
      final data = await _apiService.getAddOnById(documentId);
      return DrinkAddOn.fromJson(data);
    } catch (e) {
      throw Exception('Failed to fetch add-on by documentId: $e');
    }
  }

  // Add a new add-on
  Future<void> addAddOn(String name, int price) async {
    try {
      final data = await _apiService.addAddOn(name, price);
      final newAddOn = DrinkAddOn.fromJson(data);
      state = [...state, newAddOn];
    } catch (e) {
      throw Exception('Failed to add add-on: $e');
    }
  }

  // Delete an add-on by documentId
  Future<void> deleteAddOn(String documentId) async {
    try {
      await _apiService.deleteAddOn(documentId);
      state = state.where((addOn) => addOn.documentId != documentId).toList();
    } catch (e) {
      throw Exception('Failed to delete add-on: $e');
    }
  }
}
