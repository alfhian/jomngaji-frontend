import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel10Page extends StatefulWidget {
  const LatihanSukuKataLevel10Page({super.key});

  @override
  State<LatihanSukuKataLevel10Page> createState() =>
      _LatihanSukuKataLevel10PageState();
}

class _LatihanSukuKataLevel10PageState
    extends State<LatihanSukuKataLevel10Page> with TickerProviderStateMixin {

  // ======================
  // DATA AYAT PENDEK
  // ======================
  final List<Map<String, String>> level10Verses = [
    {"ar": "قُلْ هُوَ اللّٰهُ أَحَدٌ", "lat": "Qul huwallahu ahad"},
    {"ar": "اللّٰهُ الصَّمَدُ", "lat": "Allahu shamad"},
    {"ar": "قُلْ أَعُوذُ بِرَبِّ النَّاسِ", "lat": "Qul a'udzu birabbin-nas"},
    {"ar": "مَالِكِ يَوْمِ الدِّينِ", "lat": "Maliki yaumid-din"},
    {"ar": "الْحَمْدُ لِلّٰهِ رَبِّ الْعَالَمِينَ", "lat": "Alhamdu lillahi rabbil 'alamin"},
    {"ar": "إِيَّاكَ نَعْبُدُ وَإِيَّاكَ نَسْتَعِينُ", "lat": "Iyyaka na'budu wa iyyaka nasta'in"},
    {"ar": "قُلْ أَعُوذُ بِرَبِّ الْفَلَقِ", "lat": "Qul a'udzu birabbil-falaq"},
    {"ar": "مِنْ شَرِّ مَا خَلَقَ", "lat": "Min sharri ma khalaq"},
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
      duration: const Duration(milliseconds: 160),
    );

    generateNewQuestion();
  }

  @override
  void dispose() {
    correctAnim.dispose();
    wrongAnim.dispose();
    super.dispose();
  }

  // ======================
  // GENERATE QUESTION
  // ======================
  void generateNewQuestion() {
    final random = Random();
    question = level10Verses[random.nextInt(level10Verses.length)];
    correctLatin = question["lat"]!;

    options = [correctLatin];
    while (options.length < 3) {
      final randomOpt =
          level10Verses[random.nextInt(level10Verses.length)]["lat"]!;
      if (!options.contains(randomOpt)) options.add(randomOpt);
    }

    options.shuffle();
    setState(() {});
  }

  // ======================
  // CHECK ANSWER
  // ======================
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

  // ======================
  // FINISH SESSION
  // ======================
  void finishLevel() async {
    double score = (correctCount / 5) * 100;
    int xpGain = correctCount * 5;

    // Save score
    await SukuKataService.saveLevelScore(10, score);

    // No next level (level terakhir)
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("level_10_unlocked", true);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(score, xpGain),
    );
  }

  // ======================
  // RESULT POPUP
  // ======================
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score >= 50 ? "MasyaAllah! Selesai!" : "Ayo Coba Lagi!",
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

  // ======================
  // OPTION BUTTON
  // ======================
  Widget buildOption(String label) {
    return StatefulBuilder(
      builder: (context, localSetState) {
        double scale = 1.0;

        return GestureDetector(
          onTap: () async {
            bool benar = label == correctLatin;
            localSetState(() => scale = benar ? 1.15 : 0.85);

            await Future.delayed(const Duration(milliseconds: 160));
            localSetState(() => scale = 1.0);

            checkAnswer(label);
          },
          child: AnimatedScale(
            scale: scale,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeOutBack,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE8FFF0),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFF50D1A0)),
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF42C88A),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // ======================
  // MAIN UI
  // ======================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Latihan Level 10", style: GoogleFonts.poppins()),
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
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                    color: Colors.black.withOpacity(0.06),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  question["ar"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    height: 1.6,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // OPTIONS
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, index) => buildOption(options[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
