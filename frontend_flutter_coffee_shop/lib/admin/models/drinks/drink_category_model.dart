class DrinkCategory {
  final int id;
  final String documentId;
  final String categoryName;
  final bool selected;

  DrinkCategory({
    required this.id,
    required this.documentId,
    required this.categoryName,
    this.selected = false,
  });

// Factory method to create an instance from JSON
  factory DrinkCategory.fromJson(Map<String, dynamic> json) {
    // Check if the 'data' key is present to handle both cases
    final data = json.containsKey('data') ? json['data'] : json;

    return DrinkCategory(
      id: data['id'] ?? 0, // Default to 0 if 'id' is null or missing
      documentId: data['documentId'] ?? '',
      categoryName: data['category_name'] ?? 'Unknown Category',
      selected: false,
    );
  }

  // Method to convert instance to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'documentId': documentId,
        'category_name': categoryName,
      },
    };
  }

  // copyWith method to create a modified copy of the instance
  DrinkCategory copyWith({
    int? id,
    String? documentId,
    String? categoryName,
    bool? selected,
  }) {
    return DrinkCategory(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      categoryName: categoryName ?? this.categoryName,
      selected: selected ?? this.selected,
    );
  }
}
