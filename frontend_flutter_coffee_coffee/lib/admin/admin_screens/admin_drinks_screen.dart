import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../admin_screens/sub_screens/category_screen.dart';
import '../admin_screens/sub_screens/add_ons_screen.dart';

class AdminDrinksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double paddingBottom =
        screenHeight * 0.01; // Adjust this percentage as needed

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Drinks"),
      ),
      body: Center(
        child: Text("Manage Drinks Here"),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: paddingBottom),
        child: SpeedDial(
          icon: Icons.add, // Main icon for the speed dial
          activeIcon: Icons.close, // Icon when opened
          spacing: 3,
          openCloseDial: ValueNotifier(false),
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          direction: SpeedDialDirection.up, // Expands upward
          children: [
            SpeedDialChild(
              child: Icon(Icons.local_drink),
              label: 'Drinks',
              onTap: () => print("Drinks option selected"),
            ),
            SpeedDialChild(
              child: Icon(Icons.category),
              label: 'Category',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CategoryScreen(),
                ),
              ),
            ),
            SpeedDialChild(
              child: Icon(Icons.add_box),
              label: 'Add Ons',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOnsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
