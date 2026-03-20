import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataPage extends StatefulWidget {
  final int level; // misal level 1, level 2 dll
  const LatihanSukuKataPage({super.key, this.level = 1});

  @override
  State<LatihanSukuKataPage> createState() => _LatihanSukuKataPageState();
}

class _LatihanSukuKataPageState extends State<LatihanSukuKataPage>
    with TickerProviderStateMixin {

  // -----------------------------
  // DATA SUKU KATA PER LEVEL
  // -----------------------------
  final Map<int, Map<String, String>> levelData = {
    1: {
      "BA": "بَ",
      "BI": "بِ",
      "BU": "بُ",
    },
    2: {
      "TA": "تَ",
      "TI": "تِ",
      "TU": "تُ",
      "FA": "فَ",
      "FI": "فِ",
      "FU": "فُ",
    },
  };

  late Map<String, String> currentSet;

  late String currentLatin;
  late String currentSyllable;

  int questionIndex = 1; // 1 → 5
  int correctCount = 0;

  // -----------------------------
  // ANIMATION CONTROLLERS
  // -----------------------------
  late AnimationController correctAnim;
  late AnimationController wrongAnim;

  @override
  void initState() {
    super.initState();

    // load set level
    currentSet = levelData[widget.level]!;

    correctAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    generateQuestion();
  }

  @override
  void dispose() {
    correctAnim.dispose();
    wrongAnim.dispose();
    super.dispose();
  }

  // -----------------------------
  // GENERATE RANDOM QUESTION
  // -----------------------------
  void generateQuestion() {
    final keys = currentSet.keys.toList();
    final random = Random();

    currentLatin = keys[random.nextInt(keys.length)];
    currentSyllable = currentSet[currentLatin]!;

    setState(() {});
  }

  // -----------------------------
  // CEK JAWABAN
  // -----------------------------
  void checkAnswer(String answer) async {
    final bool benar = answer == currentLatin;

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

    setState(() {
      questionIndex++;
    });

    generateQuestion();
  }

  // -----------------------------
  // FINISH SESSION
  // -----------------------------
  void finishLevel() async {
    double scorePercent = (correctCount / 5) * 100;

    // Save score
    await SukuKataService.saveLevelScore(widget.level, scorePercent);

    // XP Gain
    int xpGain = correctCount * 5;

    double currentXP = await SukuKataService.getLevelScore(widget.level);
    await SukuKataService.saveLevelScore(widget.level, scorePercent);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(scorePercent, xpGain),
    );
  }

  // -----------------------------
  // RESULT DIALOG
  // -----------------------------
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
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
              score >= 50 ? "Bagus Sekali!" : "Ayo Coba Lagi",
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Benar: $correctCount dari 5\n+ $xpGain XP",
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // BUTTON
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
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(
          parent: correctAnim,
          curve: Curves.elasticOut,
        ),
      ),
      child: GestureDetector(
        onTap: () => checkAnswer(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8FFF0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF50D1A0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF42C88A),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // -----------------------------
  // BUILD UI
  // -----------------------------
  @override
  Widget build(BuildContext context) {
    final options = currentSet.keys.take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Latihan Level ${widget.level}",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PROGRESS
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

            // QUESTION: ARABIC
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
                  currentSyllable,
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
                childAspectRatio: 1.2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                children: [
                  for (var o in options) buildOption(o),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
