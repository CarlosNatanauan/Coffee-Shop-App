import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/drinks/drink_item_model.dart';
import '../../../models/drinks/drink_size_option.model.dart';
import '../../../models/drinks/drink_addons_model.dart';

// Define selectedSizeProvider using StateProvider.family to make it specific to each DrinkItem
final selectedSizeProvider =
    StateProvider.family<String, DrinkItem>((ref, drinkItem) {
  return drinkItem.sizeOptions.isNotEmpty
      ? drinkItem.sizeOptions.first.drinkSize
      : 'N/A';
});

// Define selectedAddOnsProvider to manage multiple selected add-ons for a specific DrinkItem
final selectedAddOnsProvider =
    StateProvider.family<List<DrinkAddOn>, DrinkItem>((ref, drinkItem) => []);

// Define addOnsVisibilityProvider to toggle the visibility of Add-Ons section
final addOnsVisibilityProvider =
    StateProvider.family<bool, DrinkItem>((ref, drinkItem) => false);

class DrinkDetailedScreen extends ConsumerStatefulWidget {
  final DrinkItem drinkItem;

  DrinkDetailedScreen({required this.drinkItem});

  @override
  _DrinkDetailedScreenState createState() => _DrinkDetailedScreenState();
}

class _DrinkDetailedScreenState extends ConsumerState<DrinkDetailedScreen> {
  @override
  void initState() {
    super.initState();

    // Delay the provider state modification to avoid modifying the provider during build
    Future.microtask(() {
      ref.read(selectedSizeProvider(widget.drinkItem).notifier).state =
          widget.drinkItem.sizeOptions.isNotEmpty
              ? widget.drinkItem.sizeOptions.first.drinkSize
              : 'N/A';
      ref.read(selectedAddOnsProvider(widget.drinkItem).notifier).state = [];
      ref.read(addOnsVisibilityProvider(widget.drinkItem).notifier).state =
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
    final selectedSize = ref.watch(selectedSizeProvider(widget.drinkItem));
    final selectedAddOns = ref.watch(selectedAddOnsProvider(widget.drinkItem));
    final addOnsVisible = ref.watch(addOnsVisibilityProvider(widget.drinkItem));

    // Get the price based on the selected size
    final currentSizeOption = widget.drinkItem.sizeOptions.firstWhere(
      (option) => option.drinkSize == selectedSize,
      orElse: () => SizeOption(id: -1, drinkSize: 'N/A', drinkPrice: 0.0),
    );

    // Calculate total add-ons price
    final addOnsTotalPrice = selectedAddOns.fold<double>(
      0.0,
      (sum, addOn) => sum + addOn.addonsPrice,
    );

    // Calculate overall total price with add-ons
    final totalPrice = currentSizeOption.drinkPrice + addOnsTotalPrice;

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
                    // Drink Image
                    Container(
                      height: 250,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(getImageUrl(widget
                                  .drinkItem.drinkImages.isNotEmpty
                              ? widget.drinkItem.drinkImages[0].originalUrl
                              : null)), // Use fallback if no image available
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Category (Left Aligned)
                    Text(
                      widget.drinkItem.drinkCategory.categoryName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Drink Name (Left Aligned) with Dynamic Price
                    Text(
                      widget.drinkItem.drinkName,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 81, 132, 110),
                      ),
                    ),
                    SizedBox(height: 4),

                    // Display Drink Price
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: 'Drink Price: ',
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.grey[600],
                            ),
                          ),
                          TextSpan(
                            text:
                                '\$${currentSizeOption.drinkPrice.toStringAsFixed(2)}',
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
// Size Options (Aligned to the start, with rounded corners)

// Size Options (Aligned to the start, with rounded corners)
                    Wrap(
                      alignment: WrapAlignment.start,
                      spacing: 6.0,
                      children: widget.drinkItem.sizeOptions.map((sizeOption) {
                        final isSelected = selectedSize == sizeOption.drinkSize;
                        return FilterChip(
                          label: Text(
                            sizeOption.drinkSize,
                            style: TextStyle(
                              fontSize: 14,
                              color:
                                  isSelected ? Colors.white : Colors.grey[700],
                            ),
                          ),
                          selected: isSelected,
                          onSelected: (selected) {
                            ref
                                .read(selectedSizeProvider(widget.drinkItem)
                                    .notifier)
                                .state = sizeOption.drinkSize;
                          },
                          selectedColor: Color.fromARGB(255, 81, 132, 110),
                          backgroundColor: Color.fromARGB(255, 253, 228, 228),
                          checkmarkColor:
                              Colors.white, // Set checkmark color to white
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            side: BorderSide(
                              color: isSelected
                                  ? Color.fromARGB(255, 81, 132, 110)
                                  : Colors.grey,
                              width: 1.5,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 16),

                    // Add-ons Section (Collapsible in a Container)
                    if (widget.drinkItem.addOnsEnabled)
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
                                            widget.drinkItem)
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
                              // Drink Add-Ons (Aligned to the start, with rounded corners)
                              Wrap(
                                alignment: WrapAlignment.start,
                                spacing: 4.0,
                                children:
                                    widget.drinkItem.drinkAddOns.map((addOn) {
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
                                          List<DrinkAddOn>.from(selectedAddOns);
                                      if (selected) {
                                        updatedAddOns.add(addOn);
                                      } else {
                                        updatedAddOns.remove(addOn);
                                      }
                                      ref
                                          .read(selectedAddOnsProvider(
                                                  widget.drinkItem)
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

                    // Drink Description
                    Text(
                      widget.drinkItem.drinkDescription,
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
            height: 55,
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
                          // Handle Buy Now
                        },
                        child: Text(
                          'Buy Now',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 81, 132, 110),
                          minimumSize: Size(100, 40),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        ),
                      ),
                      SizedBox(width: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Handle Add to Cart
                        },
                        child: Text(
                          'Add to Cart',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 81, 132, 110),
                          minimumSize: Size(100, 40),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 6),
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
