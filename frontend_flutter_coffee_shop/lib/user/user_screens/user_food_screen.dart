import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/foods/food_category_provider.dart';
import '../providers/foods/food_item_provider.dart';
import 'widgets/foods/category_text.dart';
import 'widgets/foods/food_item_card.dart';
import '../models/foods/food_item_model.dart';
import './widgets/foods/food_datailed.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import '../providers/refresh_provider.dart'; // Import providers.dart

final selectedFoodCategoryProvider = StateProvider<int>((ref) => 0);
final foodSearchQueryProvider = StateProvider<String>((ref) => '');

class FoodScreen extends ConsumerWidget {
  final TextEditingController _foodSearchController = TextEditingController();
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  FoodScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen for changes in the refreshProvider
    ref.listen<bool>(refreshProvider, (_, __) {
      // Reload categories and items when refresh is triggered
      ref.read(foodCategoryProvider.notifier).fetchCategories();
      ref.read(foodItemProvider.notifier).fetchAllFoodItems();

      // Reset the selected category to "All Foods" (index 0)
      ref.read(selectedFoodCategoryProvider.notifier).state = 0;

      // Clear the search query and update the search controller
      ref.read(foodSearchQueryProvider.notifier).state = '';
      _foodSearchController.clear();

      // Scroll back to the start of the category list
      _scrollController.animateTo(
        0, // Scroll to the start position
        duration: Duration(milliseconds: 300), // Smooth scroll duration
        curve: Curves.easeInOut, // Smooth scroll curve
      );
      // Clear the search query and update the search controller
      ref.read(foodSearchQueryProvider.notifier).state = '';
      _foodSearchController.clear();
    });

    final categoryNotifier = ref.read(foodCategoryProvider.notifier);
    final categories = ref.watch(foodCategoryProvider);
    final selectedCategoryIndex = ref.watch(selectedFoodCategoryProvider);
    final foodItems = ref.watch(foodItemProvider);
    final searchQuery = ref.watch(foodSearchQueryProvider);

    // Keep the controller text in sync with the provider value
    if (_foodSearchController.text != searchQuery) {
      _foodSearchController.text = searchQuery;
    }

    // Fetch categories on first build if empty
    if (categories.isEmpty) {
      categoryNotifier.fetchCategories();
    }

    // Filter food items based on selected category and search query
    List<FoodItem> filteredFoodItems = foodItems.where((item) {
      bool matchesCategory = selectedCategoryIndex == 0 ||
          item.foodCategory.id == categories[selectedCategoryIndex].id;

      bool matchesSearch =
          item.foodName.toLowerCase().contains(searchQuery.toLowerCase());

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
                controller: _foodSearchController, // Attach the controller here
                onChanged: (value) {
                  ref.read(foodSearchQueryProvider.notifier).state = value;
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 136, 125, 125)),
                  hintText: 'Search Food',
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
                  'Food Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          // Category Selector with ScrollController
          SizedBox(
            height: 40,
            child: categories.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    controller:
                        _scrollController, // Attach the scroll controller here
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final isSelected = selectedCategoryIndex == index;
                      return GestureDetector(
                        onTap: () {
                          ref
                              .read(selectedFoodCategoryProvider.notifier)
                              .state = index;
                        },
                        child: CategoryText(
                          categoryName: categories[index].categoryName,
                          isSelected: isSelected,
                        ),
                      );
                    },
                  ),
          ),
          // Display food items in a scrollable grid
          Expanded(
            child: filteredFoodItems.isEmpty
                ? Center(
                    child: Text(
                      'No available foods in this category',
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
                      itemCount: filteredFoodItems.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            PersistentNavBarNavigator.pushNewScreen(
                              context,
                              screen: FoodDetailedScreen(
                                foodItem: filteredFoodItems[index],
                              ),
                              withNavBar:
                                  false, // Hide the bottom nav bar on the detailed screen
                              pageTransitionAnimation:
                                  PageTransitionAnimation.cupertino,
                            );
                          },
                          child: FoodItemCard(
                            foodItem: filteredFoodItems[index],
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
