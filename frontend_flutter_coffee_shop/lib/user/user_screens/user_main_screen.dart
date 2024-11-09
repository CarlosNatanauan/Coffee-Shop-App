import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'user_cart_screen.dart';
import 'user_profile_screen.dart';
import 'user_food_screen.dart';
import 'user_drink_screen.dart';
import 'user_order_screen.dart';

class UserMainPage extends StatefulWidget {
  @override
  _UserMainPageState createState() => _UserMainPageState();
}

class _UserMainPageState extends State<UserMainPage> {
  int _page = 0;
  GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  PageController _pageController = PageController(initialPage: 0);

  final List<Widget> _pages = [
    DrinkScreen(),
    FoodScreen(),
    OrderScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onPageChanged(int index) {
    setState(() {
      _page = index;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _page = index;
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: _page,
        height: 68,
        items: <Widget>[
          Icon(
            Icons.coffee,
            size: 30,
            color: Color.fromARGB(255, 81, 132, 110),
          ),
          Icon(Icons.fastfood,
              size: 30, color: Color.fromARGB(255, 81, 132, 110)),
          Icon(Icons.shopping_cart,
              size: 30, color: Color.fromARGB(255, 81, 132, 110)),
          Icon(Icons.history,
              size: 30, color: Color.fromARGB(255, 81, 132, 110)),
          Icon(Icons.person,
              size: 30, color: Color.fromARGB(255, 81, 132, 110)),
        ],
        color: Color.fromARGB(255, 254, 240, 240),
        buttonBackgroundColor: Color.fromARGB(255, 244, 255, 250),
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 120),
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: _pages,
      ),
    );
  }
}
