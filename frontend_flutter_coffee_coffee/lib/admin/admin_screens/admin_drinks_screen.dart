import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'sub_screens/drinks/drinks_category_screen.dart';
import 'sub_screens/drinks/drinks_add_ons_screen.dart';
import 'sub_screens/drinks/add_edit_drink_item.dart';
import '../providers/drinks/drink_item_provider.dart';
import '../providers/drinks/drink_category_provider.dart';
import '../providers/drinks/selected_drink_category_provider.dart';
import '../models/drinks/drink_category_model.dart';

class AdminDrinksScreen extends ConsumerStatefulWidget {
  @override
  _AdminDrinksScreenState createState() => _AdminDrinksScreenState();
}

class _AdminDrinksScreenState extends ConsumerState<AdminDrinksScreen> {
  bool _isFirstLoad = true;
  final TextEditingController _searchController = TextEditingController();
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await ref.read(drinkCategoryProvider.notifier).fetchCategories();
    await ref.read(drinkItemProvider.notifier).fetchAllDrinkItems();

    final categories = ref.read(drinkCategoryProvider);
    if (categories.isNotEmpty) {
      ref.read(selectedDrinkCategoryProvider.notifier).state =
          -1; // "All Items" selected by default
    }
    setState(() {
      _isFirstLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final drinkItems = ref.watch(drinkItemProvider);
    final categories = ref.watch(drinkCategoryProvider);
    final selectedCategory = ref.watch(selectedDrinkCategoryProvider);
    const String strapiBaseUrl = "http://192.168.0.111:1337";

    // Define the "All Items" category
    final allItemsCategory = DrinkCategory(
      id: -1,
      documentId: 'all',
      categoryName: 'All Items',
    );

    // Add "All Items" to the category list
    final allCategories = [allItemsCategory, ...categories];

    // Filter drinks by selected category and search text
    final filteredDrinks = drinkItems
        .where((drink) =>
            (selectedCategory == -1 ||
                drink.drinkCategory.id == selectedCategory) &&
            (drink.drinkName.toLowerCase().contains(_searchText.toLowerCase())))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("Admin Drinks"),
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
                                .read(selectedDrinkCategoryProvider.notifier)
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
                  child: filteredDrinks.isEmpty
                      ? Center(
                          child: Text("No items available in this category"),
                        )
                      : ListView.builder(
                          itemCount: filteredDrinks.length,
                          itemBuilder: (context, index) {
                            final drink = filteredDrinks[index];
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
                                              AddEditDrinkItem(
                                                  drinkItem: drink),
                                        ),
                                      ).then((_) {
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
              child: Icon(Icons.local_drink),
              label: 'Drinks',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddEditDrinkItem(),
                  ),
                ).then((_) {
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
                  builder: (context) => DrinksCategoryScreen(),
                ),
              ),
            ),
            SpeedDialChild(
              child: Icon(Icons.add_box),
              label: 'Add Ons',
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DrinkAddOnsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
