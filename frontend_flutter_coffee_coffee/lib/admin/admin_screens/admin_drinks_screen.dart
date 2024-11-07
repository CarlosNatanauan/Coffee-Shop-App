import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../admin_screens/sub_screens/category_screen.dart';
import '../admin_screens/sub_screens/add_ons_screen.dart';
import '../admin_screens/sub_screens/add_edit_drink_item.dart';
import '../providers/drink_item_provider.dart'; // Import your provider

class AdminDrinksScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access drink items from the provider
    final drinkItems = ref.watch(drinkItemProvider);
    const String strapiBaseUrl =
        "http://192.168.0.111:1337"; // Replace with your actual Strapi server URL

    // Fetch items if the list is empty
    if (drinkItems.isEmpty) {
      ref.read(drinkItemProvider.notifier).fetchAllDrinkItems();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Drinks"),
      ),
      body: drinkItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: drinkItems.length,
              itemBuilder: (context, index) {
                final drink = drinkItems[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      drink.drinkImages.isNotEmpty
                          ? '$strapiBaseUrl${drink.drinkImages[0].thumbnailUrl ?? drink.drinkImages[0].originalUrl}'
                          : 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  title: Text(drink.drinkName),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AddEditDrinkItem(drinkItem: drink),
                            ),
                          ).then((_) {
                            // Refresh drink items when returning to the screen
                            ref
                                .read(drinkItemProvider.notifier)
                                .fetchAllDrinkItems();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await ref
                              .read(drinkItemProvider.notifier)
                              .deleteDrinkItem(drink.documentId);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.01),
        child: SpeedDial(
          icon: Icons.add,
          activeIcon: Icons.close,
          spacing: 3,
          openCloseDial: ValueNotifier(false),
          childPadding: const EdgeInsets.all(5),
          spaceBetweenChildren: 4,
          direction: SpeedDialDirection.up,
          children: [
            SpeedDialChild(
              child: Icon(Icons.local_drink),
              label: 'Drinks',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditDrinkItem(),
                  ),
                ).then((_) {
                  // Refresh drink items when returning to the screen
                  ref.read(drinkItemProvider.notifier).fetchAllDrinkItems();
                });
              },
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
