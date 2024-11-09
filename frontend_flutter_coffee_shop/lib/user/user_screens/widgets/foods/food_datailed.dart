import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/foods/food_item_model.dart';
import '../../../models/foods/food_addons_model.dart';

// Define selectedAddOnsProvider to manage multiple selected add-ons for a specific FoodItem
final selectedAddOnsProvider =
    StateProvider.family<List<FoodAddOn>, FoodItem>((ref, foodItem) => []);

// Define addOnsVisibilityProvider to toggle the visibility of Add-Ons section
final addOnsVisibilityProvider =
    StateProvider.family<bool, FoodItem>((ref, foodItem) => false);

class FoodDetailedScreen extends ConsumerStatefulWidget {
  final FoodItem foodItem;

  FoodDetailedScreen({required this.foodItem});

  @override
  _FoodDetailedScreenState createState() => _FoodDetailedScreenState();
}

class _FoodDetailedScreenState extends ConsumerState<FoodDetailedScreen> {
  @override
  void initState() {
    super.initState();

    // Delay the provider state modification to avoid modifying the provider during build
    Future.microtask(() {
      ref.read(selectedAddOnsProvider(widget.foodItem).notifier).state = [];
      ref.read(addOnsVisibilityProvider(widget.foodItem).notifier).state =
          false;
    });
  }

  // Helper to format image URL with base URL
  String getImageUrl(String? relativeUrl) {
    return relativeUrl != null && relativeUrl.isNotEmpty
        ? 'http://192.168.0.111:1337$relativeUrl'
        : 'https://via.placeholder.com/100'; // Fallback placeholder
  }

  @override
  Widget build(BuildContext context) {
    final selectedAddOns = ref.watch(selectedAddOnsProvider(widget.foodItem));
    final addOnsVisible = ref.watch(addOnsVisibilityProvider(widget.foodItem));

    // Calculate total add-ons price
    final addOnsTotalPrice = selectedAddOns.fold<double>(
      0.0,
      (sum, addOn) => sum + addOn.addonsPrice,
    );

    // Calculate overall total price with add-ons
    final totalPrice = widget.foodItem.foodPrice + addOnsTotalPrice;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 253, 228, 228),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border),
            onPressed: () {
              // Handle favorite action
            },
          ),
        ],
        backgroundColor: Color.fromARGB(255, 253, 228, 228),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Food Image
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(getImageUrl(widget
                                  .foodItem.foodImages.isNotEmpty
                              ? widget.foodItem.foodImages[0].originalUrl
                              : null)), // Use fallback if no image available
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Category (Left Aligned)
                    Text(
                      widget.foodItem.foodCategory.categoryName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Food Name (Left Aligned) with Price
                    Text(
                      widget.foodItem.foodName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 132, 110),
                      ),
                    ),
                    SizedBox(height: 4),

                    // Display Food Price
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Price: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text:
                                '\$${widget.foodItem.foodPrice.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 20,
                              color: Color.fromARGB(255, 81, 132, 110),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Add-ons Section (Collapsible in a Container)
                    if (widget.foodItem.addOnsEnabled)
                      Container(
                        padding: EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, 254, 240, 240),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                ref
                                    .read(addOnsVisibilityProvider(
                                            widget.foodItem)
                                        .notifier)
                                    .state = !addOnsVisible;
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Add-Ons',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Icon(addOnsVisible
                                      ? Icons.arrow_drop_up
                                      : Icons.arrow_drop_down),
                                ],
                              ),
                            ),
                            if (addOnsVisible) ...[
                              SizedBox(height: 8),
                              if (addOnsTotalPrice > 0)
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: 'Add-Ons Price: ',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '\$${addOnsTotalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color:
                                              Color.fromARGB(255, 81, 132, 110),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              SizedBox(height: 6),
                              // Food Add-Ons (Aligned to the start, with rounded corners)
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 4.0,
                                children:
                                    widget.foodItem.foodAddOns.map((addOn) {
                                  final isSelected =
                                      selectedAddOns.contains(addOn);
                                  return FilterChip(
                                    label: Text(
                                      '${addOn.addonsName} (\$${addOn.addonsPrice.toStringAsFixed(2)})',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.grey[700],
                                      ),
                                    ),
                                    selected: isSelected,
                                    onSelected: (selected) {
                                      final updatedAddOns =
                                          List<FoodAddOn>.from(selectedAddOns);
                                      if (selected) {
                                        updatedAddOns.add(addOn);
                                      } else {
                                        updatedAddOns.remove(addOn);
                                      }
                                      ref
                                          .read(selectedAddOnsProvider(
                                                  widget.foodItem)
                                              .notifier)
                                          .state = updatedAddOns;
                                    },
                                    selectedColor: Color.fromARGB(255, 81, 132,
                                        110), // Color when selected
                                    backgroundColor:
                                        Color.fromARGB(255, 254, 240, 240),
                                    checkmarkColor: Colors
                                        .white, // Set checkmark color to white
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      side: BorderSide(
                                        color: isSelected
                                            ? Color.fromARGB(255, 81, 132, 110)
                                            : Colors
                                                .grey, // Updated border color
                                        width: 1.5,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),

                              SizedBox(height: 8),
                            ],
                          ],
                        ),
                      ),
                    SizedBox(height: 16),

                    // Description Label
                    Text(
                      'Description',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    SizedBox(height: 8),

                    // Food Description
                    Text(
                      widget.foodItem.foodDescription,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Action Area with Total, Buy Now, and Add to Cart in one line
          Container(
            color: Color.fromARGB(
                255, 254, 240, 240), // Set your desired background color here
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 132, 110)),
                  ),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          // Handle Buy Now action
                        },
                        child: Text(
                          'Buy Now',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 81, 132, 110),
                          minimumSize: Size(100, 40),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Add to Cart action
                        },
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 81, 132, 110),
                          minimumSize: Size(100, 40),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
