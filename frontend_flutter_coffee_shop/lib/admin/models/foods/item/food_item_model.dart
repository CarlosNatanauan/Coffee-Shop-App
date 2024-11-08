import '../food_category_model.dart';
import '../food_addons_models.dart';
import '../item/food_image_model.dart';

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
    print("Parsing FoodItem from JSON: $json"); // Debugging output
    return FoodItem(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '', // Set a default if `null`
      addOnsEnabled: json['addOnsEnabled'] ?? false,
      foodName: json['food_name'] ?? 'Unknown Food',
      foodDescription: json['food_description'] ?? 'No Description',
      foodCategory: json['food_category'] != null
          ? FoodCategory.fromJson(json['food_category'])
          : FoodCategory(id: 0, documentId: '', categoryName: ''),
      foodAddOns: (json['food_add_ons'] as List<dynamic>?)
              ?.map((item) => FoodAddOn.fromJson(item))
              .toList() ??
          [],
      foodPrice: (json['food_price'] as num?)?.toDouble() ?? 0.0,
      foodImages: (json['food_image'] as List<dynamic>?)
              ?.map((item) => FoodImage.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson({bool isNew = false, bool isUpdate = false}) {
    return {
      if (!isNew && !isUpdate) 'id': id, // Exclude 'id' in update payload
      'addOnsEnabled': addOnsEnabled,
      'food_name': foodName,
      'food_description': foodDescription,
      'food_category': foodCategory.id,
      'food_add_ons': foodAddOns.map((addOn) => addOn.id).toList(),
      'food_price': foodPrice,
      'food_image': foodImages.map((image) => image.id).toList(),
    };
  }
}
