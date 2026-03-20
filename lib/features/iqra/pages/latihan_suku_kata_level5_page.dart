import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataLevel5Page extends StatefulWidget {
  const LatihanSukuKataLevel5Page({super.key});

  @override
  State<LatihanSukuKataLevel5Page> createState() =>
      _LatihanSukuKataLevel5PageState();
}

class _LatihanSukuKataLevel5PageState
    extends State<LatihanSukuKataLevel5Page> with TickerProviderStateMixin {
  // ===============================
  // DATA KATA 3 HURUF
  // ===============================
  final List<Map<String, String>> level5Words = [
    {"ar": "كَتَبَ", "lat": "KATABA"},
    {"ar": "فَرِحَ", "lat": "FARIHA"},
    {"ar": "رَكِبَ", "lat": "RAKIBA"},
    {"ar": "مَدَدَ", "lat": "MADADA"},
    {"ar": "بَسَمَ", "lat": "BASAMA"},
    {"ar": "خَرَجَ", "lat": "KHARAJA"},
    {"ar": "فَتَحَ", "lat": "FATAHA"},
    {"ar": "جَلَسَ", "lat": "JALASA"},
    {"ar": "لَعِبَ", "lat": "LA'IBA"},
    {"ar": "نَظَرَ", "lat": "NAZHARA"},
  ];

  late Map<String, String> question;
  late String correctLatin;
  List<String> options = [];

  int questionIndex = 1;
  int correctCount = 0;

  // ===============================
  // INIT
  // ===============================
  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  // ===============================
  // GENERATE NEW QUESTION
  // ===============================
  void generateNewQuestion() {
    final random = Random();

    question = level5Words[random.nextInt(level5Words.length)];
    correctLatin = question["lat"]!;

    // Buat 3 pilihan
    options = [correctLatin];

    while (options.length < 3) {
      final rand = level5Words[random.nextInt(level5Words.length)]["lat"]!;
      if (!options.contains(rand)) options.add(rand);
    }

    options.shuffle();

    setState(() {});
  }

  // ===============================
  // CHECK ANSWER + NEXT QUESTION
  // ===============================
  void checkAnswer(String answer) async {
    bool benar = answer == correctLatin;

    if (benar) correctCount++;

    // Tunggu animasi tombol dulu
    await Future.delayed(const Duration(milliseconds: 400));

    if (questionIndex == 5) {
      finishLevel();
      return;
    }

    setState(() {
      questionIndex++;
    });

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

    // Save & Unlock next level
    await SukuKataService.saveLevelScore(5, score);
    if (score >= 50) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("level_6_unlocked", true);
    }


    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(score, xpGain),
    );

    print("Saving score L5: $score");
    print("Unlocking level 6...");
    final prefs = await SharedPreferences.getInstance();
    print("Value before: ${prefs.getBool("level_6_unlocked")}");
    prefs.setBool("level_6_unlocked", true);
    print("Value after: ${prefs.getBool("level_6_unlocked")}");

  }

  // ===============================
  // RESULT POPUP
  // ===============================
  Widget _resultDialog(double score, int xpGain) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 26),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score >= 50 ? "Keren Banget!" : "Ayo Belajar Lagi",
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
  // OPTION BUTTON (ANIMATED)
  // ===============================
  Widget buildOption(String label) {
    return StatefulBuilder(
      builder: (context, localSetState) {
        double scale = 1.0;

        return GestureDetector(
          onTap: () async {
            bool benar = label == correctLatin;

            if (benar) {
              localSetState(() => scale = 1.15);
            } else {
              localSetState(() => scale = 0.85);
            }

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
        title:
            Text("Latihan Level 5", style: GoogleFonts.poppins()),
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Pilihan
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
