import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'user_drink_screen.dart';
import 'user_food_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  int _selectedTabIndex = 0; // 0 for Food, 1 for Drink

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Color.fromARGB(255, 253, 228, 228), // Set background color
      appBar: AppBar(
        title: Text('Menu'),
        backgroundColor:
            Color.fromARGB(255, 253, 228, 228), // Match app background
        elevation: 0,
      ),
      body: Column(
        children: [
          // Toggle Tab for Food and Drink Selection
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: FlutterToggleTab(
              width: 60,
              height: 40,
              borderRadius: 30,
              selectedIndex: _selectedTabIndex,
              selectedBackgroundColors: [Color.fromARGB(255, 81, 132, 110)],
              unSelectedBackgroundColors: [Color.fromARGB(255, 255, 247, 247)],
              selectedTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              unSelectedTextStyle: TextStyle(
                color: Color.fromARGB(255, 81, 132, 110),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
              labels: ["Drinks", "Foods"],
              icons: [Icons.local_drink, FontAwesomeIcons.burger],
              iconSize: 20.0,
              selectedLabelIndex: (index) {
                setState(() {
                  _selectedTabIndex = index;
                });
              },
              marginSelected: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            ),
          ),
          Expanded(
            child: _selectedTabIndex == 0 ? DrinkScreen() : FoodScreen(),
          ),
        ],
      ),
    );
  }
}
