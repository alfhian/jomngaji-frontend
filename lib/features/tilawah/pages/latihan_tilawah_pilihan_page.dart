import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/widgets/custom_gradient_appbar.dart';

class LatihanTilawahPilihanPage extends StatefulWidget {
  const LatihanTilawahPilihanPage({super.key});

  @override
  State<LatihanTilawahPilihanPage> createState() =>
      _LatihanTilawahPilihanPageState();
}

class _LatihanTilawahPilihanPageState extends State<LatihanTilawahPilihanPage> {
  final List<Map<String, dynamic>> soalList = [
    {
      "ayat": [
        const TextSpan(text: "وَرَتِّلِ"),
        const TextSpan(
          text: " الْقُرْآنَ تَرْتِيلًا",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
      "jawaban": "Tilawah Tartil",
      "opsi": ["Tilawah Tartil", "Tilawah Cepat", "Tidak Tilawah"]
    },
    {
      "ayat": [
        const TextSpan(text: "اقْرَأْ"),
        const TextSpan(
          text: " بِاسْمِ رَبِّكَ",
          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
        ),
      ],
      "jawaban": "Tilawah dengan Basmalah",
      "opsi": ["Tilawah dengan Basmalah", "Tanpa Basmalah", "Tidak Tilawah"]
    },
  ];

  int questionIndex = 0;
  int correctCount = 0;

  void checkAnswer(String answer) async {
    bool benar = answer == soalList[questionIndex]["jawaban"];
    if (benar) correctCount++;

    await Future.delayed(const Duration(milliseconds: 400));

    if (questionIndex == soalList.length - 1) {
      finishLevel();
      return;
    }

    setState(() => questionIndex++);
  }

  void finishLevel() {
    double scorePercent = (correctCount / soalList.length) * 100;
    int xpGain = correctCount * 5;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          scorePercent >= 50 ? "Bagus Sekali!" : "Ayo Coba Lagi",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            color: scorePercent >= 50 ? Colors.green : Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Benar: $correctCount dari ${soalList.length}\n+ $xpGain XP",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF42C88A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Kembali"),
          )
        ],
      ),
    );
  }

  Widget buildOptionButton(String label) {
    return GestureDetector(
      onTap: () => checkAnswer(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFE8FFF0),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 16,
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
    final soal = soalList[questionIndex];

    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Latihan Tilawah"),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  const SizedBox(height: 10),

                  buildInfoCard(),

                  const SizedBox(height: 14),

                  LinearProgressIndicator(
                    value: (questionIndex) / soalList.length,
                    backgroundColor: Colors.grey[300],
                    color: const Color(0xFF42C88A),
                    minHeight: 8,
                  ),

                  const SizedBox(height: 18),

                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDFDFD),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          children: soal["ayat"] as List<TextSpan>,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 2.5,
                      children: [
                        for (var o in soal["opsi"]) buildOptionButton(o),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Background full width di bawah
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/background-mengaji.png",
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Teori Tilawah",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tilawah adalah membaca Al‑Qur’an dengan tartil, penuh adab dan penghayatan. "
            "Tujuannya mendekatkan diri kepada Allah, melatih kefasihan, dan membiasakan bacaan indah.\n\n"
            "Jenis‑jenis Tilawah:\n"
            "- Tilawah Tartil: membaca perlahan, jelas, penuh penghayatan.\n"
            "- Tilawah Cepat (Hadr): membaca cepat tapi tetap sesuai tajwid.\n"
            "- Tilawah dengan Basmalah: memulai bacaan dengan Bismillah.\n"
            "- Tilawah tanpa Basmalah: kondisi tertentu di tengah surat.",
            textAlign: TextAlign.start,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
