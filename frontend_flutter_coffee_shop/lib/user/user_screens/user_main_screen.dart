import 'package:flutter/material.dart';
import 'user_cart_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'user_menu_screen.dart';
import 'user_profile_screen.dart';
import 'user_order_screen.dart';

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  PersistentTabController _controller =
      PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      MenuScreen(),
      CartScreen(),
      OrderScreen(),
      ProfileScreen(),
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
      navBarStyle: NavBarStyle.style7,
    );
  }
}
