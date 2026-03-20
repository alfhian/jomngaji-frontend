import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../../features/auth/services/auth_service.dart';

class EvaluationApi {
  final String baseUrl;
  final http.Client _client;

  EvaluationApi(this.baseUrl, {http.Client? client})
      : _client = client ?? http.Client();

  // ======================================================
  // INTERNAL HELPER
  // ======================================================
  Exception _error(int status, String body) {
    return Exception("[$status] $body");
  }

  Map<String, dynamic> _decode(String body) {
    return jsonDecode(body) as Map<String, dynamic>;
  }

  // ======================================================
  // 🔥 HIJAIYAH / GENERAL AUDIO EVALUATION
  // ======================================================
  Future<Map<String, dynamic>> evaluateAudio({
    required String audioPath,
    required String targetText,
    required int lessonId, // 🔥 PENTING untuk unlock
  }) async {
    final uri = Uri.parse("$baseUrl/evaluate");

    final userId = await AuthService.getUserId();
    if (userId == null) {
      throw Exception("User belum login");
    }

    final request = http.MultipartRequest("POST", uri);

    // ===== FORM DATA (WAJIB)
    request.fields.addAll({
      "user_id": userId.toString(),
      "target": targetText,
      "lesson_id": lessonId.toString(),
    });

    // ===== AUDIO FILE
    request.files.add(
      await http.MultipartFile.fromPath(
        "audio",
        audioPath,
        contentType: MediaType("audio", "wav"),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw _error(response.statusCode, response.body);
    }

    return _decode(response.body);
  }

  // ======================================================
  // TADARUS AUDIO → TEXT (ASR BASED)
  // ======================================================
  Future<Map<String, dynamic>> evaluateTadarus({
    required String audioPath,
    required String targetText,
    String? surah,
    int? ayah,
  }) async {
    final uri = Uri.parse("$baseUrl/evaluate/tadarus");

    final request = http.MultipartRequest("POST", uri)
      ..fields["target"] = targetText;

    if (surah != null) request.fields["surah"] = surah;
    if (ayah != null) request.fields["ayah"] = ayah.toString();

    request.files.add(
      await http.MultipartFile.fromPath(
        "audio",
        audioPath,
        contentType: MediaType("audio", "wav"),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw _error(response.statusCode, response.body);
    }

    return _decode(response.body);
  }

  // ======================================================
  // 🔥 TADARUS AUDIO → AUDIO (FINAL / PRODUCTION)
  // ======================================================
  Future<Map<String, dynamic>> evaluateTadarusAudio({
    required int userId,
    required String surah,
    required int ayah,
    required int totalAyah,
    required String userAudioPath,
    required String referenceAudioPath,
  }) async {
    final uri = Uri.parse("$baseUrl/evaluate/tadarus/audio");

    final request = http.MultipartRequest("POST", uri);

    request.fields.addAll({
      "user_id": userId.toString(),
      "surah": surah,
      "ayah": ayah.toString(),
      "total_ayah": totalAyah.toString(),
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        "user_audio",
        userAudioPath,
        contentType: MediaType("audio", "aac"),
      ),
    );

    request.files.add(
      await http.MultipartFile.fromPath(
        "reference_audio",
        referenceAudioPath,
        contentType: MediaType("audio", "mp3"),
      ),
    );

    final streamed = await request.send();
    final response = await http.Response.fromStream(streamed);

    if (response.statusCode != 200) {
      throw _error(response.statusCode, response.body);
    }

    return _decode(response.body);
  }

  // ======================================================
  // CLEANUP
  // ======================================================
  void dispose() {
    _client.close();
  }
}
