import 'package:shared_preferences/shared_preferences.dart';

class SukuKataService {
  static const int maxLevels = 10;
  static const int passingScore = 50;

  // KEY BUILDER
  static String _scoreKey(int level) => "sk_level_${level}_score";
  static String _unlockKey(int level) => "sk_level_${level}_unlocked";

  // Level 1 selalu unlocked
  static Future<bool> isLevelUnlocked(int level) async {
    final prefs = await SharedPreferences.getInstance();

    // level 1 harus selalu unlocked
    if (level == 1) return true;

    return prefs.getBool("level_${level}_unlocked") ?? false;
    print(prefs.getBool("level_${level}_unlocked"));
  }


  static Future<double> getLevelScore(int level) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_scoreKey(level)) ?? 0.0;
  }

  static Future<void> saveLevelScore(int level, double score) async {
    final prefs = await SharedPreferences.getInstance();
    
    await prefs.setDouble("level_${level}_score", score);

    // UNLOCK NEXT LEVEL (score must be ≥ 50)
    if (score >= 50 && level < 10) {
      prefs.setBool("level_${level+1}_unlocked", true);
    }
  }

  static Future<void> resetAll() async {
    final prefs = await SharedPreferences.getInstance();
    for (int i = 1; i <= maxLevels; i++) {
      await prefs.remove(_scoreKey(i));
      await prefs.remove(_unlockKey(i));
    }
  }

  static Future<int> getUnlockedLevelCount(int totalLevels) async {
    final prefs = await SharedPreferences.getInstance();
    int count = 1; // level 1 selalu unlocked

    for (int i = 2; i <= totalLevels; i++) {
      bool unlocked = prefs.getBool("suku_level_${i}_unlocked") ?? false;
      if (unlocked) count++;
    }

    return count;
  }
}
