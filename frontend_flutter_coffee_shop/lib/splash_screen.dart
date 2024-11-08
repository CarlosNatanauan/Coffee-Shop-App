import 'package:flutter/material.dart';
import 'admin/admin_screens/admin_main_page.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async {
    // Simulate a network request or loading time
    await Future.delayed(Duration(seconds: 1));
    // Navigate to the admin main page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => AdminMainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Loading...',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
