import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel4Page extends StatefulWidget {
  const LatihanSukuKataLevel4Page({super.key});

  @override
  State<LatihanSukuKataLevel4Page> createState() =>
      _LatihanSukuKataLevel4PageState();
}

class _LatihanSukuKataLevel4PageState
    extends State<LatihanSukuKataLevel4Page> with TickerProviderStateMixin {
  // DATA KATA PENDEK
  final List<Map<String, String>> level4Words = [
    {"ar": "بَا", "lat": "BA"},
    {"ar": "بِي", "lat": "BI"},
    {"ar": "بُو", "lat": "BU"},
    {"ar": "مَا", "lat": "MA"},
    {"ar": "مِي", "lat": "MI"},
    {"ar": "مُو", "lat": "MU"},
    {"ar": "فَا", "lat": "FA"},
    {"ar": "فِي", "lat": "FI"},
    {"ar": "فُو", "lat": "FU"},
    {"ar": "كَا", "lat": "KA"},
    {"ar": "كِي", "lat": "KI"},
    {"ar": "كُو", "lat": "KU"},
  ];

  late Map<String, String> question;
  late String correctLatin;

  List<String> options = [];

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
      upperBound: 1.1,
      lowerBound: 0.9,
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

    question = level4Words[random.nextInt(level4Words.length)];

    correctLatin = question["lat"]!;

    // create options
    options = [correctLatin];

    while (options.length < 3) {
      final rand = level4Words[random.nextInt(level4Words.length)]["lat"]!;
      if (!options.contains(rand)) options.add(rand);
    }

    options.shuffle();
    setState(() {});
  }

  // -----------------------------
  // CHECK ANSWER
  // -----------------------------
  void checkAnswer(String answer) async {
    bool benar = answer == correctLatin;

    if (benar) {
      correctAnim.forward(from: 0);
      correctCount++;
    } else {
      wrongAnim.forward(from: 0);
    }

    await Future.delayed(const Duration(milliseconds: 600));

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
    double score = (correctCount / 5) * 100;
    int xpGain = correctCount * 5;

    await SukuKataService.saveLevelScore(4, score);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(score, xpGain),
    );
  }

  // -----------------------------
  // RESULT POPUP
  // -----------------------------
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
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
              score >= 50 ? "Bagus Sekali!" : "Ayo Coba Lagi",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              "Benar: $correctCount / 5\n+ $xpGain XP",
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

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
                  borderRadius: BorderRadius.circular(16),
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

  // -----------------------------
  // OPTION BUTTON
  // -----------------------------
  Widget buildOption(String label) {
    return StatefulBuilder(
      builder: (context, localSetState) {
        double scale = 1.0;

        return GestureDetector(
          onTap: () async {
            bool benar = label == correctLatin;

            if (benar) {
              localSetState(() => scale = 1.15);
              await Future.delayed(const Duration(milliseconds: 180));
              localSetState(() => scale = 1.0);
            } else {
              localSetState(() => scale = 0.85);
              await Future.delayed(const Duration(milliseconds: 180));
              localSetState(() => scale = 1.0);
            }

            checkAnswer(label);
          },
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOutBack,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF50D1A0), width: 1.2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  )
                ],
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
      appBar:
          AppBar(title: Text("Latihan Level 4", style: GoogleFonts.poppins()),
              backgroundColor: const Color(0xFF50D1A0)),
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
                    color: active
                        ? const Color(0xFF42C88A)
                        : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            // ARABIC CARD
            Container(
              padding: const EdgeInsets.symmetric(vertical: 38),
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
