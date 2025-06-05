import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'auth_service.dart';
import 'validator.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  final AuthService _authService = AuthService();
  String? _errorMessage;

  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _errorMessage = null); // Clear previous error
      try {
        await _authService.login(
          _emailController.text,
          _passwordController.text,
          _rememberMe,
        );
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        setState(
            () => _errorMessage = e.toString().replaceFirst('Exception: ', ''));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
        backgroundColor: const Color(0xFF455A64),
        foregroundColor: const Color(0xFFFFFFFF),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: FadeInUp(
            duration: const Duration(milliseconds: 500),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome Back',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF455A64),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue shopping',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF455A64).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                        validator: Validator.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        validator: Validator.validatePassword,
                        obscureText: true,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) =>
                                    setState(() => _rememberMe = value!),
                                activeColor: const Color(0xFF455A64),
                              ),
                              const Text(
                                'Remember Me',
                                style: TextStyle(color: Color(0xFF455A64)),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Add forgot password functionality if needed
                            },
                            child: const Text(
                              'Forgot Password?',
                              style: TextStyle(color: Color(0xFF455A64)),
                            ),
                          ),
                        ],
                      ),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      const SizedBox(height: 16),
                      CustomButton(text: 'Login', onPressed: _login),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Don't have an account? ",
                            style: TextStyle(color: Color(0xFF455A64)),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pushNamed(context, '/register'),
                            child: const Text(
                              'Register',
                              style: TextStyle(color: Color(0xFF455A64)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
