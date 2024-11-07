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
    return DrinkItem(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      addOnsEnabled: json['addOnsEnabled'] ?? false,
      drinkName: json['drink_name'] ?? 'Unknown Drink',
      drinkDescription: json['drink_description'] ?? 'No Description',
      drinkCategory: DrinkCategory.fromJson(json['drink_category']),
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

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'addOnsEnabled': addOnsEnabled,
      'drink_name': drinkName,
      'drink_description': drinkDescription,
      'drink_category': drinkCategory.toJson(),
      'drink_add_ons': drinkAddOns.map((addOn) => addOn.toJson()).toList(),
      'sizeOptions': sizeOptions.map((size) => size.toJson()).toList(),
      'drink_image': drinkImages.map((image) => image.toJson()).toList(),
    };
  }
}
