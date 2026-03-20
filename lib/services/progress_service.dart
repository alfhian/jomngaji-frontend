import 'package:shared_preferences/shared_preferences.dart';

class ProgressService {
  // -----------------------------
  // KONSTAN
  // -----------------------------
  static const int maxLessons = 14;
  static const int passingScore = 50;

  // -----------------------------
  // SCORE / XP (existing)
  // -----------------------------
  static Future<void> saveExamScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("exam_score", score);
  }

  static Future<int> getExamScore() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("exam_score") ?? 0;
  }

  static Future<void> saveXP(int xp) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("xp", xp);
  }

  static Future<int> getXP() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("xp") ?? 0;
  }

  // -----------------------------
  // SISTEM LEVEL (PER PELAJARAN)
  // -----------------------------
  static String _lessonScoreKey(int lessonId) => "lesson_${lessonId}_score";
  static String _lessonUnlockedKey(int lessonId) => "lesson_${lessonId}_unlocked";

  /// Lesson 1 ALWAYS unlocked
  static Future<bool> isLessonUnlocked(int lessonId) async {
    if (lessonId == 1) return true;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_lessonUnlockedKey(lessonId)) ?? false;
  }

  static Future<double> getLessonScore(int lessonId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_lessonScoreKey(lessonId)) ?? 0.0;
  }

  static Future<void> saveLessonScore(int lessonId, double score) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_lessonScoreKey(lessonId), score);

    // Auto unlock next lesson
    if (score >= passingScore && lessonId < maxLessons) {
      await prefs.setBool(_lessonUnlockedKey(lessonId + 1), true);
    }
  }

  // -----------------------------
  // RESET (opsional)
  // -----------------------------
  static Future<void> resetAllLessons() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 1; i <= maxLessons; i++) {
      await prefs.remove(_lessonScoreKey(i));
      await prefs.remove(_lessonUnlockedKey(i));
    }
  }
}
