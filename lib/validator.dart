class Validator {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) return 'Name is required';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) return 'Phone number is required';
    if (!RegExp(r'^\d{10,}$').hasMatch(value)) return 'Enter a valid phone number';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Confirm password is required';
    }
    if (password != confirmPassword) return 'Passwords do not match';
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.isEmpty) return 'Address is required';
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) return 'Date of birth is required';
    return null;
  }

  static String? validateGender(String? value) {
    if (value == null || value.isEmpty) return 'Gender is required';
    return null;
  }
}