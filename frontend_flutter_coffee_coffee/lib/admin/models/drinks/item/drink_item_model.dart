import '../drink_category_model.dart';
import '../drink_addons_model.dart';
import '../item/drin_size_option.model.dart';
import '../item/drink_image_model.dart';

class DrinkItem {
  final int id;
  final String documentId;
  final bool addOnsEnabled;
  final String drinkName;
  final String drinkDescription;
  final DrinkCategory drinkCategory;
  final List<DrinkAddOn> drinkAddOns;
  final List<SizeOption> sizeOptions;
  final List<DrinkImage> drinkImages;

  DrinkItem({
    required this.id,
    required this.documentId,
    required this.addOnsEnabled,
    required this.drinkName,
    required this.drinkDescription,
    required this.drinkCategory,
    required this.drinkAddOns,
    required this.sizeOptions,
    required this.drinkImages,
  });

  factory DrinkItem.fromJson(Map<String, dynamic> json) {
    print("Parsing DrinkItem from JSON: $json"); // Debugging output
    return DrinkItem(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '', // Set a default if `null`
      addOnsEnabled: json['addOnsEnabled'] ?? false,
      drinkName: json['drink_name'] ?? 'Unknown Drink',
      drinkDescription: json['drink_description'] ?? 'No Description',
      drinkCategory: json['drink_category'] != null
          ? DrinkCategory.fromJson(json['drink_category'])
          : DrinkCategory(id: 0, documentId: '', categoryName: ''),
      drinkAddOns: (json['drink_add_ons'] as List<dynamic>?)
              ?.map((item) => DrinkAddOn.fromJson(item))
              .toList() ??
          [],
      sizeOptions: (json['sizeOptions'] as List<dynamic>?)
              ?.map((item) => SizeOption.fromJson(item))
              .toList() ??
          [],
      drinkImages: (json['drink_image'] as List<dynamic>?)
              ?.map((item) => DrinkImage.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson({bool isNew = false, bool isUpdate = false}) {
    return {
      if (!isNew && !isUpdate) 'id': id, // Exclude 'id' in update payload
      'addOnsEnabled': addOnsEnabled,
      'drink_name': drinkName,
      'drink_description': drinkDescription,
      'drink_category': drinkCategory.id,
      'drink_add_ons': drinkAddOns.map((addOn) => addOn.id).toList(),
      'sizeOptions': sizeOptions
          .map((size) => {
                'drink_size': size.drinkSize,
                'drink_price': size.drinkPrice,
              })
          .toList(),
      'drink_image': drinkImages.map((image) => image.id).toList(),
    };
  }
}
