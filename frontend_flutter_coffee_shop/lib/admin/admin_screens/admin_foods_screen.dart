import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'sub_screens/foods/foods_category_screen.dart';
import 'sub_screens/foods/foods_add_ons_screen.dart';
import 'sub_screens/foods/add_edit_food_item.dart';
import '../providers/foods/food_item_provider.dart';
import '../providers/foods/food_category_provider.dart';
import '../providers/foods/selected_food_category_provider.dart';
import '../models/foods/food_category_model.dart';

class AdminFoodsScreen extends ConsumerStatefulWidget {
  @override
  _AdminFoodsScreenState createState() => _AdminFoodsScreenState();
}

class _AdminFoodsScreenState extends ConsumerState<AdminFoodsScreen> {
  bool _isFirstLoad = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await ref.read(foodCategoryProvider.notifier).fetchCategories();
    await ref.read(foodItemProvider.notifier).fetchAllFoodItems();

    final categories = ref.read(foodCategoryProvider);
    if (categories.isNotEmpty) {
      ref.read(selectedFoodCategoryProvider.notifier).state =
          -1; // "All Items" selected by default
    }
    setState(() {
      _isFirstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final foodItems = ref.watch(foodItemProvider);
    final categories = ref.watch(foodCategoryProvider);
    final selectedCategory = ref.watch(selectedFoodCategoryProvider);
    const String strapiBaseUrl = "http://192.168.0.111:1337";

    // Define the "All Items" category
    final allItemsCategory = FoodCategory(
      id: -1,
      documentId: 'all',
      categoryName: 'All Items',
    );

    // Add "All Items" to the category list
    final allCategories = [allItemsCategory, ...categories];

    // Filter foods by selected category and search text
    final filteredFoods = foodItems
        .where((food) =>
            (selectedCategory == -1 ||
                food.foodCategory.id == selectedCategory) &&
            (food.foodName.toLowerCase().contains(_searchText.toLowerCase())))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Foods"),
      ),
      body: _isFirstLoad
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (text) {
                      setState(() {
                        _searchText = text;
                      });
                    },
                  ),
                ),
                // Category List at the top
                SizedBox(
                  height: 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: allCategories.length,
                    itemBuilder: (context, index) {
                      final category = allCategories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: ChoiceChip(
                          label: Text(category.categoryName),
                          selected: selectedCategory == category.id,
                          onSelected: (bool selected) {
                            ref
                                .read(selectedFoodCategoryProvider.notifier)
                                .state = selected ? category.id : -1;
                          },
                          selectedColor: Theme.of(context).primaryColor,
                          labelStyle: TextStyle(
                            color: selectedCategory == category.id
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: filteredFoods.isEmpty
                      ? Center(
                          child: Text("No items available in this category"),
                        )
                      : ListView.builder(
                          itemCount: filteredFoods.length,
                          itemBuilder: (context, index) {
                            final food = filteredFoods[index];
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
                ),
              ],
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
