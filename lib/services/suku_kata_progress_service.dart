import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class SukuKataProgressService {
  static const String baseUrl = "http://192.168.1.141:4000";

  static Future<Map<String, dynamic>> getProgress() async {
    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception("User belum login");
    }

    final response = await http.get(
      Uri.parse("$baseUrl/hijaiyah/suku-kata/progress?user_id=$userId"),
    );

    if (response.statusCode != 200) {
      throw Exception("Gagal mengambil progress suku kata");
    }

    return jsonDecode(response.body);
  }
}
