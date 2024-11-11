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
    try {
      final authToken = await _authService.login(identifier, password);
      state = state.copyWith(
        isLoggedIn: true,
        token: authToken?.token,
        user: authToken?.user,
        errorMessage: null, // Clear any previous error
      );
    } catch (e) {
      String errorMessage = e.toString();

      // Match exact error messages
      if (errorMessage.contains("Invalid identifier or password")) {
        errorMessage = "Invalid identifier or password";
      } else if (errorMessage.contains("Your account email is not confirmed")) {
        errorMessage = "Your account email is not confirmed";
      } else {
        errorMessage = "An unknown error occurred";
      }

      // Set the error message in the state
      state = state.copyWith(errorMessage: errorMessage);
    }
  }

  // Logout the user
  Future<void> logout() async {
    await _authService.logout();
    state = AuthState(); // Reset to a fresh instance of AuthState
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

  // Clear any existing error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
