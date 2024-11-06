import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static const String baseUrl = 'http://192.168.0.111:1337/api';

  // ---------------------------
  // Add-Ons Endpoints
  // ---------------------------

  // Fetch all add-ons
  Future<List<dynamic>> getAddOns() async {
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
  Future<Map<String, dynamic>> getAddOnById(String documentId) async {
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
  Future<dynamic> addAddOn(String name, int price) async {
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
  Future<Map<String, dynamic>> updateAddOn(
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
  Future<void> deleteAddOn(String documentId) async {
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
  Future<List<dynamic>> getCategories() async {
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
  Future<Map<String, dynamic>> getCategoryById(String documentId) async {
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
  Future<dynamic> addCategory(String categoryName) async {
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
  Future<Map<String, dynamic>> updateCategory(
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
  Future<void> deleteCategory(String documentId) async {
    final response =
        await http.delete(Uri.parse('$baseUrl/drink-categories/$documentId'));

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Deleted category with documentId: $documentId.");
    } else {
      throw Exception('Failed to delete category for document ID: $documentId');
    }
  }
}
