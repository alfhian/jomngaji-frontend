import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel3Page extends StatefulWidget {
  const LatihanSukuKataLevel3Page({super.key});

  @override
  State<LatihanSukuKataLevel3Page> createState() =>
      _LatihanSukuKataLevel3PageState();
}

class _LatihanSukuKataLevel3PageState
    extends State<LatihanSukuKataLevel3Page> with TickerProviderStateMixin {
  // DATA DASAR
  final Map<String, Map<String, String>> data = {
    "ب": {"BA": "بَ", "BI": "بِ", "BU": "بُ"},
    "ت": {"TA": "تَ", "TI": "تِ", "TU": "تُ"},
    "ف": {"FA": "فَ", "FI": "فِ", "FU": "فُ"},
    "م": {"MA": "مَ", "MI": "مِ", "MU": "مُ"},
    "ن": {"NA": "نَ", "NI": "نِ", "NU": "نُ"},
    "ر": {"RA": "رَ", "RI": "رِ", "RU": "رُ"},
  };

  String firstLatin = "";
  String secondLatin = "";
  String firstAyat = "";
  String secondAyat = "";

  String finalArabic = "";
  String finalLatin = "";

  List<String> options = [];

  // Progress
  int questionIndex = 1;
  int correctCount = 0;

  // Animations
  late AnimationController correctAnim;
  late AnimationController wrongAnim;

  @override
  void initState() {
    super.initState();

    correctAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.0,
      upperBound: 1.1,
    );

    wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );

    generateNewQuestion();
  }

  @override
  void dispose() {
    correctAnim.dispose();
    wrongAnim.dispose();
    super.dispose();
  }

  // -----------------------------
  // GENERATE QUESTION
  // -----------------------------
  void generateNewQuestion() {
    final random = Random();
    final hurufKeys = data.keys.toList();

    // huruf 1 & 2
    final huruf1 = hurufKeys[random.nextInt(hurufKeys.length)];
    final huruf2 = hurufKeys[random.nextInt(hurufKeys.length)];

    final map1 = data[huruf1]!;
    final map2 = data[huruf2]!;

    final keys1 = map1.keys.toList();
    final keys2 = map2.keys.toList();

    firstLatin = keys1[random.nextInt(keys1.length)];
    secondLatin = keys2[random.nextInt(keys2.length)];

    firstAyat = map1[firstLatin]!;
    secondAyat = map2[secondLatin]!;

    finalArabic = firstAyat + secondAyat;
    finalLatin = firstLatin + secondLatin;

    // opsi jawaban (benar + salah)
    options = [finalLatin];

    while (options.length < 3) {
      final h1 = hurufKeys[random.nextInt(hurufKeys.length)];
      final h2 = hurufKeys[random.nextInt(hurufKeys.length)];

      final m1 = data[h1]!;
      final m2 = data[h2]!;

      final k1 = m1.keys.toList()[random.nextInt(m1.length)];
      final k2 = m2.keys.toList()[random.nextInt(m2.length)];

      final wrong = k1 + k2;

      if (!options.contains(wrong)) {
        options.add(wrong);
      }
    }

    options.shuffle();
    setState(() {});
  }

  // -----------------------------
  // CHECK ANSWER
  // -----------------------------
  void checkAnswer(String answer) async {
    bool benar = answer == finalLatin;

    if (benar) correctCount++;

    await Future.delayed(const Duration(milliseconds: 350));

    if (questionIndex == 5) {
      finishLevel();
      return;
    }

    setState(() => questionIndex++);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) generateNewQuestion();
    });
  }


  // -----------------------------
  // FINISH SESSION
  // -----------------------------
  void finishLevel() async {
    double scorePercent = (correctCount / 5) * 100;
    int xpGain = correctCount * 5;

    await SukuKataService.saveLevelScore(3, scorePercent);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(scorePercent, xpGain),
    );
  }

  // -----------------------------
  // RESULT POPUP
  // -----------------------------
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score >= 50 ? "Luar Biasa!" : "Ayo Coba Lagi",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Benar: $correctCount / 5\n+ $xpGain XP",
              style: GoogleFonts.poppins(fontSize: 17),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 26),

            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                      colors: [Color(0xFF50D1A0), Color(0xFF2FB576)]),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.poppins(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // OPTION BUTTON (ANIMATED)
  // -----------------------------
  Widget buildOption(String label) {
    return StatefulBuilder(
      builder: (context, localSetState) {
        double scale = 1.0;

        return GestureDetector(
          onTap: () async {
            bool benar = label == finalLatin;

            if (benar) {
              localSetState(() => scale = 1.15);
              await Future.delayed(const Duration(milliseconds: 200));
              localSetState(() => scale = 1.0);
            } else {
              localSetState(() => scale = 0.85);
              await Future.delayed(const Duration(milliseconds: 200));
              localSetState(() => scale = 1.0);
            }

            checkAnswer(label);
          },
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF50D1A0), width: 1.2),
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF42C88A),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  // -----------------------------
  // BUILD UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Level 3", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // PROGRESS BAR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (i) {
                final active = (i + 1) <= questionIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 16,
                  height: 10,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF42C88A) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // ARABIC DISPLAY
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  finalArabic,
                  style: const TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // OPTIONS
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  for (var opt in options) buildOption(opt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
