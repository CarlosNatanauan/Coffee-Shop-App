import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/drinks/item/drink_item_model.dart';
import '../models/foods/item/food_item_model.dart';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.111:1337/api';
  static const String uploadUrl = '$baseUrl/upload';
  static const String mediaFilesUrl = '$uploadUrl/files';
  final String authToken =
      '1579bfdf26486ff421c8fd36db259b0c9b0955aa9b736e557a0761202e1e3eaa1c9fe50d722f4108adc98f376b97f4468d7eda82613d626cef54445fdd43763ca2f2c43a126515cebea4c9981425aaf135d04b2da28dce17bdf89b9471488fc3d592bd4511c8ee276918b8a9117f268d36de75dc319966f52e153d4640fee65b';

  // ---------------------------
  // Media Management
  // ---------------------------

  Future<List<dynamic>> getMediaFiles() async {
    try {
      final response = await http.get(
        Uri.parse(mediaFilesUrl),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load media files');
      }
    } catch (e) {
      throw Exception('Error fetching media files: $e');
    }
  }

  Future<int?> uploadMediaFile(File file) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(uploadUrl),
    );
    request.headers['Authorization'] = 'Bearer $authToken';

    var stream = http.ByteStream(file.openRead().cast());
    var length = await file.length();
    var multipartFile = http.MultipartFile(
      'files',
      stream,
      length,
      filename: file.path.split('/').last,
      contentType:
          MediaType('image', 'jpeg'), // Adjust based on file type if needed
    );

    request.files.add(multipartFile);

    try {
      final response = await request.send();

      // Print the status code and headers for debugging
      print("Status code: ${response.statusCode}");
      response.headers.forEach((key, value) {
        print("Header $key: $value");
      });

      // Check for both 200 and 201 status codes as successful responses
      if (response.statusCode == 200 || response.statusCode == 201) {
        final responseData = await response.stream.bytesToString();
        final data = json.decode(responseData);
        return data[0]['id']; // Assuming data[0]['id'] is the file ID
      } else {
        print("Failed to upload image: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Image upload error: $e");
      return null;
    }
  }
  // ---------------------------
  // Drink Item Endpoints
  // ---------------------------

  // Create a new drink item
  Future<DrinkItem?> createDrinkItem(Map<String, dynamic> drinkData) async {
    print("Sending drink data to backend: ${json.encode({"data": drinkData})}");

    final response = await http.post(
      Uri.parse('$baseUrl/drink-items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({"data": drinkData}), // Wraps once in "data"
    );

    print("Create Response Status Code: ${response.statusCode}");
    print("Create Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print("Created drink item successfully on backend.");
      return DrinkItem.fromJson(data['data']);
    } else {
      print("Failed to create drink item. Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return null;
    }
  }

  // Fetch all drink items with populated fields
  Future<List<DrinkItem>> getAllDrinkItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/drink-items?populate=*&pagination[pageSize]=100'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    print("Fetch All Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all drink items successfully.");
      return (data['data'] as List<dynamic>)
          .map((item) => DrinkItem.fromJson(item))
          .toList();
    } else {
      print("Failed to load drink items. Status Code: ${response.statusCode}");
      throw Exception('Failed to load drink items');
    }
  }

  // Fetch an individual drink item by documentId with populated fields
  Future<DrinkItem?> getDrinkItemById(String documentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drink-items/$documentId?populate=*'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    print("Fetch Single Item Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched drink item with documentId: $documentId successfully.");
      return DrinkItem.fromJson(data['data']);
    } else {
      print("Failed to load drink item for document ID: $documentId");
      print("Response Body: ${response.body}");
      return null;
    }
  }

