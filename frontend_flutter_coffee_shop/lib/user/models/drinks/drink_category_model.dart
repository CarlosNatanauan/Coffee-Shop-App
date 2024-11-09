class DrinkCategory {
  final int id;
  final String documentId;
  final String categoryName;

  DrinkCategory({
    required this.id,
    required this.documentId,
    required this.categoryName,
  });

  // Factory method to create a `DrinkCategory` instance from JSON
  factory DrinkCategory.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return DrinkCategory(
      id: data['id'] ?? 0,
      documentId: data['documentId'] ?? '',
      categoryName: data['category_name'] ?? 'Unknown Category',
    );
  }

  // Method to convert instance to JSON (for potential POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'category_name': categoryName,
    };
  }
}
