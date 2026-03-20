import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _keyUserId = "user_id";
  static const _keyUserName = "user_name";
  static const _keyIsLoggedIn = "is_logged_in";

  // =========================
  // SAVE LOGIN SESSION
  // =========================
  static Future<void> saveLogin({
    required int userId,
    required String name,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserName, name);
    await prefs.setBool(_keyIsLoggedIn, true);
  }

  // =========================
  // GETTERS
  // =========================
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  static Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserName);
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // =========================
  // LOGOUT
  // =========================
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
