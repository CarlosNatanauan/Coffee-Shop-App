import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'admin_drinks_screen.dart';
import 'admin_foods_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_home_screen.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      AdminHomeScreen(),
      AdminDrinksScreen(), // Screen for drinks
      AdminFoodsScreen(), // Screen for foods
      AdminSettingsScreen(), // Add a settings screen as needed
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: ("Home"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.coffee),
        title: ("Drinks"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fastfood),
        title: ("Food"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.settings),
        title: ("Settings"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      controller: _controller,
      screens: _buildScreens(),
      items: _navBarsItems(),
      confineToSafeArea: true,
      backgroundColor: Color.fromARGB(255, 255, 247, 247),
      handleAndroidBackButtonPress: true,
      resizeToAvoidBottomInset: true,
      stateManagement: true,
      hideNavigationBarWhenKeyboardAppears: true,
      decoration: NavBarDecoration(
        borderRadius: BorderRadius.circular(10.0),
        colorBehindNavBar: Colors.white,
      ),
      popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
      navBarStyle: NavBarStyle.style7, // Matches the user main page's style
    );
  }
}
