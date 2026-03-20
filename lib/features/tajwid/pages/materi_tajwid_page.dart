import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../routes/app_routes.dart';

class MateriTajwidPage extends StatelessWidget {
  const MateriTajwidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Teori Tajwid Dasar"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _introCard(),
          const SizedBox(height: 20),

          _tajwidItem(
            context,
            title: "1. Hukum Nun Mati & Tanwin",
            description: "Membahas Idzhar, Idgham, Iqlab, dan Ikhfa. Contoh: مَنْ يَعْمَلْ → Ikhfa.",
            route: AppRoutes.materiNunTanwin,
          ),
          _tajwidItem(
            context,
            title: "2. Hukum Mim Mati",
            description: "Membahas Idzhar Syafawi, Ikhfa Syafawi, dan Idgham Mimi. Contoh: يَحْمِلْهُ → Ikhfa Syafawi.",
            route: AppRoutes.materiMimMati,
          ),
          _tajwidItem(
            context,
            title: "3. Mad (Panjang Bacaan)",
            description: "Mad Thabi’i, Mad Wajib Muttashil, Mad Jaiz Munfashil, dll. Contoh: قَالَ → Mad Thabi’i.",
            route: AppRoutes.materiMad,
          ),
          _tajwidItem(
            context,
            title: "4. Qalqalah",
            description: "Pantulan suara pada huruf ب، ج، د، ط، ق. Contoh: يَجْعَلْ → Qalqalah.",
            route: AppRoutes.materiQalqalah,
          ),
          _tajwidItem(
            context,
            title: "5. Ghunnah (Dengung)",
            description: "Dengung saat membaca huruf ن dan م yang bertasydid. Contoh: إِنَّ → Ghunnah.",
            route: AppRoutes.materiGhunnah,
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Apa itu Tajwid?",
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Tajwid adalah ilmu untuk membaca Al-Qur’an dengan benar dan indah. "
            "Tujuannya agar bacaan kita sesuai dengan cara Rasulullah ﷺ membaca, "
            "dan tidak mengubah arti ayat karena kesalahan bacaan.",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _tajwidItem(
    BuildContext context, {
    required String title,
    required String description,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF1FFF6),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.menu_book_rounded, color: Color(0xFF2E7D32), size: 26),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2E7D32),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: Colors.black26, size: 28),
          ],
        ),
      ),
    );
  }
}
