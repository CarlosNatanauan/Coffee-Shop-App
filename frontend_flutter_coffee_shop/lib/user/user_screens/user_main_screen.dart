import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import 'user_cart_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'user_menu_screen.dart';
import 'user_profile_screen.dart';
import 'user_order_screen.dart';
import '../../auth/login_screen.dart';
import '../../auth/state/auth_providers.dart';
import 'dart:async';

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  // Function to handle logout and reset the navigation stack
  void handleLogout(WidgetRef ref) async {
    await ref
        .read(authNotifierProvider.notifier)
        .logout(); // Ensure logout fully clears the state

    // Optional: Add a short delay to ensure state has time to update
    await Future.delayed(Duration(milliseconds: 200));

    // Reset controller and navigate to LoginScreen
    _controller = PersistentTabController(initialIndex: 0);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  List<Widget> _buildScreens(WidgetRef ref) {
    return [
      MenuScreen(),
      CartScreen(),
      OrderScreen(),
      ProfileScreen(
          onLogout: () => handleLogout(ref)), // Pass ref to handleLogout
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.fastfood),
        title: ("Menu"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.shopping_cart),
        title: ("Cart"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.history),
        title: ("Orders"),
        iconSize: 23.0,
        textStyle: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
        activeColorPrimary: Color.fromARGB(255, 81, 132, 110),
        activeColorSecondary: Colors.white,
        inactiveColorPrimary: Color.fromARGB(255, 81, 132, 110),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person),
        title: ("Profile"),
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
      // Use Consumer to provide access to ref in the build context
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
