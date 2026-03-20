import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel2Page extends StatefulWidget {
  const LatihanSukuKataLevel2Page({super.key});

  @override
  State<LatihanSukuKataLevel2Page> createState() =>
      _LatihanSukuKataLevel2PageState();
}

class _LatihanSukuKataLevel2PageState
    extends State<LatihanSukuKataLevel2Page> with TickerProviderStateMixin {
  // -----------------------------
  // LEVEL 2 DATA
  // TA–TI–TU, TSA–TSI–TSU, FA–FI–FU, KA–KI–KU, MA–MI–MU
  // -----------------------------
  final Map<String, Map<String, String>> level2 = {
    "ت": {"TA": "تَ", "TI": "تِ", "TU": "تُ"},
    "ث": {"TSA": "ثَ", "TSI": "ثِ", "TSU": "ثُ"},
    "ف": {"FA": "فَ", "FI": "فِ", "FU": "فُ"},
    "ك": {"KA": "كَ", "KI": "كِ", "KU": "كُ"},
    "م": {"MA": "مَ", "MI": "مِ", "MU": "مُ"},
  };

  late String currentHuruf;
  late String currentLatin;
  late String currentSyllable;

  List<String> answerOptions = [];

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
      upperBound: 1.0,
    );

    wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      lowerBound: 0.0,
      upperBound: 1.0,
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
  // RANDOM SOAL
  // -----------------------------
  void generateNewQuestion() {
    final random = Random();

    // Random huruf
    final hurufKeys = level2.keys.toList();
    currentHuruf = hurufKeys[random.nextInt(hurufKeys.length)];

    // Random suku kata
    final suku = level2[currentHuruf]!;
    final latinKeys = suku.keys.toList();

    currentLatin = latinKeys[random.nextInt(latinKeys.length)];
    currentSyllable = suku[currentLatin]!;

    // Answer options (3)
    answerOptions = latinKeys;

    setState(() {});
  }

  // -----------------------------
  // CEK JAWABAN
  // -----------------------------
  void checkAnswer(String answer) async {
    bool benar = answer == currentLatin;

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
    generateNewQuestion();
  }

  // -----------------------------
  // FINISH SESSION
  // -----------------------------
  void finishLevel() async {
    double scorePercent = (correctCount / 5) * 100;
    int xpGain = correctCount * 5;

    // save score
    await SukuKataService.saveLevelScore(2, scorePercent);

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
  // OPTION BUTTON (WITH ANIMATION)
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Latihan Level 2",
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // PROGRESS BAR (5 steps)
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

            // ARABIC SYLLABLE CARD
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
                  for (var opt in answerOptions) buildOption(opt),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
