import 'package:flutter/material.dart';
import '../../../models/foods/food_item_model.dart';

class FoodItemCard extends StatelessWidget {
  final FoodItem foodItem;

  const FoodItemCard({Key? key, required this.foodItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Helper to format image URL with base URL
    String getImageUrl(String? relativeUrl) {
      return relativeUrl != null && relativeUrl.isNotEmpty
          ? 'http://192.168.0.111:1337$relativeUrl'
          : 'https://via.placeholder.com/100'; // Fallback placeholder
    }

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
          // Food Image with Padding
          Padding(
            padding: const EdgeInsets.fromLTRB(
                16, 8, 16, 4), // Padding around the image
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(8.0), // Rounded corners for image
              child: Image.network(
                getImageUrl(foodItem.foodImages.isNotEmpty
                    ? foodItem.foodImages[0].originalUrl
                    : null), // Use fallback if no image available
                width:
                    double.infinity, // Make image full-width within the padding
                height: 103, // Set height to make it square
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Food Name and Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  foodItem.foodName,
                  maxLines: 1, // Restrict to 1 line
                  overflow:
                      TextOverflow.ellipsis, // Add ellipsis if text is too long
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  foodItem.foodDescription,
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
                  '\$${foodItem.foodPrice.toStringAsFixed(2)}', // Display the food price
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Spacer(),
                Icon(Icons.add_circle, color: Colors.white),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
