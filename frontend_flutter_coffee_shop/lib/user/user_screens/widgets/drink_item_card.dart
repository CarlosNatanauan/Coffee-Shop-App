// drink_item_card.dart
import 'package:flutter/material.dart';
import '../../models/drinks/drink_item_model.dart';

class DrinkItemCard extends StatelessWidget {
  final DrinkItem drinkItem;

  const DrinkItemCard({Key? key, required this.drinkItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper to format image URL with base URL
    String getImageUrl(String? relativeUrl) {
      return relativeUrl != null && relativeUrl.isNotEmpty
          ? 'http://192.168.0.111:1337$relativeUrl'
          : 'https://via.placeholder.com/100'; // Fallback placeholder
    }

    // Get the first available size price
    final firstSizePrice = drinkItem.sizeOptions.isNotEmpty
        ? drinkItem.sizeOptions.first.drinkPrice
        : 0.0;

    return Card(
      color: Color.fromARGB(255, 255, 247, 247),
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: EdgeInsets.symmetric(horizontal: 4.0, vertical: 9.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drink Image with Padding
          Padding(
            padding: const EdgeInsets.fromLTRB(
                14, 8, 14, 4), // Padding around the image
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.0), // Rounded corners for image
              child: Image.network(
                getImageUrl(drinkItem.drinkImages.isNotEmpty
                    ? drinkItem.drinkImages[0].originalUrl
                    : null), // Use fallback if no image available
                width:
                    double.infinity, // Make image full-width within the padding
                height: 103, // Set height to make it square
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Drink Name and Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drinkItem.drinkName,
                  maxLines: 1, // Restrict to 1 line
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text is too long
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  drinkItem.drinkDescription,
                  maxLines: 1, // Restrict to 1 line
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text is too long
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors
                        .grey[600], // Smaller and lighter color for description
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          // Bottom Row with Price and Plus Icon in a Container
          Container(
            width: double.infinity, // Make the container full-width
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 81, 132, 110),
              borderRadius:
                  BorderRadius.vertical(bottom: Radius.circular(10.0)),
            ),
            padding: EdgeInsets.fromLTRB(8, 5, 8, 7),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${firstSizePrice.toStringAsFixed(2)}', // Display only the price of the first available size
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Icon(Icons.add_box_rounded, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
