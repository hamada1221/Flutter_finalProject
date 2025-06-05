import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'splash_screen.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'category_screen.dart';
import 'product_details.dart';
import 'cart_screen.dart';
import 'orders_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Commerce App',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF7F7F7), // Background color
        primaryColor: const Color(0xFF455A64), // Navbar/button color
        textTheme: GoogleFonts.poppinsTextTheme().apply(
          bodyColor: const Color(0xFF455A64), // Body text color
          displayColor: const Color(0xFF455A64),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF455A64),
          foregroundColor: Color(0xFFFFFFFF), // White text/icons
          elevation: 2,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF455A64),
            foregroundColor: const Color(0xFFFFFFFF), // White text
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            padding: const EdgeInsets.symmetric(vertical: 16),
            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF455A64),
          selectedItemColor: Color(0xFFFFFFFF),
          unselectedItemColor: Color(0xFFB0BEC5),
        ),
      ),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/category': (context) => const CategoryScreen(),
        '/product': (context) => const ProductDetailsScreen(),
        '/cart': (context) => const CartScreen(),
        '/orders': (context) => const OrdersScreen(),
      },
    );
  }
}
