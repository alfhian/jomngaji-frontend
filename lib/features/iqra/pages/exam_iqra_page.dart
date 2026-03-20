import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

import '../../../services/progress_service.dart'; // progress tracking

class ExamIqraPage extends StatefulWidget {
  const ExamIqraPage({super.key});

  @override
  State<ExamIqraPage> createState() => _ExamIqraPageState();
}

class _ExamIqraPageState extends State<ExamIqraPage> {
  final List<Map<String, String>> examQuestions = [
    {"ar": "بَ", "lat": "BA"},
    {"ar": "بِ", "lat": "BI"},
    {"ar": "بُ", "lat": "BU"},
    {"ar": "بَا", "lat": "BAA"},
    {"ar": "كُو", "lat": "KUU"},
    {"ar": "فِي", "lat": "FII"},
    {"ar": "كَتَبَ", "lat": "KATABA"},
    {"ar": "فَرِحَ", "lat": "FARIHA"},
    {"ar": "قَلْبٍ", "lat": "QALBIN"},
    {"ar": "يَفْهَمُ", "lat": "YAFHAMU"},
    {"ar": "مُحَمَّد", "lat": "MUHAMMAD"},
    {"ar": "قَالَ", "lat": "QAALA"},
    {"ar": "قُلْ هُوَ اللّٰهُ أَحَدٌ", "lat": "Qul huwallahu ahad"},
  ];

  int currentIndex = 0;
  int score = 0;
  int totalXP = 0;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  void generateOptions() {
    final random = Random();
    final correct = examQuestions[currentIndex]["lat"]!;

    options = [correct];

    while (options.length < 3) {
      final randomOpt =
          examQuestions[random.nextInt(examQuestions.length)]["lat"]!;
      if (!options.contains(randomOpt)) options.add(randomOpt);
    }

    options.shuffle();
    setState(() {});
  }

  void answer(String selected) async {
    final correct = examQuestions[currentIndex]["lat"]!;

    if (selected == correct) {
      score++;
      totalXP += 10; // Tambah XP kalau benar
    }

    // Jika sudah soal terakhir
    if (currentIndex == examQuestions.length - 1) {
      // Simpan skor tes akhir
      await ProgressService.saveExamScore(score);

      // Simpan total XP
      await ProgressService.saveXP(totalXP);

      // Jika nilai >= 50 → anggap lulus → unlock pelajaran Iqra selanjutnya (opsional)
      if (score >= ProgressService.passingScore) {
        // misal unlock pelajaran ke-2
        await ProgressService.saveLessonScore(1, 100);
      }

      showResult();
      return;
    }

    // Lanjut soal berikutnya
    currentIndex++;
    generateOptions();
  }

  void showResult() {
    String feedbackMessage;

    if (score == examQuestions.length) {
      feedbackMessage =
          "🎉 LULUS! Semua jawaban benar, kamu luar biasa!";
    } else if (score > examQuestions.length / 2) {
      feedbackMessage =
          "Bagus! Jawaban kamu lebih banyak benar. Terus belajar!";
    } else {
      feedbackMessage =
          "Perlu latihan lagi ya 😊. Jangan menyerah, kamu bisa!";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          "Tes Selesai!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          "Skor kamu: $score dari ${examQuestions.length}\n\n$feedbackMessage",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // balik ke Iqra Dasar
            },
            child: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  Widget buildOption(String text) {
    return GestureDetector(
      onTap: () => answer(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF42C88A),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = examQuestions[currentIndex];

    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Tes Akhir Iqra"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // PROGRESS BAR
            LinearProgressIndicator(
              value: (currentIndex + 1) / examQuestions.length,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF42C88A),
            ),
            const SizedBox(height: 25),

            Text(
              "Baca bacaan berikut:",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 18),

            // ARABIC
            Container(
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration: BoxDecoration(
                color: const Color(0xFFF2FFF6),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Center(
                child: Text(
                  data["ar"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 45,
                    color: Color(0xFF42C88A),
                    fontWeight: FontWeight.bold,
                    height: 1.8,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 35),

            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (_, i) => buildOption(options[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
