import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/hijaiyah_data.dart';
import 'materi_huruf_detail_page.dart';
import '../../../services/progress_service.dart';

class MateriHijaiyahPage extends StatelessWidget {
  const MateriHijaiyahPage({super.key});

  // =========================================================
  // 📌 14 PELAJARAN MAPPING
  // =========================================================
  List<Map<String, dynamic>> get materiHijaiyahLessons => [
        {"title": "Huruf Alif dan Ba", "list": [0, 1]},
        {"title": "Huruf Ta dan Tsa", "list": [2, 3]},
        {"title": "Huruf Jim, Ha, Kha", "list": [4, 5, 6]},
        {"title": "Huruf Dal dan Dzal", "list": [7, 8]},
        {"title": "Huruf Ra dan Zai", "list": [9, 10]},
        {"title": "Huruf Sin dan Syin", "list": [11, 12]},
        {"title": "Huruf Shad dan Dhad", "list": [13, 14]},
        {"title": "Huruf Tha dan Zha", "list": [15, 16]},
        {"title": "Huruf Ain dan Ghain", "list": [17, 18]},
        {"title": "Huruf Fa dan Qaf", "list": [19, 20]},
        {"title": "Huruf Kaf dan Lam", "list": [21, 22]},
        {"title": "Huruf Mim dan Nun", "list": [23, 24]},
        {"title": "Huruf Ha' dan Wau", "list": [25, 26]},
        {"title": "Huruf Ya", "list": [27]},
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true, // appbar menyatu dengan hero
      appBar: null,
      body: ListView(
        children: [
          _heroSection(context),
          const SizedBox(height: 20),
          _descriptionSection(),
          const SizedBox(height: 22),
          _progressSection(),
          const SizedBox(height: 25),
          _lessonList(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // =========================================================
  // 📌 HERO SECTION
  // =========================================================
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
        // overlay gradient lembut untuk readability
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
            // ---- BACK BUTTON MODERN (GLASS EFFECT) ----
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

            // ---- LABEL (small heading) ----
            Text(
              "Materi 1",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            // ---- BIG TITLE ----
            Text(
              "Belajar Huruf\nHijaiyah",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 16),

            // ---- BADGE: LEVEL ----
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


  // =========================================================
  // 📌 Description
  // =========================================================
  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Belajar membaca, mengenal, dan mengucapkan huruf Hijaiyah.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "14 Pelajaran",
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 📌 Progress Section
  // =========================================================
  Widget _progressSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Progress",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.0, // future: ganti dengan XP / Level
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
              color: const Color(0xFF50D1A0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "0% selesai",
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // 📌 Lesson List
  // =========================================================
  Widget _lessonList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(
          materiHijaiyahLessons.length,
          (index) {
            return FutureBuilder<bool>(
              future: ProgressService.isLessonUnlocked(index + 1),
              builder: (context, snapshot) {
                final unlocked = snapshot.data ?? (index == 0);

                final lesson = materiHijaiyahLessons[index];
                final List<int> idxList = List<int>.from(lesson["list"] as List);
                final List<HijaiyahData> hurufList =
                    idxList.map((i) => hijaiyahList[i]).toList();

                return _lessonItem(
                  context,
                  number: index + 1,
                  title: lesson["title"] as String,
                  unlocked: unlocked,
                  onTap: unlocked
                      ? () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MateriHurufDetailPage(
                                lessonId: index + 1,
                                lessonTitle: lesson["title"] as String,
                                hurufList: hurufList,
                              ),
                            ),
                          );
                        }
                      : null,
                );
              },
            );
          },
        ),
      ),
    );
  }

  // =========================================================
  // 📌 Single Lesson Card
  // =========================================================
  Widget _lessonItem(
    BuildContext context, {
    required int number,
    required String title,
    required bool unlocked,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: unlocked ? onTap : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: unlocked ? const Color(0xFFE7FFF2) : Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: unlocked ? Colors.transparent : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              unlocked ? Icons.menu_book_rounded : Icons.lock_rounded,
              size: 26,
              color: unlocked ? const Color(0xFF50D1A0) : Colors.grey,
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Pelajaran ke-$number",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            if (unlocked)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFF50D1A0),
                  shape: BoxShape.circle,
                ),
                child:
                    const Icon(Icons.play_arrow_rounded, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
