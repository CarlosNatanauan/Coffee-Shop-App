import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'state/auth_providers.dart';
import '../admin/admin_screens/admin_main_page.dart';
import '../user/user_screens/user_main_screen.dart';
import './models/user_model.dart';
import 'dart:convert'; // For jsonEncode()
import './state/auth_state.dart';

class LoginScreen extends ConsumerStatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _identifierController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _errorHandled = false; // Flag to prevent repeated error dialogs

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authNotifierProvider.notifier).clearError();
      _errorHandled =
          false; // Ensure error handled flag is reset on screen load
      print("Cleared any previous error state on screen load.");
    });
  }

  Future<void> _login() async {
    final identifier = _identifierController.text;
    final password = _passwordController.text;

    print("Login button clicked with identifier: $identifier");

    final authNotifier = ref.read(authNotifierProvider.notifier);
    await authNotifier.login(identifier, password);

    final authState = ref.read(authNotifierProvider);
    final user = authState.user;
    if (user != null) {
      if (user.username == "admin" || user.email == "admin@gmail.com") {
        await _storeUserInfo(user, authState.token!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminMainPage()),
        );
      } else {
        await _storeUserInfo(user, authState.token!);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserMainPage()),
        );
      }
    }
  }

  Future<void> _storeUserInfo(User user, String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('auth_token', token);
    prefs.setString('user', jsonEncode(user.toJson()));
    print("Stored user information and token in SharedPreferences.");
  }

  // Show simple dialog with message
  void _showErrorDialog(String message) {
    print("Attempting to show error dialog with message: $message");
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                print("OK button clicked in error dialog.");
                Navigator.of(context, rootNavigator: true)
                    .pop(); // Ensure dialog is dismissed
                ref
                    .read(authNotifierProvider.notifier)
                    .clearError(); // Clear error state after dialog is closed
                _errorHandled = false; // Reset the error handled flag
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authNotifierProvider, (previous, next) {
      // Only show the error dialog if there is an error and it hasn't been handled
      if (next.errorMessage != null && !_errorHandled) {
        _errorHandled = true; // Set the flag to prevent repeated dialogs
        String message;

        if (next.errorMessage!.contains("Invalid identifier or password")) {
          message = "Invalid username or password. Please try again.";
        } else if (next.errorMessage!
            .contains("Your account email is not confirmed")) {
          message = "Account not confirmed. Please check your email.";
        } else {
          message = "An unknown error occurred.";
        }

        print("Error detected: $message");
        _showErrorDialog(message);
      } else if (next.errorMessage == null) {
        // Reset _errorHandled if there is no error message (fresh state)
        _errorHandled = false;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _identifierController,
              decoration: InputDecoration(labelText: "Username or Email"),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password"),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
