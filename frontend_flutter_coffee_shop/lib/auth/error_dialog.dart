import 'package:flutter/material.dart';

class FloatingDialog extends StatelessWidget {
  final String message;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onDismiss; // Callback function when dialog is dismissed

  const FloatingDialog({
    Key? key,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.onDismiss, // Add this parameter to the constructor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 40),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: iconColor,
                size: 40,
              ),
              SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  onDismiss(); // Call the onDismiss callback
                },
                child: Text("OK"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
