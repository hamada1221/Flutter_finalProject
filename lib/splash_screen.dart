import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final authService = AuthService();
    final isLoggedIn = await authService.isLoggedIn();
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, isLoggedIn ? '/home' : '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeIn(
          duration: const Duration(milliseconds: 1000),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag,
                  size: 100, color: Color.fromARGB(255, 60, 185, 243)),
              const SizedBox(height: 16),
              Text(
                'E-Commerce App',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF455A64),
                ),
              ),
              const SizedBox(height: 16),
              const CircularProgressIndicator(color: Color(0xFF455A64)),
            ],
          ),
        ),
      ),
    );
  }
}
