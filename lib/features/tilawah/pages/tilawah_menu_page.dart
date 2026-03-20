import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../routes/app_routes.dart';

class TilawahMenuPage extends StatelessWidget {
  const TilawahMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: ListView(
        children: [
          _heroSection(context),
          const SizedBox(height: 20),
          _theoryCard(), // teori tilawah sederhana
          const SizedBox(height: 20),
          _descriptionSection(),
          const SizedBox(height: 22),
          _progressSection(),
          const SizedBox(height: 25),
          _exerciseList(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // =========================
  // Hero section
  // =========================
  Widget _heroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: const DecorationImage(
          image: AssetImage("assets/images/hijaiyah_banner_2.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.05),
              Colors.black.withOpacity(0.40),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // back button glass
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Latihan Tilawah",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Tilawah Al-Qur’an",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 16),
            // badge level
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Text(
                "Pemula",
                style: GoogleFonts.poppins(
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =========================
  // Theory Card
  // =========================
  Widget _theoryCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
            "Tujuannya mendekatkan diri kepada Allah, melatih kefasihan, dan membiasakan bacaan indah. "
            "Adab tilawah: berwudhu, membaca tenang, memulai dengan ta’awudz dan basmalah.",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
          Text(
            "\nJenis Tilawah:\n"
            "- Tilawah Tartil: membaca perlahan dan jelas.\n"
            "- Tilawah Cepat (Hadr): membaca cepat tapi tetap sesuai tajwid.\n"
            "- Tilawah dengan Basmalah: memulai bacaan dengan Bismillah.\n"
            "- Tilawah tanpa Basmalah: kondisi tertentu di tengah surat.",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black87, height: 1.3),
          ),
        ],
      ),
    );
  }

  // =========================
  // Description
  // =========================
  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Pilih gaya latihan untuk meningkatkan kemampuan membaca Tilawah Al-Qur’an.",
            style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
          ),
          const SizedBox(height: 4),
          Text(
            "2 Aktivitas latihan",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // =========================
  // Progress section
  // =========================
  Widget _progressSection() {
    // TODO: bind ke progress latihan tilawah (XP/penyelesaian)
    double progressValue = 0.0;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress",
            style: GoogleFonts.poppins(fontSize: 15, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
              color: const Color(0xFF50D1A0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${(progressValue * 100).toInt()}% selesai",
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // =========================
  // Exercise list
  // =========================
  Widget _exerciseList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _exerciseItem(
            context,
            title: "Latihan Soal Interaktif",
            subtitle: "Jawab soal pilihan untuk mengenali bacaan Tilawah",
            icon: Icons.quiz_rounded,
            color: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
            onTap: () => Navigator.pushNamed(context, AppRoutes.latihanTilawahPilihan),
            unlocked: true,
          ),
          _exerciseItem(
            context,
            title: "Praktek Bacaan Tilawah",
            subtitle: "Simulasi membaca dengan suara (dummy recording)",
            icon: Icons.mic_rounded,
            color: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFE53935),
            onTap: () => Navigator.pushNamed(context, AppRoutes.latihanTilawahRecording),
            unlocked: true,
          ),
        ],
      ),
    );
  }

  // =========================
  // Single exercise card
  // =========================
  Widget _exerciseItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
    required bool unlocked,
  }) {
    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: unlocked ? color : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: unlocked ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      )),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF50D1A0),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
