class DrinkAddOn {
  final int id;
  final String documentId;
  final String addonsName;
  final double addonsPrice;

  DrinkAddOn({
    required this.id,
    required this.documentId,
    required this.addonsName,
    required this.addonsPrice,
  });

  // Factory method to create a `DrinkAddOn` instance from JSON
  factory DrinkAddOn.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return DrinkAddOn(
      id: data['id'] ?? 0,
      documentId: data['documentId'] ?? '',
      addonsName: data['addons_name'] ?? 'Unknown Add-On',
      addonsPrice: (data['addons_price'] ?? 0.0).toDouble(),
    );
  }

  // Method to convert instance to JSON (for potential POST/PUT requests)
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'addons_name': addonsName,
      'addons_price': addonsPrice,
    };
  }
}
