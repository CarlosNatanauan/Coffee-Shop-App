class SizeOption {
  final int id;
  final String drinkSize;
  final double drinkPrice;

  SizeOption({
    required this.id,
    required this.drinkSize,
    required this.drinkPrice,
  });

  factory SizeOption.fromJson(Map<String, dynamic> json) {
    return SizeOption(
      id: json['id'] ?? 0,
      drinkSize: json['drink_size'] ?? 'Unknown Size',
      drinkPrice: (json['drink_price'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drink_size': drinkSize,
      'drink_price': drinkPrice,
    };
  }
}
