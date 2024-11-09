class FoodAddOn {
  final int id;
  final String documentId;
  final String addonsName;
  final double addonsPrice;

  FoodAddOn({
    required this.id,
    required this.documentId,
    required this.addonsName,
    required this.addonsPrice,
  });

  factory FoodAddOn.fromJson(Map<String, dynamic> json) {
    final data = json.containsKey('data') ? json['data'] : json;

    return FoodAddOn(
      id: data['id'] ?? 0,
      documentId: data['documentId'] ?? '',
      addonsName: data['addons_name'] ?? 'Unknown Add-On',
      addonsPrice: (data['addons_price'] ?? 0.0).toDouble(),
    );
  }
}
