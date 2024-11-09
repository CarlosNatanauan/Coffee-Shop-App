import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/drinks/drink_category_provider.dart';
import '../providers/drinks/drink_item_provider.dart';
import 'widgets/drinks/category_text.dart';
import 'widgets/drinks/drink_item_card.dart';
import '../models/drinks/drink_item_model.dart';
import 'widgets/drinks/drink_detailed.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

final selectedCategoryProvider = StateProvider<int>((ref) => 0);
final searchQueryProvider = StateProvider<String>((ref) => '');

class DrinkScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryNotifier = ref.read(drinkCategoryProvider.notifier);
    final categories = ref.watch(drinkCategoryProvider);
    final selectedCategoryIndex = ref.watch(selectedCategoryProvider);
    final drinkItems = ref.watch(drinkItemProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // Fetch categories on first build if empty
    if (categories.isEmpty) {
      categoryNotifier.fetchCategories();
    }

    // Filter drink items based on selected category and search query
    List<DrinkItem> filteredDrinkItems = drinkItems.where((item) {
      bool matchesCategory = selectedCategoryIndex == 0 ||
          item.drinkCategory.id == categories[selectedCategoryIndex].id;

      bool matchesSearch =
          item.drinkName.toLowerCase().contains(searchQuery.toLowerCase());

      return matchesCategory && matchesSearch;
    }).toList();

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 228, 228),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 251, 242, 242),
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(
                  color: const Color.fromARGB(255, 199, 199, 199),
                  width: 1.5,
                ),
              ),
              child: TextField(
                onChanged: (value) {
                  ref.read(searchQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 136, 125, 125)),
                  hintText: 'Search Drink',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
          ),
          // Categories Title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Drink Categories',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(66, 66, 66, 1),
                  ),
                ),
              ],
            ),
          ),
          // Category Selector
          SizedBox(
            height: 40,
            child: categories.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          ref.read(selectedCategoryProvider.notifier).state =
                              index;
                        },
                        child: CategoryText(
                          categoryName: categories[index].categoryName,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
          ),
          // Display drink items in a scrollable grid
          Expanded(
            child: filteredDrinkItems.isEmpty
                ? Center(
                    child: Text(
                      'No available drinks in this category',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 1.0,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: filteredDrinkItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: DrinkDetailedScreen(
                                drinkItem: filteredDrinkItems[index],
                              ),
                              withNavBar:
                                  false, // Hide the bottom nav bar on the detailed screen
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: DrinkItemCard(
                            drinkItem: filteredDrinkItems[index],
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
