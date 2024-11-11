import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth/state/auth_providers.dart';
import './user/user_screens/user_main_screen.dart';
import './admin/admin_screens/admin_main_page.dart';
import './auth/login_screen.dart';

class SplashScreen extends ConsumerStatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authNotifier = ref.read(authNotifierProvider.notifier);

    // Check login status
    await authNotifier.checkLoginStatus();

    final authState = ref.read(authNotifierProvider);

    final token = authState.token;
    final user = authState.user;

    if (token != null && user != null) {
      // If token exists, check if user is admin
      if (user.username == "admin" || user.email == "admin@gmail.com") {
        // Navigate to AdminMainPage if username matches admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => AdminMainPage()),
        );
      } else {
        // Navigate to UserMainPage if username doesn't match admin
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => UserMainPage()),
        );
      }
    } else {
      // No token, navigate to login screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
