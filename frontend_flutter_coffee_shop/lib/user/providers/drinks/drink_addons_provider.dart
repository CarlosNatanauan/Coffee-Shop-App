import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/drinks/drink_addons_model.dart';
import '../../services/api_services.dart';

final drinkAddOnProvider =
    StateNotifierProvider<DrinkAddOnNotifier, List<DrinkAddOn>>((ref) {
  return DrinkAddOnNotifier();
});

class DrinkAddOnNotifier extends StateNotifier<List<DrinkAddOn>> {
  DrinkAddOnNotifier() : super([]);

  final ApiService _apiService = ApiService();

  // Fetch all drink add-ons
  Future<void> fetchAddOns() async {
    try {
      final data = await _apiService.getDrinkAddOns();
      state = data.map((item) => DrinkAddOn.fromJson(item)).toList();
      print("Fetched all drink add-ons successfully.");
    } catch (e) {
      print("Exception in fetching add-ons: $e");
      throw Exception('Failed to fetch add-ons: $e');
    }
  }
}
