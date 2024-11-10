class DrinkAddOn {
  final int id;
  final String documentId;
  final String addonsName;
  final double addonsPrice; // Changed to double for decimal support
  final bool selected;

  DrinkAddOn({
    required this.id,
    required this.documentId,
    required this.addonsName,
    required this.addonsPrice, // Updated to double
    this.selected = false,
  });

  factory DrinkAddOn.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return DrinkAddOn(
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

  DrinkAddOn copyWith({
    int? id,
    String? documentId,
    String? addonsName,
    double? addonsPrice, // Changed to double
    bool? selected,
  }) {
    return DrinkAddOn(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      addonsName: addonsName ?? this.addonsName,
      addonsPrice: addonsPrice ?? this.addonsPrice, // Kept as double
      selected: selected ?? this.selected,
    );
  }
}
