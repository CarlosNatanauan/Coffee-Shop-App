import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color:
          Color.fromARGB(255, 253, 228, 228), // Set the background color here
      child: Center(
        child: Text(
          'Profile Screen',
          style: TextStyle(fontSize: 24, color: Colors.orange),
        ),
      ),
    );
  }
}