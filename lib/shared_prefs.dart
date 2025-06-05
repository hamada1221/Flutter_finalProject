import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _keyUser = 'user';
  static const String _keyToken = 'token';
  static const String _keyRememberMe = 'remember_me';
  static const String _keyCart = 'cart';
  static const String _keyOrders = 'orders';
  static const String _keyFirstName = 'first_name';

  static Future<void> saveUser(
      String email, String token, String firstName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUser, email);
    await prefs.setString(_keyToken, token);
    await prefs.setString(_keyFirstName, firstName);
    print('Saved to SharedPrefs: email=$email, firstName=$firstName'); // Debug
  }

  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUser);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyToken);
  }

  static Future<String?> getFirstName() async {
    final prefs = await SharedPreferences.getInstance();
    final firstName = prefs.getString(_keyFirstName);
    print('Retrieved firstName from SharedPrefs: $firstName'); // Debug
    return firstName;
  }

  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  static Future<void> saveCart(List<Map<String, dynamic>> cart) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyCart, jsonEncode(cart));
  }

  static Future<List<Map<String, dynamic>>> getCart() async {
    final prefs = await SharedPreferences.getInstance();
    final cartJson = prefs.getString(_keyCart);
    if (cartJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(cartJson));
    }
    return [];
  }

  static Future<void> saveOrders(List<Map<String, dynamic>> orders) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyOrders, jsonEncode(orders));
  }

  static Future<List<Map<String, dynamic>>> getOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString(_keyOrders);
    if (ordersJson != null) {
      return List<Map<String, dynamic>>.from(jsonDecode(ordersJson));
    }
    return [];
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
