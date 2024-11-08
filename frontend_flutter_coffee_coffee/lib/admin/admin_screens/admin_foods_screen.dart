import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'sub_screens/foods/foods_category_screen.dart';
import 'sub_screens/foods/foods_add_ons_screen.dart';
import 'sub_screens/foods/add_edit_food_item.dart';
import '../providers/foods/food_item_provider.dart'; // Import your provider

class AdminFoodsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Access food items from the provider
    final foodItems = ref.watch(foodItemProvider);
    const String strapiBaseUrl =
        "http://192.168.0.111:1337"; // Replace with your actual Strapi server URL

    // Fetch items if the list is empty
    if (foodItems.isEmpty) {
      ref.read(foodItemProvider.notifier).fetchAllFoodItems();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Foods"),
      ),
      body: foodItems.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: foodItems.length,
              itemBuilder: (context, index) {
                final food = foodItems[index];
                return ListTile(
                  leading: SizedBox(
                    width: 50,
                    height: 50,
                    child: Image.network(
                      food.foodImages.isNotEmpty
                          ? '$strapiBaseUrl${food.foodImages[0].thumbnailUrl ?? food.foodImages[0].originalUrl}'
                          : 'https://via.placeholder.com/150',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(Icons.broken_image, size: 50);
                      },
                    ),
                  ),
                  title: Text(food.foodName),
                  subtitle: Text("Price: \$${food.foodPrice}"),
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
                                  AddEditFoodItem(foodItem: food),
                            ),
                          ).then((_) {
                            // Refresh food items when returning to the screen
                            ref
                                .read(foodItemProvider.notifier)
                                .fetchAllFoodItems();
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          await ref
                              .read(foodItemProvider.notifier)
                              .deleteFoodItem(food.documentId);
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
              child: Icon(Icons.restaurant),
              label: 'Foods',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditFoodItem(),
                  ),
                ).then((_) {
                  // Refresh food items when returning to the screen
                  ref.read(foodItemProvider.notifier).fetchAllFoodItems();
                });
              },
            ),
            SpeedDialChild(
              child: Icon(Icons.category),
              label: 'Category',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodsCategoryScreen(),
                ),
              ),
            ),
            SpeedDialChild(
              child: Icon(Icons.add_box),
              label: 'Add Ons',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FoodAddOnsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
