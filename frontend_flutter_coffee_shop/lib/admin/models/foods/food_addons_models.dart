class FoodAddOn {
  final int id;
  final String documentId;
  final String addonsName;
  final double addonsPrice; // Changed to double
  final bool selected;

  FoodAddOn({
    required this.id,
    required this.documentId,
    required this.addonsName,
    required this.addonsPrice, // Changed to double
    this.selected = false,
  });

  factory FoodAddOn.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return FoodAddOn(
      id: data['id'] ?? 0,
      documentId: data['documentId'] ?? '',
      addonsName: data['addons_name'] ?? 'Unknown Add-On',
      addonsPrice:
          (data['addons_price'] as num?)?.toDouble() ?? 0.0, // Parse as double
      selected: false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': {
        'documentId': documentId,
        'addons_name': addonsName,
        'addons_price': addonsPrice, // Kept as double
      },
    };
  }

  FoodAddOn copyWith({
    int? id,
    String? documentId,
    String? addonsName,
    double? addonsPrice, // Changed to double
    bool? selected,
  }) {
    return FoodAddOn(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      addonsName: addonsName ?? this.addonsName,
      addonsPrice: addonsPrice ?? this.addonsPrice, // Kept as double
      selected: selected ?? this.selected,
    );
  }
}
