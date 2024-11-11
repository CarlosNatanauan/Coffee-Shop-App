// auth_providers.dart
import 'package:riverpod/riverpod.dart';
import '../services/auth_service.dart';
import 'auth_notifier.dart';
import 'auth_state.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthNotifier(authService);
});
