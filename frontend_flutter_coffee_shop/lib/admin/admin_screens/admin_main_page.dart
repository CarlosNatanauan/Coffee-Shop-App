import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'admin_drinks_screen.dart';
import 'admin_foods_screen.dart';
import 'admin_settings_screen.dart';
import 'admin_home_screen.dart';
import '../../auth/login_screen.dart';
import '../../auth/state/auth_providers.dart';

class AdminMainPage extends StatefulWidget {
  @override
  _AdminMainPageState createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // Function to handle logout and reset the navigation stack
  void handleLogout(WidgetRef ref) async {
    // Perform logout by clearing authentication state
    await ref.read(authNotifierProvider.notifier).logout();

    // Optional: Add a short delay to ensure the state has time to update
    await Future.delayed(Duration(milliseconds: 200));

    // Reset controller and navigate back to LoginScreen
    _controller = PersistentTabController(initialIndex: 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  List<Widget> _buildScreens(WidgetRef ref) {
    return [
      AdminHomeScreen(),
      AdminDrinksScreen(),
      AdminFoodsScreen(),
      AdminSettingsScreen(
          onLogout: () => handleLogout(ref)), // Pass ref to handleLogout
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
    return Consumer(
      builder: (context, ref, child) {
        return PersistentTabView(
          context,
          controller: _controller,
          screens: _buildScreens(ref), // Pass ref to _buildScreens
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
          navBarStyle: NavBarStyle.style7,
        );
      },
    );
  }
}
