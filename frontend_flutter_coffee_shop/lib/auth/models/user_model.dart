//user_model.dart
class User {
  final int id;
  final String username;
  final String email;
  final bool confirmed;
  final bool blocked;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.confirmed,
    required this.blocked,
  });

  // Factory constructor to create a User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
    );
  }

  // Convert User instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'confirmed': confirmed,
      'blocked': blocked,
    };
  }
}
