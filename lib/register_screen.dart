import 'dart:convert'; // Added for jsonDecode
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'user_model.dart';
import 'auth_service.dart';
import 'validator.dart';
import 'custom_text_field.dart';
import 'custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? _dateOfBirth;
  String? _gender;
  XFile? _profileImage;
  final AuthService _authService = AuthService();
  String? _errorMessage;

  Future<void> _pickImage() async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _profileImage = pickedFile;
          _errorMessage = null; // Clear any previous error
        });
      } else {
        setState(() {
          _errorMessage = 'No image selected.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to pick image: $e';
      });
    }
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _dateOfBirth = DateFormat('yyyy-MM-dd').format(date));
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _errorMessage = null); // Clear previous error
      try {
        final user = UserModel(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phone: _phoneController.text,
          address: _addressController.text,
          password: _passwordController.text,
          profileImagePath: _profileImage?.path,
          dateOfBirth: _dateOfBirth,
          gender: _gender,
        );
        print('Registering user: ${user.firstName}, ${user.email}'); // Debug
        await _authService.register(user);
        if (!mounted) return;
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        // Parse the API response for a specific error message
        if (e.toString().contains('Failed to register')) {
          final errorResponse =
              e.toString().replaceFirst('Exception: Failed to register: ', '');
          final errorMap = Map<String, dynamic>.from(jsonDecode(errorResponse));
          setState(() {
            _errorMessage =
                errorMap['data'] ?? errorMap['message'] ?? e.toString();
          });
        } else {
          setState(() => _errorMessage = e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
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
                        'Create Account',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF455A64),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join us to start shopping',
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF455A64).withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomTextField(
                        label: 'First Name',
                        controller: _firstNameController,
                        validator: Validator.validateName,
                      ),
                      CustomTextField(
                        label: 'Last Name',
                        controller: _lastNameController,
                        validator: Validator.validateName,
                      ),
                      CustomTextField(
                        label: 'Email',
                        controller: _emailController,
                        validator: Validator.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        validator: Validator.validatePhone,
                        keyboardType: TextInputType.phone,
                      ),
                      CustomTextField(
                        label: 'Address',
                        controller: _addressController,
                        validator: Validator.validateAddress,
                        maxLines: 3,
                      ),
                      CustomTextField(
                        label: 'Password',
                        controller: _passwordController,
                        validator: Validator.validatePassword,
                        obscureText: true,
                      ),
                      CustomTextField(
                        label: 'Confirm Password',
                        controller: _confirmPasswordController,
                        validator: (value) => Validator.validateConfirmPassword(
                            _passwordController.text, value),
                        obscureText: true,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          _dateOfBirth ?? 'Select Date of Birth',
                          style: TextStyle(color: const Color(0xFF455A64)),
                        ),
                        trailing: const Icon(Icons.calendar_today,
                            color: Color(0xFF455A64)),
                        onTap: _pickDate,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          labelText: 'Gender',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        value: _gender,
                        items: ['Male', 'Female', 'Other']
                            .map((gender) => DropdownMenuItem(
                                value: gender, child: Text(gender)))
                            .toList(),
                        onChanged: (value) => setState(() => _gender = value),
                        validator: Validator.validateGender,
                      ),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: Text(
                          'Pick Profile Image',
                          style: TextStyle(color: const Color(0xFF455A64)),
                        ),
                        trailing: _profileImage == null
                            ? const Icon(Icons.image, color: Color(0xFF455A64))
                            : (kIsWeb
                                ? FutureBuilder<Uint8List>(
                                    future: _profileImage!.readAsBytes(),
                                    builder: (context, snapshot) {
                                      if (snapshot.hasData) {
                                        return ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.memory(
                                            snapshot.data!,
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    const Icon(Icons.error),
                                          ),
                                        );
                                      }
                                      return const CircularProgressIndicator();
                                    },
                                  )
                                : const Icon(Icons.image,
                                    color: Color(0xFF455A64))),
                        onTap: _pickImage,
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
                      CustomButton(text: 'Register', onPressed: _register),
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
