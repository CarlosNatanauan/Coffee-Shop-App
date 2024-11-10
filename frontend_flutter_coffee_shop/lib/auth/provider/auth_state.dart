// auth_state.dart
import '../models/user_model.dart';

class AuthState {
  final bool isLoggedIn;
  final String? token;
  final User? user;
  final String? errorMessage;

  AuthState({
    this.isLoggedIn = false,
    this.token,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? token,
    User? user,
    String? errorMessage,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      token: token ?? this.token,
      user: user ?? this.user,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
