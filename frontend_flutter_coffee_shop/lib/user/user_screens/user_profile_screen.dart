import 'package:flutter/material.dart';
import '../../auth/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;
  final AuthService _authService = AuthService(); // Instance of AuthService

  ProfileScreen({required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 253, 228, 228),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Profile Screen',
              style: TextStyle(
                  fontSize: 24, color: Color.fromARGB(255, 81, 132, 110)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Perform logout by clearing session data
                await _authService.logout();
                print('User logged out successfully.');

                // Call the onLogout function passed from UserMainPage
                onLogout();
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 251, 185, 180),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
