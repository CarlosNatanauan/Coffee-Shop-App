//auth_token_model.dart
import 'user_model.dart';

class AuthToken {
  final String token;
  final User user;

  AuthToken({
    required this.token,
    required this.user,
  });

  // Factory constructor to create AuthToken from JSON
  factory AuthToken.fromJson(Map<String, dynamic> json) {
    return AuthToken(
      token: json['jwt'],
      user: User.fromJson(json['user']),
    );
  }

  // Convert AuthToken instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'jwt': token,
      'user': user.toJson(),
    };
  }
}
