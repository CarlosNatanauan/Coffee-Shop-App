import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_drink_screen.dart';
import 'user_food_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'wrap_indicator.dart';
import '../providers/refresh_provider.dart'; // Import providers.dart

class MenuScreen extends ConsumerStatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  int _selectedTabIndex = 0; // 0 for Food, 1 for Drink
  Key _drinkScreenKey = UniqueKey(); // Unique key for DrinkScreen

  // Function to handle refresh logic
  Future<void> _onRefresh() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      _drinkScreenKey = UniqueKey(); // Assign a new key to rebuild DrinkScreen
    });
    // Toggle the refreshProvider to notify DrinkScreen of the refresh
    ref.read(refreshProvider.notifier).state = !ref.read(refreshProvider);
  }

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
      body: WarpIndicator(
        onRefresh: _onRefresh, // Set the refresh logic here
        starsCount: 30,
        skyColor:
            Color.fromARGB(255, 253, 228, 228), // Background color of the "sky"
        starColorGetter: (index) =>
            Color.fromARGB(255, 81, 132, 110), // Star color
        child: Column(
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
                unSelectedBackgroundColors: [
                  Color.fromARGB(255, 255, 247, 247)
                ],
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
                marginSelected:
                    EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              ),
            ),
            Expanded(
              child: _selectedTabIndex == 0
                  ? DrinkScreen() // Pass the unique key
                  : FoodScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
