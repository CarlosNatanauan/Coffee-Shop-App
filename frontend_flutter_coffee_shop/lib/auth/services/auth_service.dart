import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';
import '../models/auth_token_model.dart';

class AuthService {
  static const String baseUrl = 'http://192.168.0.111:1337/api';

  // Register a new user
  Future<bool> register(String username, String email, String password) async {
    print(
        'Attempting to register user: $username, $email'); // Log registration attempt
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
      print(
          'Registration successful for $username'); // Log successful registration
      return true; // Registration successful
    } else {
      print(
          'Error during registration: ${response.body}'); // Log registration error
      return false; // Registration failed
    }
  }

  // Log in the user and return the AuthToken object
  Future<AuthToken?> login(String identifier, String password) async {
    print(
        'Attempting to log in with identifier: $identifier'); // Log login attempt
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
      AuthToken authToken = AuthToken.fromJson(data);
      await _storeToken(authToken);
      print(
          'Login successful for ${authToken.user.username}'); // Log successful login
      return authToken;
    } else {
      // Extract specific error message and pass it back as a string
      var errorData = jsonDecode(response.body);
      print(
          'Error during login: ${errorData["error"]["message"]}'); // Log login error
      return Future.error(errorData["error"]["message"]);
    }
  }

  // Store the AuthToken in SharedPreferences
  Future<void> _storeToken(AuthToken authToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', authToken.token);
    await prefs.setString(
        'user', jsonEncode(authToken.user.toJson())); // Store user info
    print(
        'Token and user info stored in SharedPreferences'); // Log token storage
  }

  // Get the AuthToken from SharedPreferences
  Future<AuthToken?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    String? userJson = prefs.getString('user');

    if (token != null && userJson != null) {
      User user = User.fromJson(jsonDecode(userJson));
      print(
          'AuthToken and user info retrieved from SharedPreferences'); // Log token retrieval
      return AuthToken(token: token, user: user);
    }
    print('No stored token or user info found'); // Log no token found
    return null; // No stored token
  }

  // Logout by clearing stored token and user info
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    print(
        'User has been logged out and token/user info cleared from SharedPreferences'); // Log logout
  }

  // Check if the user is logged in by validating the token
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) {
      print('User is logged in. Token exists: $token'); // Log token existence
      return true; // If a token exists, user is logged in
    } else {
      print('No token found. User is not logged in'); // Log no token
      return false;
    }
  }

  // Send token in headers for authenticated requests
  Future<Map<String, String>> getAuthHeaders() async {
    final authToken = await getStoredToken();
    if (authToken != null) {
      print(
          'Adding Authorization header for authenticated request'); // Log adding auth header
      return {
        'Authorization': 'Bearer ${authToken.token}',
        'Content-Type': 'application/json',
      };
    } else {
      print(
          'No auth token found. Sending request without auth header'); // Log no auth token
      return {
        'Content-Type': 'application/json',
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
      print(
          'User data fetched successfully: ${response.body}'); // Log successful data fetch
    } else {
      print(
          'Failed to fetch user data. Status code: ${response.statusCode}'); // Log failure
    }
  }
}