// Update a drink item by documentId
  Future<DrinkItem?> updateDrinkItem(
      String documentId, Map<String, dynamic> data) async {
    final payload = {"data": data}; // Wrap data in "data" key

    print("Updating drink item with data: ${json.encode(payload)}");

    final response = await http.put(
      Uri.parse('$baseUrl/drink-items/$documentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(payload),
    );

    print("Update Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final updatedData = json.decode(response.body);
      print("Updated drink item with documentId: $documentId successfully.");
      return DrinkItem.fromJson(updatedData['data']);
    } else {
      print("Failed to update drink item for document ID: $documentId");
      print("Response Body: ${response.body}");
      return null;
    }
  }

  // Delete a drink item by documentId
  Future<void> deleteDrinkItem(String documentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/drink-items/$documentId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted drink item with documentId: $documentId successfully.");
    } else {
      throw Exception(
          'Failed to delete drink item for document ID: $documentId');
    }
  }

  // ---------------------------
  // Add-Ons Endpoints (Drinks)
  // ---------------------------

  // Fetch all add-ons
  Future<List<dynamic>> getAddOnsDrinks() async {
    final response = await http.get(Uri.parse('$baseUrl/drink-add-ons'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all add-ons successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load add-ons');
    }
  }

  // Fetch an individual add-on by documentId
  Future<Map<String, dynamic>> getAddOnByIdDrinks(String documentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/drink-add-ons/$documentId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched add-on with documentId: $documentId successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load add-on for document ID: $documentId');
    }
  }

  // Add a new add-on
  Future<dynamic> addAddOnDrinks(String name, double price) async {
    final response = await http.post(
      Uri.parse('$baseUrl/drink-add-ons'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'data': {
          'addons_name': name,
          'addons_price': price,
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Added new add-on: $name with price $price.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create add-on');
    }
  }

  // Update an add-on by documentId
  Future<Map<String, dynamic>> updateAddOnDrinks(
      String documentId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/drink-add-ons/$documentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Updated add-on with documentId: $documentId.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update add-on for document ID: $documentId');
    }
  }

  // Delete an add-on by documentId
  Future<void> deleteAddOnDrinks(String documentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/drink-add-ons/$documentId'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted add-on with documentId: $documentId.");
    } else {
      throw Exception('Failed to delete add-on for document ID: $documentId');
    }
  }
  // ---------------------------
  // Category Endpoints
  // ---------------------------

  // Fetch all categories
  Future<List<dynamic>> getCategoriesDrinks() async {
    final response = await http.get(Uri.parse('$baseUrl/drink-categories'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all categories successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch an individual category by documentId
  Future<Map<String, dynamic>> getCategoryByIdDrinks(String documentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/drink-categories/$documentId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched category with documentId: $documentId successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load category for document ID: $documentId');
    }
  }

  // Add a new category
  Future<dynamic> addCategoryDrinks(String categoryName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/drink-categories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'data': {
          'category_name': categoryName,
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Added new category: $categoryName.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create category');
    }
  }

  // Update a category by documentId
  Future<Map<String, dynamic>> updateCategoryDrinks(
      String documentId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/drink-categories/$documentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Updated category with documentId: $documentId.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update category for document ID: $documentId');
    }
  }

  // Delete a category by documentId
  Future<void> deleteCategoryDrinks(String documentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/drink-categories/$documentId'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted category with documentId: $documentId.");
    } else {
      throw Exception('Failed to delete category for document ID: $documentId');
    }
  }

// -------------- Food methods starts here --------------

// ---------------------------
// Food Item Endpoints
// ---------------------------

// Create a new food item
  Future<FoodItem?> createFoodItem(Map<String, dynamic> foodData) async {
    print("Sending food data to backend: ${json.encode({"data": foodData})}");

    final response = await http.post(
      Uri.parse('$baseUrl/food-items'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode({"data": foodData}), // Wraps once in "data"
    );

    print("Create Response Status Code: ${response.statusCode}");
    print("Create Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      print("Created food item successfully on backend.");
      return FoodItem.fromJson(data['data']);
    } else {
      print("Failed to create food item. Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return null;
    }
  }

// Fetch all food items with populated fields
  Future<List<FoodItem>> getAllFoodItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/food-items?populate=*&pagination[pageSize]=100'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    print("Fetch All Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all food items successfully.");
      return (data['data'] as List<dynamic>)
          .map((item) => FoodItem.fromJson(item))
          .toList();
    } else {
      print("Failed to load food items. Status Code: ${response.statusCode}");
      throw Exception('Failed to load food items');
    }
  }

