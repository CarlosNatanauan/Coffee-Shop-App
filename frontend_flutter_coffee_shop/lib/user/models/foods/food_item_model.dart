import 'food_category_model.dart';
import 'food_addons_model.dart';
import 'food_image_model.dart';

class FoodItem {
  final int id;
  final String documentId;
  final bool addOnsEnabled;
  final String foodName;
  final String foodDescription;
  final FoodCategory foodCategory;
  final List<FoodAddOn> foodAddOns;
  final double foodPrice;
  final List<FoodImage> foodImages;

  FoodItem({
    required this.id,
    required this.documentId,
    required this.addOnsEnabled,
    required this.foodName,
    required this.foodDescription,
    required this.foodCategory,
    required this.foodAddOns,
    required this.foodPrice,
    required this.foodImages,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      addOnsEnabled: json['addOnsEnabled'] ?? false,
      foodName: json['food_name'] ?? 'Unknown Food',
      foodDescription: json['food_description'] ?? 'No Description',
      foodCategory: FoodCategory.fromJson(json['food_category']),
      foodAddOns: (json['food_add_ons'] as List<dynamic>)
          .map((item) => FoodAddOn.fromJson(item))
          .toList(),
      foodPrice: (json['food_price'] ?? 0.0).toDouble(),
      foodImages: (json['food_image'] as List<dynamic>)
          .map((item) => FoodImage.fromJson(item))
          .toList(),
    );
  }
}
