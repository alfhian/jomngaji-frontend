import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel9Page extends StatefulWidget {
  const LatihanSukuKataLevel9Page({super.key});

  @override
  State<LatihanSukuKataLevel9Page> createState() =>
      _LatihanSukuKataLevel9PageState();
}

class _LatihanSukuKataLevel9PageState
    extends State<LatihanSukuKataLevel9Page> with TickerProviderStateMixin {

  // ===============================
  // DATA MAD
  // ===============================
  final List<Map<String, String>> level9Words = [
    // MAD A
    {"ar": "قَالَ", "lat": "QAALA"},
    {"ar": "نَامَ", "lat": "NAAMA"},
    {"ar": "جَاءَ", "lat": "JAA'A"},
    {"ar": "طَالَ", "lat": "TAALA"},

    // MAD U
    {"ar": "يَقُولُ", "lat": "YAQULU"},
    {"ar": "نُورٌ", "lat": "NUURUN"},
    {"ar": "يَدُومُ", "lat": "YADUUMU"},

    // MAD I
    {"ar": "كَرِيم", "lat": "KARIIM"},
    {"ar": "يُقِيمُونَ", "lat": "YUQIIMUUNA"},
    {"ar": "حَكِيم", "lat": "HAKIIM"},
  ];

  late Map<String, String> question;
  late String correctLatin;
  List<String> options = [];

  int questionIndex = 1;
  int correctCount = 0;

  late AnimationController correctAnim;
  late AnimationController wrongAnim;

  @override
  void initState() {
    super.initState();

    correctAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      upperBound: 1.12,
      lowerBound: 0.9,
    );

    wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );

    generateNewQuestion();
  }

  @override
  void dispose() {
    correctAnim.dispose();
    wrongAnim.dispose();
    super.dispose();
  }

  // ===============================
  // GENERATE QUESTION
  // ===============================
  void generateNewQuestion() {
    final random = Random();
    question = level9Words[random.nextInt(level9Words.length)];
    correctLatin = question["lat"]!;

    options = [correctLatin];
    while (options.length < 3) {
      final randomOption =
          level9Words[random.nextInt(level9Words.length)]["lat"]!;
      if (!options.contains(randomOption)) {
        options.add(randomOption);
      }
    }
    options.shuffle();

    setState(() {});
  }

  // ===============================
  // CHECK ANSWER
  // ===============================
  void checkAnswer(String answer) async {
    bool benar = answer == correctLatin;

    if (benar) {
      correctCount++;
      correctAnim.forward(from: 0);
    } else {
      wrongAnim.forward(from: 0);
    }

    await Future.delayed(const Duration(milliseconds: 550));

    if (questionIndex == 5) {
      finishLevel();
      return;
    }

    setState(() => questionIndex++);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) generateNewQuestion();
    });
  }

  // ===============================
  // FINISH SESSION
  // ===============================
  void finishLevel() async {
    double score = (correctCount / 5) * 100;
    int xpGain = correctCount * 5;

    await SukuKataService.saveLevelScore(9, score);

    if (score >= 50) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool("level_10_unlocked", true);
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(score, xpGain),
    );
  }

  // ===============================
  // RESULT POPUP
  // ===============================
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score >= 50 ? "MasyaAllah! Hebat!" : "Ayo Coba Lagi!",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),

            Text(
              "Benar: $correctCount / 5\n+ $xpGain XP",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 17),
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
                    colors: [Color(0xFF50D1A0), Color(0xFF2FB576)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(
                    "Kembali",
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===============================
  // OPTION BUTTON
  // ===============================
  Widget buildOption(String label) {
    return StatefulBuilder(
      builder: (context, localSetState) {
        double scale = 1.0;

        return GestureDetector(
          onTap: () async {
            bool benar = label == correctLatin;
            localSetState(() => scale = benar ? 1.15 : 0.85);

            await Future.delayed(const Duration(milliseconds: 180));
            localSetState(() => scale = 1.0);

            checkAnswer(label);
          },
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF50D1A0)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    spreadRadius: 1,
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
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

  // ===============================
  // MAIN UI
  // ===============================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Level 9", style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            // Progress Bar
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
                    color:
                        active ? const Color(0xFF42C88A) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // Arabic Card
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
                  question["ar"]!,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Options
            Expanded(
              child: GridView.count(
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                crossAxisCount: 3,
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
