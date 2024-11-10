import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_token_model.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.111:1337/api';

  // Register a new user
  Future<bool> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return true; // Registration successful
    } else {
      print('Error during registration: ${response.body}');
      return false; // Registration failed
    }
  }

  // Log in the user and return the AuthToken object
  Future<AuthToken?> login(String identifier, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/auth/local'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'identifier': identifier,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      // Parse JWT token and user information
      AuthToken authToken = AuthToken.fromJson(data);
      // Store the token in shared preferences
      await _storeToken(authToken);
      return authToken;
    } else {
      print('Error during login: ${response.body}');
      return null; // Login failed
    }
  }

  // Store the AuthToken in SharedPreferences
  Future<void> _storeToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('token', authToken.token);
    prefs.setString(
        'user', jsonEncode(authToken.user.toJson())); // Store user info
  }

  // Get the AuthToken from SharedPreferences
  Future<AuthToken?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userJson = prefs.getString('user');

    if (token != null && userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      return AuthToken(token: token, user: user);
    }
    return null; // No stored token
  }

  // Logout by clearing stored token and user info
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('user');
  }

  // Check if the user is logged in by validating the token
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    return token != null; // If a token exists, user is logged in
  }

  // Send token in headers for authenticated requests
  Future<Map<String, String>> getAuthHeaders() async {
    final authToken = await getStoredToken();
    if (authToken != null) {
      return {
        'Authorization': 'Bearer ${authToken.token}',
        'Content-Type': 'application/json',
      };
    } else {
      return {
        'Content-Type': 'application/json'
      }; // No auth headers if not logged in
    }
  }

  // Example of making an authenticated API request
  Future<void> fetchUserData() async {
    final headers = await getAuthHeaders();
    final response = await http.get(
      Uri.parse('$baseUrl/users/me'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      print('User data: ${response.body}');
    } else {
      print('Failed to fetch user data');
    }
  }
}
