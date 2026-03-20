import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const baseUrl = "http://192.168.1.141:4000"; // ganti dengan URL backend FastAPI kamu

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }


  static Future<void> login(String email, String password) async {
    final res = await http.post(
      Uri.parse("$baseUrl/login"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      await prefs.setInt('userId', data['userId']);
      await prefs.setString('name', data['name']);
    } else {
      throw Exception("Login gagal: ${res.body}");
    }
  }

  static Future<void> register(String email, String password, String name) async {
    final res = await http.post(
      Uri.parse("$baseUrl/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password, "name": name}),
    );

    if (res.statusCode == 200) {
      // Registrasi berhasil, bisa langsung login atau arahkan ke halaman login
    } else {
      throw Exception("Registrasi gagal: ${res.body}");
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
  }
}
