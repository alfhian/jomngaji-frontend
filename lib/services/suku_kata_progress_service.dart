import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class SukuKataProgressService {
  static const String baseUrl = 'http://10.71.164.20:4000';

  static Future<Map<String, dynamic>> getProgress() async {
    final headers = await AuthService.authHeaders();

    final response = await http.get(
      Uri.parse('$baseUrl/hijaiyah/suku-kata/progress'),
      headers: headers,
    );

    if (response.statusCode != 200) {
      throw Exception('Gagal mengambil progress suku kata');
    }

    return jsonDecode(response.body) as Map<String, dynamic>;
  }
}
