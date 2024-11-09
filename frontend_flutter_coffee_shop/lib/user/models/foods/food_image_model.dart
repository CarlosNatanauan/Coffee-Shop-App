class FoodImage {
  final int id;
  final String documentId;
  final String? thumbnailUrl;
  final String? smallUrl;
  final String? mediumUrl;
  final String originalUrl;

  FoodImage({
    required this.id,
    required this.documentId,
    required this.originalUrl,
    this.thumbnailUrl,
    this.smallUrl,
    this.mediumUrl,
  });

  factory FoodImage.fromJson(Map<String, dynamic> json) {
    return FoodImage(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      originalUrl: json['url'] ?? '',
      thumbnailUrl: json['formats']?['thumbnail']?['url'],
      smallUrl: json['formats']?['small']?['url'],
      mediumUrl: json['formats']?['medium']?['url'],
    );
  }
}
