import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class MakhrajPage extends StatefulWidget {
  const MakhrajPage({super.key});

  @override
  State<MakhrajPage> createState() => _MakhrajPageState();
}

class _MakhrajPageState extends State<MakhrajPage> {
  int currentIndex = 1;
  int totalQuestions = 5;

  // Dummy huruf hijaiyah untuk latihan
  final List<String> hurufList = ["ب", "ت", "ث", "ج", "ح"];
  String feedback = "";

  @override
  Widget build(BuildContext context) {
    final currentHuruf = hurufList[currentIndex - 1];

    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Latihan Pengucapan (Makhraj)"),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            const SizedBox(height: 10),

            buildInfoCard(),

            const SizedBox(height: 14),

            // Progress bar
            LinearProgressIndicator(
              value: currentIndex / totalQuestions,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF42C88A),
              minHeight: 8,
            ),
            const SizedBox(height: 18),

            Text(
              "Ucapkan huruf berikut dengan benar:",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),

            // Huruf hijaiyah besar
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
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
                child: Text(
                  currentHuruf,
                  style: const TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Tombol rekam suara (dummy)
            GestureDetector(
              onTap: () {
                setState(() {
                  feedback = "Sedang merekam... (AI nanti dihubungkan)";
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
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
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: feedback.contains("benar")
                    ? Colors.green
                    : Colors.black87,
              ),
            ),

            const Spacer(),

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
      ),
    );
  }

  Widget buildInfoCard() {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Tujuan Latihan Makhraj",
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Halaman ini membantu kamu berlatih mengucapkan huruf hijaiyah sesuai makhraj (tempat keluarnya huruf). "
            "Dengan latihan ini, kamu akan terbiasa melafalkan huruf dengan benar sehingga bacaan Al-Qur’an lebih fasih.",
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
