import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/drinks/drink_item_model.dart';

class ApiService {
  static const String baseUrl = 'http://192.168.0.111:1337/api';

  // Fetch all drink items with populated fields
  Future<List<DrinkItem>> getAllDrinkItems() async {
    final response = await http.get(
      Uri.parse('$baseUrl/drink-items?populate=*'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      print(
          "API response for drink items: $data"); // Log full response for debugging
      return (data['data'] as List<dynamic>)
          .map((item) => DrinkItem.fromJson(item))
          .toList();
    } else {
      print("Failed to load drink items with status: ${response.statusCode}");
      throw Exception('Failed to load drink items');
    }
  }

  // Fetch an individual drink item by documentId with populated fields
  Future<DrinkItem?> getDrinkItemById(String documentId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/drink-items/$documentId?populate=*'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return DrinkItem.fromJson(data['data']);
    } else {
      throw Exception('Failed to load drink item');
    }
  }

  // Fetch all drink categories
  Future<List<dynamic>> getDrinkCategories() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/drink-categories'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched all drink categories successfully.");
        return data['data']; // Assuming categories are under 'data'
      } else {
        throw Exception('Failed to load drink categories');
      }
    } catch (e) {
      throw Exception('Error fetching drink categories: $e');
    }
  }

  // Fetch all drink add-ons
  Future<List<dynamic>> getDrinkAddOns() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/drink-add-ons'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("Fetched all drink add-ons successfully.");
        return data['data']; // Assuming add-ons are under 'data'
      } else {
        throw Exception('Failed to load drink add-ons');
      }
    } catch (e) {
      throw Exception('Error fetching drink add-ons: $e');
    }
  }
}
