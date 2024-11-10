class SizeOption {
  final int id;
  final String drinkSize;
  final double drinkPrice; // Changed to double for decimal support

  SizeOption({
    required this.id,
    required this.drinkSize,
    required this.drinkPrice, // Updated to double
  });

  factory SizeOption.fromJson(Map<String, dynamic> json) {
    return SizeOption(
      id: json['id'] ?? 0,
      drinkSize: json['drink_size'] ?? 'Unknown Size',
      drinkPrice:
          (json['drink_price'] as num?)?.toDouble() ?? 0.0, // Parse as double
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'drink_size': drinkSize,
      'drink_price': drinkPrice, // Kept as double
    };
  }
}
