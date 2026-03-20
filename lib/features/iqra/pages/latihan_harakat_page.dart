import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class LatihanHarakatPage extends StatefulWidget {
  const LatihanHarakatPage({super.key});

  @override
  State<LatihanHarakatPage> createState() => _LatihanHarakatPageState();
}

class _LatihanHarakatPageState extends State<LatihanHarakatPage> {
  final List<String> hurufList = [
    "ب", "ت", "ث", "ج", "ح", "خ",
    "د", "ذ", "ر", "ز", "س", "ش",
    "ص", "ض", "ط", "ظ", "ع", "غ",
    "ف", "ق", "ك", "ل", "م", "ن",
    "ه", "و", "ي",
  ];

  final Map<String, String> harakat = {
    "A": "َ",  // Fathah
    "I": "ِ",  // Kasrah
    "U": "ُ",  // Dhammah
  };

  late String currentHuruf;
  late String correctLatin;
  late String correctHarakat;

  @override
  void initState() {
    super.initState();
    generateNewQuestion();
  }

  void generateNewQuestion() {
    final random = Random();

    currentHuruf = hurufList[random.nextInt(hurufList.length)];

    // Ambil kunci harakat (A / I / U)
    final keys = harakat.keys.toList();
    correctLatin = keys[random.nextInt(keys.length)];

    // Simbol harakat
    correctHarakat = harakat[correctLatin]!;

    setState(() {});
  }

  void checkAnswer(String answer) {
    final bool benar = answer == correctLatin;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: Text(
          benar ? "Benar!" : "Kurang Tepat",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 22,
            color: benar ? Colors.green : Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          benar
              ? "Kamu hebat! Lanjut soal berikutnya."
              : "Yang benar adalah: $currentHuruf$correctHarakat ($correctLatin)",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 16),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF42C88A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              generateNewQuestion();
            },
            child: const Text("Lanjut"),
          )
        ],
      ),
    );
  }

  Widget buildOptionButton(String label) {
    return GestureDetector(
      onTap: () => checkAnswer(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF42C88A),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Latihan Harakat"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            Text(
              "Pilih harakat yang benar!",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            const SizedBox(height: 30),

            // Huruf besar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: const Color(0xFFF2FFF6),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Center(
                child: Text(
                  "$currentHuruf$correctHarakat",
                  style: const TextStyle(
                    fontSize: 80,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 40),

            // Pilihan Harakat
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 18,
                crossAxisSpacing: 18,
                children: [
                  buildOptionButton("A"),
                  buildOptionButton("I"),
                  buildOptionButton("U"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
