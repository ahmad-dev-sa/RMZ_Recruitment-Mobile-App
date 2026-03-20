// Login Request
class LoginRequest {
  final String idNumber;
  final String password;

  LoginRequest({
    required this.idNumber,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': idNumber, // Backend expects username
      'password': password,
    };
  }
}

// Register Request
class RegisterRequest {
  final String idNumber;
  final String firstName;
  final String lastName;
  final String phoneNumber;
  final String email;
  final String password;
  final String confirmPassword;

  RegisterRequest({
    required this.idNumber,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_number': idNumber,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'email': email,
      'password': password,
      'confirm_password': confirmPassword,
    };
  }
}
