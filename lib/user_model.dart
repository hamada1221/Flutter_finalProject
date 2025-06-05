class UserModel {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String password;
  final String? profileImagePath;
  final String? dateOfBirth;
  final String? gender;
  final String? token;

  UserModel({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.password,
    this.profileImagePath,
    this.dateOfBirth,
    this.gender,
    this.token,
  });

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': email,
        'phone': phone,
        'address': address,
        'password': password,
        if (profileImagePath != null)
          'profile_image': profileImagePath, // Include path if available
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        firstName: json['first_name'] ?? '',
        lastName: json['last_name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        password: '',
        profileImagePath: json['profile_image'],
        token: json['token'],
      );
}
