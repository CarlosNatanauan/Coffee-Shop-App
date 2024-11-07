class DrinkImage {
  final int id;
  final String documentId;
  final String? thumbnailUrl;
  final String? smallUrl;
  final String? mediumUrl;
  final String originalUrl;

  DrinkImage({
    required this.id,
    required this.documentId,
    required this.originalUrl,
    this.thumbnailUrl,
    this.smallUrl,
    this.mediumUrl,
  });

  factory DrinkImage.fromJson(Map<String, dynamic> json) {
    return DrinkImage(
      id: json['id'] ?? 0,
      documentId: json['documentId'] ?? '',
      originalUrl: json['url'] ?? '',
      thumbnailUrl: json['formats']?['thumbnail']?['url'],
      smallUrl: json['formats']?['small']?['url'],
      mediumUrl: json['formats']?['medium']?['url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'originalUrl': originalUrl,
      'thumbnailUrl': thumbnailUrl,
      'smallUrl': smallUrl,
      'mediumUrl': mediumUrl,
    };
  }
}
