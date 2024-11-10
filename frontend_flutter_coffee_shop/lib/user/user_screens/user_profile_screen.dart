import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Color.fromARGB(255, 253, 228, 228), // Set the background color here
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
              onPressed: () {
                // No logic for now
              },
              child: Text("Logout"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(
                    255, 251, 185, 180), // Set the button color to red
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
