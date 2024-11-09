import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/foods/food_addons_model.dart';
import '../../services/api_services.dart';

final foodAddOnProvider =
    StateNotifierProvider<FoodAddOnNotifier, List<FoodAddOn>>((ref) {
  return FoodAddOnNotifier();
});

class FoodAddOnNotifier extends StateNotifier<List<FoodAddOn>> {
  FoodAddOnNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all food add-ons
  Future<void> fetchAddOns() async {
    try {
      final data = await _apiService.getFoodAddOns();
      state = data.map((item) => FoodAddOn.fromJson(item)).toList();
      print("Fetched all food add-ons successfully.");
    } catch (e) {
      print("Exception in fetching add-ons: $e");
      throw Exception('Failed to fetch add-ons: $e');
    }
  }
}
