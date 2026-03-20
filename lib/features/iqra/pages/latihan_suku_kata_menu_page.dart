import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../routes/app_routes.dart';
import '../../../services/suku_kata_service.dart';

class LatihanSukuKataMenuPage extends StatefulWidget {
  const LatihanSukuKataMenuPage({super.key});

  @override
  State<LatihanSukuKataMenuPage> createState() =>
      _LatihanSukuKataMenuPageState();
}

class _LatihanSukuKataMenuPageState extends State<LatihanSukuKataMenuPage> {
  int unlockedCount = 1; // Level 1 selalu unlocked
  double progressValue = 0.0;

  static const int totalLevels = 10;

  @override
  void initState() {
    super.initState();
    _loadUnlockedLevels();
  }

  Future<void> _loadUnlockedLevels() async {
    int count = 1; // level 1 default unlocked

    for (int i = 2; i <= totalLevels; i++) {
      bool unlocked = await SukuKataService.isLevelUnlocked(i);
      if (unlocked) count++;
    }

    print(count);

    setState(() {
      unlockedCount = count;
      progressValue = count / totalLevels;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: ListView(
        children: [
          _heroSection(context),
          const SizedBox(height: 20),
          _descriptionSection(),
          const SizedBox(height: 22),
          _progressSection(),
          const SizedBox(height: 25),
          _levelList(context),
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
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              "Latihan Suku Kata",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Mengenal dan Mengucapkan Suku Kata",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w800,
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
            "Belajar membaca, mengenal, dan mengucapkan suku kata.",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "10 Level Pelajaran",
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
  // 📌 PROGRESS BAR (Unlocked Count)
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
              value: progressValue,
              backgroundColor: Colors.grey.shade300,
              minHeight: 8,
              color: const Color(0xFF50D1A0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "${(progressValue * 100).toInt()}% selesai",
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
  // 📌 LIST LEVEL (Dynamic Lock/Unlock)
  // =========================================================
  Widget _levelList(BuildContext context) {
    List<Map<String, String>> levels = [
      {"title": "Level 1", "desc": "BA – BI – BU", "route": AppRoutes.latihanSukuKataLevel1},
      {"title": "Level 2", "desc": "TA – TI – TU", "route": AppRoutes.latihanSukuKataLevel2},
      {"title": "Level 3", "desc": "FA – FI – FU", "route": AppRoutes.latihanSukuKataLevel3},
      {"title": "Level 4", "desc": "Dua Huruf", "route": AppRoutes.latihanSukuKataLevel4},
      {"title": "Level 5", "desc": "Tiga Huruf", "route": AppRoutes.latihanSukuKataLevel5},
      {"title": "Level 6", "desc": "Tanwin", "route": AppRoutes.latihanSukuKataLevel6},
      {"title": "Level 7", "desc": "Sukun", "route": AppRoutes.latihanSukuKataLevel7},
      {"title": "Level 8", "desc": "Tasydid", "route": AppRoutes.latihanSukuKataLevel8},
      {"title": "Level 9", "desc": "Mad", "route": AppRoutes.latihanSukuKataLevel9},
      {"title": "Level 10", "desc": "Ayat Pendek", "route": AppRoutes.latihanSukuKataLevel10},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(levels.length, (index) {
          final level = levels[index];
          final levelNumber = index + 1;

          final unlocked = levelNumber <= unlockedCount;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _levelCard(
              context,
              title: level["title"]!,
              desc: level["desc"]!,
              route: level["route"]!,
              icon: Icons.menu_book_rounded,
              unlocked: unlocked,
              levelNumber: levelNumber,
            ),
          );
        }),
      ),
    );
  }

  // =========================================================
  // 📌 LEVEL CARD
  // =========================================================
  Widget _levelCard(
    BuildContext context, {
    required String title,
    required String desc,
    required IconData icon,
    required String route,
    required bool unlocked,
    required int levelNumber,
  }) {
    return GestureDetector(
      onTap: unlocked
          ? () => Navigator.pushNamed(context, route)
              .then((_) => _loadUnlockedLevels())
          : null,
      child: Container(
        padding: const EdgeInsets.all(14),
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
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    desc,
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
                child: const Icon(Icons.play_arrow_rounded, color: Colors.white),
              ),
          ],
        ),
      ),
    );
  }
}
