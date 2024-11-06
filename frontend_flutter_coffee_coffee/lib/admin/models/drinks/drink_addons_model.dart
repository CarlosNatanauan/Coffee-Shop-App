class DrinkAddOn {
  final int id;
  final String documentId;
  final String addonsName;
  final int addonsPrice;

  DrinkAddOn({
    required this.id,
    required this.documentId,
    required this.addonsName,
    required this.addonsPrice,
  });

  // Factory method to create an instance from JSON
  factory DrinkAddOn.fromJson(Map<String, dynamic> json) {
    return DrinkAddOn(
      id: json['id'],
      documentId: json['attributes']['documentId'],
      addonsName: json['attributes']['addons_name'],
      addonsPrice: json['attributes']['addons_price'],
    );
  }

  // Method to convert instance to JSON for POST/PUT requests
  Map<String, dynamic> toJson() {
    return {
      'data': {
        'documentId':
            documentId, // Optional: Only needed if you need to send it back
        'addons_name': addonsName,
        'addons_price': addonsPrice,
      },
    };
  }
}
