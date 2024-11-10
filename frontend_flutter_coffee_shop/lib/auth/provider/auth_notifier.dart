// auth_notifier.dart
import 'package:riverpod/riverpod.dart';
import '../services/auth_service.dart';
import 'auth_state.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService _authService;

  AuthNotifier(this._authService) : super(AuthState());

  // Register a new user
  Future<void> register(String username, String email, String password) async {
    final success = await _authService.register(username, email, password);
    if (success) {
      state = state.copyWith(errorMessage: null);
    } else {
      state = state.copyWith(errorMessage: "Registration failed");
    }
  }

  // Login the user
  Future<void> login(String identifier, String password) async {
    final authToken = await _authService.login(identifier, password);
    if (authToken != null) {
      state = state.copyWith(
        isLoggedIn: true,
        token: authToken.token,
        user: authToken.user,
        errorMessage: null,
      );
    } else {
      state = state.copyWith(errorMessage: "Login failed");
    }
  }

  // Logout the user
  Future<void> logout() async {
    await _authService.logout();
    state = state.copyWith(
      isLoggedIn: false,
      token: null,
      user: null,
    );
  }

  // Check if user is logged in (restore from shared preferences)
  Future<void> checkLoginStatus() async {
    final authToken = await _authService.getStoredToken();
    if (authToken != null) {
      state = state.copyWith(
        isLoggedIn: true,
        token: authToken.token,
        user: authToken.user,
      );
    }
  }
}
