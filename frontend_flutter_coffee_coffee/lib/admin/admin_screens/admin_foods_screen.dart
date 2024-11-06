import 'package:flutter/material.dart';

class AdminFoodsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Foods"),
      ),
      body: Center(
        child: Text("Manage Foods Here"),
      ),
    );
  }
}
