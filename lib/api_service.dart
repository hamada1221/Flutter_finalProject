import 'dart:convert';
import 'package:http/http.dart' as http;
import 'constants.dart';
import 'user_model.dart';

class ApiService {
  Future<Map<String, dynamic>> registerUser(UserModel user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Accept': 'application/json'},
      body: user.toJson(),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to register: ${response.body}');
  }

  Future<Map<String, dynamic>> loginUser(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password},
    );
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }
    throw Exception('Failed to login: ${response.body}');
  }

  Future<void> logoutUser(String token) async {
    final response = await http.get(
      Uri.parse('$baseUrl/logout'),
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to logout: ${response.body}');
    }
  }
}