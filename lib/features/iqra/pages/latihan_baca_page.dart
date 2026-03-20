import 'package:flutter/material.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../routes/app_routes.dart';
import '../widgets/animated_iqra_card.dart';

class LatihanBacaPage extends StatelessWidget {
  const LatihanBacaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Latihan Baca"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _sectionTitle("Latihan Dasar"),
          const SizedBox(height: 15),

          // --------------------------
          // LATIHAN HARAKAT
          // --------------------------
          _menuItem(
            context,
            color: const Color(0xFFEDE7FF),
            iconColor: const Color(0xFF7A49FF),
            title: "Latihan Harakat",
            subtitle: "Fathah, Kasrah, Dhammah",
            icon: Icons.menu_book_rounded,
            route: AppRoutes.latihanHarakat,
          ),

          // --------------------------
          // LATIHAN SUKU KATA
          // --------------------------
          _menuItem(
            context,
            color: const Color(0xFFFFE4E9),
            iconColor: const Color(0xFFFF577F),
            title: "Latihan Suku Kata",
            subtitle: "Gabungan huruf & harakat",
            icon: Icons.auto_stories_rounded,
            route: AppRoutes.latihanSukuKataMenu,
          ),

          // --------------------------
          // DENGARKAN & TEBAK
          // --------------------------
          _menuItem(
            context,
            color: const Color(0xFFE4FFF5),
            iconColor: const Color(0xFF20C997),
            title: "Dengarkan & Tebak",
            subtitle: "Tebak huruf dari audio",
            icon: Icons.volume_up_rounded,
            route: AppRoutes.latihanDengar,
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // --------------------------
  // SECTION TITLE
  // --------------------------
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // --------------------------
  // CUSTOM CARD ITEM (SAMA PERSIS DENGAN IQRA DASAR)
  // --------------------------
  Widget _menuItem(
    BuildContext context, {
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return AnimatedIqraCard(
      onTap: () => Navigator.pushNamed(context, route),
      child: Container(
        margin: const EdgeInsets.only(bottom: 18),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            // Icon Bubble
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow
            const Icon(
              Icons.chevron_right_rounded,
              size: 30,
              color: Colors.black26,
            ),
          ],
        ),
      ),
    );
  }
}
