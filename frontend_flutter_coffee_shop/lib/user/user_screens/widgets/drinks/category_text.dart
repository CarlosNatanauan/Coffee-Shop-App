import 'package:flutter/material.dart';

class CategoryText extends StatelessWidget {
  final String categoryName;
  final bool isSelected;

  const CategoryText({
    required this.categoryName,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected
              ? Color.fromARGB(255, 81, 132, 110)
              : Colors.transparent, // Updated to ARGB
          borderRadius: BorderRadius.circular(30.0),
          border: Border.all(
            color: isSelected
                ? Color.fromARGB(255, 81, 132, 110)
                : Colors.grey, // Updated border color
            width: 1.5,
          ),
        ),
        child: Text(
          categoryName,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}
