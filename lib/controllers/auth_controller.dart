import '../models/user_model.dart';

class AuthController {
  // Stores registered users (simulates a database)
  static final List<UserModel> _registeredUsers = [];

  static void registerUser(UserModel user) {
    _registeredUsers.add(user);
  }

  static UserModel? loginUser(String email, String password) {
    try {
      return _registeredUsers.firstWhere(
            (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  static bool isEmailRegistered(String email) {
    return _registeredUsers.any((user) => user.email == email);
  }
}