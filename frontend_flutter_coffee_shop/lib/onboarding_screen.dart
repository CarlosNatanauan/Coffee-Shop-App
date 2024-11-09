// lib/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'admin/admin_screens/admin_main_page.dart';
import 'user/user_screens/user_main_screen.dart';

class OnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Onboarding'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to AdminMainPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AdminMainPage()),
                );
              },
              child: Text('Admin'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to UserMainPage
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => UserMainPage()),
                );
              },
              child: Text('User'),
            ),
          ],
        ),
      ),
    );
  }
}
