import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../routes/app_routes.dart';
import '../data/doa_data.dart';
import '../../../models/doa.dart';

class DoaMenuPage extends StatelessWidget {
  const DoaMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: ListView(
        children: [
          _heroSection(context),
          const SizedBox(height: 20),
          _descriptionSection(),
          const SizedBox(height: 25),
          _doaList(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // =========================================================
  // HERO SECTION (SAMA DENGAN MATERI HIJAIYAH)
  // =========================================================
  Widget _heroSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: DecorationImage(
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
                child: const Icon(Icons.arrow_back,
                    color: Colors.white, size: 20),
              ),
            ),

            const SizedBox(height: 28),

            Text(
              "Kumpulan Doa",
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              "Doa Sehari-hari",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 32,
                height: 1.25,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Baca & Dengarkan",
                style: GoogleFonts.poppins(
                  color: Colors.green.shade700,
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
  // DESCRIPTION
  // =========================================================
  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Kumpulan doa harian lengkap dengan bacaan Arab, latin, arti, dan audio.",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            "${doaList.length} Doa",
            style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  // =========================================================
  // DOA LIST (SAMA CARD STYLE)
  // =========================================================
  Widget _doaList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: List.generate(doaList.length, (index) {
          final Doa doa = doaList[index];

          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.doaDetail,
                arguments: doa,
              );
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 14),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: const Color(0xFFE7FFF2),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.menu_book_rounded,
                    size: 26,
                    color: Color(0xFF50D1A0),
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Text(
                      doa.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF50D1A0),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
