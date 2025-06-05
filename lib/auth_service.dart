import 'dart:convert';
import 'user_model.dart';
import 'api_service.dart';
import 'shared_prefs.dart';

class AuthService {
  final ApiService _apiService = ApiService();

  Future<void> register(UserModel user) async {
    try {
      final response = await _apiService.registerUser(user);
      print('Register API response: $response'); // Debug
      final token = response['token'] as String?;
      final firstName = response['first_name'] as String? ??
          user.firstName; // Use user input if API doesn't return
      if (token != null) {
        await SharedPrefs.saveUser(user.email, token, firstName);
      } else {
        // Fallback: Save with empty token and user-provided first name
        await SharedPrefs.saveUser(user.email, '', firstName);
        throw Exception(
            'Registration failed: No token received from server. Please try again or contact support.');
      }
    } catch (e) {
      print('Registration error: $e'); // Debug
      rethrow;
    }
  }

  Future<void> login(String email, String password, bool rememberMe) async {
    try {
      final response = await _apiService.loginUser(email, password);
      print('Login API response: $response'); // Debug
      final token = response['token'] as String?;
      final firstName = response['first_name'] as String? ??
          (await SharedPrefs.getFirstName() ?? 'User');
      final state = response['state'] as bool? ?? false;
      final message = response['message'] as String? ?? 'Unknown error';

      if (state || message.toLowerCase().contains('success')) {
        // Treat as successful login, even if token is missing
        await SharedPrefs.saveUser(email, token ?? '', firstName);
        await SharedPrefs.setRememberMe(rememberMe);
      } else {
        throw Exception('Login failed: $message');
      }
    } catch (e) {
      print('Login error: $e'); // Debug
      rethrow;
    }
  }

  Future<void> logout() async {
    final token = await SharedPrefs.getToken();
    if (token != null) {
      await _apiService.logoutUser(token);
      await SharedPrefs.clear();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await SharedPrefs.getToken();
    final rememberMe = await SharedPrefs.getRememberMe();
    return token != null && rememberMe;
  }
}
