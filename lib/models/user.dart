class User {
  final String fullName;
  final String email;
  final String phone;
  final String password;

  User({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
  });
}


class UserSession {
  
  static User? registeredUser;

  
  static User? loggedUser;
}


class AuthState {
  static bool isLoggedIn = false;
}
