class FoodCategory {
  final int id;
  final String documentId;
  final String categoryName;

  FoodCategory({
    required this.id,
    required this.documentId,
    required this.categoryName,
  });

  factory FoodCategory.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return FoodCategory(
      id: data['id'] ?? 0,
      documentId: data['documentId'] ?? '',
      categoryName: data['category_name'] ?? 'Unknown Category',
    );
  }
}