// Fetch an individual food item by documentId with populated fields
  Future<FoodItem?> getFoodItemById(String documentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/food-items/$documentId?populate=*'),
      headers: {
        'Authorization': 'Bearer $authToken',
      },
    );

    print("Fetch Single Item Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched food item with documentId: $documentId successfully.");
      return FoodItem.fromJson(data['data']);
    } else {
      print("Failed to load food item for document ID: $documentId");
      print("Response Body: ${response.body}");
      return null;
    }
  }

// Update a food item by documentId
  Future<FoodItem?> updateFoodItem(
      String documentId, Map<String, dynamic> data) async {
    final payload = {"data": data}; // Wrap data in "data" key

    print("Updating food item with data: ${json.encode(payload)}");

    final response = await http.put(
      Uri.parse('$baseUrl/food-items/$documentId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $authToken',
      },
      body: json.encode(payload),
    );

    print("Update Response Status Code: ${response.statusCode}");

    if (response.statusCode == 200) {
      final updatedData = json.decode(response.body);
      print("Updated food item with documentId: $documentId successfully.");
      return FoodItem.fromJson(updatedData['data']);
    } else {
      print("Failed to update food item for document ID: $documentId");
      print("Response Body: ${response.body}");
      return null;
    }
  }

// Delete a food item by documentId
  Future<void> deleteFoodItem(String documentId) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/food-items/$documentId'),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted food item with documentId: $documentId successfully.");
    } else {
      throw Exception(
          'Failed to delete food item for document ID: $documentId');
    }
  }

// ---------------------------
// Add-Ons Endpoints (Foods)
// ---------------------------

// Fetch all add-ons
  Future<List<dynamic>> getAddOnsFoods() async {
    final response = await http.get(Uri.parse('$baseUrl/food-add-ons'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all add-ons successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load add-ons');
    }
  }

  // Fetch an individual add-on by documentId
  Future<Map<String, dynamic>> getAddOnByIdFoods(String documentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/food-add-ons/$documentId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched add-on with documentId: $documentId successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load add-on for document ID: $documentId');
    }
  }

  // Add a new add-on
  Future<dynamic> addAddOnFoods(String name, double price) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-add-ons'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'data': {
          'addons_name': name,
          'addons_price': price,
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Added new add-on: $name with price $price.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create add-on');
    }
  }

  // Update an add-on by documentId
  Future<Map<String, dynamic>> updateAddOnFoods(
      String documentId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/food-add-ons/$documentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Updated add-on with documentId: $documentId.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update add-on for document ID: $documentId');
    }
  }

  // Delete an add-on by documentId
  Future<void> deleteAddOnFoods(String documentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/food-add-ons/$documentId'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted add-on with documentId: $documentId.");
    } else {
      throw Exception('Failed to delete add-on for document ID: $documentId');
    }
  }

  // ---------------------------
  // Category Endpoints (Foods)
  // ---------------------------

  // Fetch all categories
  Future<List<dynamic>> getCategoriesFoods() async {
    final response = await http.get(Uri.parse('$baseUrl/food-categories'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched all categories successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load categories');
    }
  }

  // Fetch an individual category by documentId
  Future<Map<String, dynamic>> getCategoryByIdFoods(String documentId) async {
    final response =
        await http.get(Uri.parse('$baseUrl/food-categories/$documentId'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print("Fetched category with documentId: $documentId successfully.");
      return data['data'];
    } else {
      throw Exception('Failed to load category for document ID: $documentId');
    }
  }

  // Add a new category
  Future<dynamic> addCategoryFoods(String categoryName) async {
    final response = await http.post(
      Uri.parse('$baseUrl/food-categories'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'data': {
          'category_name': categoryName,
        },
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Added new category: $categoryName.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to create category');
    }
  }

  // Update a category by documentId
  Future<Map<String, dynamic>> updateCategoryFoods(
      String documentId, Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('$baseUrl/food-categories/$documentId'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      print("Updated category with documentId: $documentId.");
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update category for document ID: $documentId');
    }
  }

  // Delete a category by documentId
  Future<void> deleteCategoryFoods(String documentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/food-categories/$documentId'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted category with documentId: $documentId.");
    } else {
      throw Exception('Failed to delete category for document ID: $documentId');
    }
  }
}
