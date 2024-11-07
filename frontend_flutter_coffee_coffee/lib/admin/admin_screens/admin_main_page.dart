import 'package:flutter/material.dart';
import 'package:sliding_clipped_nav_bar/sliding_clipped_nav_bar.dart';
import 'admin_drinks_screen.dart';
import 'admin_foods_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_home_screen.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  int selectedIndex = 0;
  final PageController controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: controller,
        children: [
          AdminHomeScreen(),
          AdminDrinksScreen(), // Screen for drinks
          AdminFoodsScreen(), // Screen for foods
          SettingsScreen(), // Add a settings screen as needed
        ],
      ),
      bottomNavigationBar: SlidingClippedNavBar(
        backgroundColor: Colors.white,
        onButtonPressed: (index) {
          setState(() {
            selectedIndex = index;
          });
          controller.animateToPage(selectedIndex,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutQuad);
        },
        iconSize: 30,
        activeColor: Color(0xFF01579B),
        selectedIndex: selectedIndex,
        barItems: [
          BarItem(
            icon: Icons.home,
            title: 'Home',
          ),
          BarItem(
            icon: Icons.coffee,
            title: 'Drinks',
          ),
          BarItem(
            icon: Icons.fastfood,
            title: 'Food',
          ),
          BarItem(
            icon: Icons.settings,
            title: 'Settings',
          ),
        ],
      ),
    );
  }
}
