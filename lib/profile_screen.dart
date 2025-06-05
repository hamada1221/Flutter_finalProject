import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'auth_service.dart';
import 'shared_prefs.dart';
import 'custom_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userEmail;
  String? userFirstName;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final email = await SharedPrefs.getUserEmail();
    final firstName = await SharedPrefs.getFirstName();
    setState(() {
      userEmail = email;
      userFirstName = firstName ?? 'User';
    });
  }

  Future<void> _logout() async {
    await AuthService().logout();
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FadeInUp(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                ClipOval(
                  child: Container(
                    width: 120,
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person,
                        size: 80, color: Color(0xFF455A64)),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  userFirstName ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF455A64),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  userEmail ?? 'Loading...',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF455A64),
                  ),
                ),
                const Spacer(),
                CustomButton(text: 'Logout', onPressed: _logout),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
