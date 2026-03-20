import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class LisaniPage extends StatefulWidget {
  const LisaniPage({super.key});

  @override
  State<LisaniPage> createState() => _LisaniPageState();
}

class _LisaniPageState extends State<LisaniPage> {
  final List<Map<String, String>> hurufList = [
    {"huruf": "ت", "nama": "Ta"},
    {"huruf": "د", "nama": "Dal"},
    {"huruf": "ط", "nama": "Tha"},
    {"huruf": "ظ", "nama": "Dha"},
    {"huruf": "ل", "nama": "Lam"},
    {"huruf": "ر", "nama": "Ra"},
  ];

  int currentIndex = 0;
  String feedback = "";

  void _startRecording() {
    setState(() {
      feedback = "Sedang merekam... (AI nanti dihubungkan)";
    });
  }

  void _nextHuruf() {
    if (currentIndex < hurufList.length - 1) {
      setState(() {
        currentIndex++;
        feedback = "";
      });
    } else {
      finishExercise();
    }
  }

  void finishExercise() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(),
    );
  }

  Widget _resultDialog() {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        "Latihan Selesai!",
        textAlign: TextAlign.center,
        style: GoogleFonts.poppins(
          fontSize: 20,
          color: Colors.green,
          fontWeight: FontWeight.w700,
        ),
      ),
      content: Text(
        "Kamu sudah berlatih semua huruf Lisani.\nTeruskan latihan agar bacaan semakin fasih.",
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
            Navigator.pop(context); // tutup dialog
            Navigator.pop(context); // kembali ke PengucapanPage
          },
          child: const Text("Kembali"),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentHuruf = hurufList[currentIndex];

    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Lisani (Lidah)"),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(14),
              children: [
                const SizedBox(height: 10),

                _buildInfoCard(),

                const SizedBox(height: 14),

                Text(
                  "Latihan Huruf Lisani",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF42C88A),
                  ),
                ),
                const SizedBox(height: 12),

                // Huruf besar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFDFD),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        currentHuruf["huruf"]!,
                        style: const TextStyle(
                          fontSize: 72,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF42C88A),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        currentHuruf["nama"]!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Tombol rekam
                GestureDetector(
                  onTap: _startRecording,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 32),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blue.shade200,
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.mic, color: Colors.white, size: 28),
                        const SizedBox(width: 10),
                        Text(
                          "Mulai Rekam",
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Feedback placeholder
                Text(
                  feedback,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: feedback.contains("benar")
                        ? Colors.green
                        : Colors.black87,
                  ),
                ),

                const SizedBox(height: 20),

                // Tombol Next/Lanjut
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42C88A),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 24),
                  ),
                  onPressed: _nextHuruf,
                  child: Text(
                    currentIndex == hurufList.length - 1
                        ? "Selesai"
                        : "Lanjut",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Background full width di bawah
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/background-mengaji.png",
              fit: BoxFit.cover,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // kuning pastel
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
        children: [
          Text(
            "Tujuan Latihan Lisani",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Lisani adalah huruf yang keluar dari lidah. "
            "Latihan ini membantu kamu melafalkan huruf dengan tepat dari makhrajnya, "
            "sehingga bacaan Al-Qur’an lebih fasih.",
            textAlign: TextAlign.center,
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
