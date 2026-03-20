import 'package:flutter/material.dart';
import '../../../../routes/app_routes.dart';
import '../widgets/animated_tajwid_card.dart';
import '../../../../core/widgets/custom_gradient_appbar.dart';

class TajwidDasarPage extends StatelessWidget {
  const TajwidDasarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Tajwid Dasar"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _sectionTitle("Belajar Tajwid"),
          const SizedBox(height: 15),

          _tajwidItem(
            context,
            color: const Color(0xFFE3F2FD),
            iconColor: const Color(0xFF2196F3),
            title: "Teori Tajwid",
            subtitle: "Penjelasan hukum bacaan seperti Idgham, Ikhfa, Iqlab, dll.",
            icon: Icons.menu_book_rounded,
            route: AppRoutes.materiTajwid,
          ),

          _tajwidItem(
            context,
            color: const Color(0xFFFFEBEE),
            iconColor: const Color(0xFFE53935),
            title: "Latihan Tajwid",
            subtitle: "Soal interaktif untuk mengenali hukum bacaan",
            icon: Icons.edit_rounded,
            route: AppRoutes.latihanTajwid,
          ),

          _tajwidItem(
            context,
            color: const Color(0xFFE8F5E9),
            iconColor: const Color(0xFF43A047),
            title: "Tes Akhir",
            subtitle: "Uji pemahaman tajwid kamu",
            icon: Icons.quiz_rounded,
            route: AppRoutes.examTajwid,
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _tajwidItem(
    BuildContext context, {
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required IconData icon,
    required String route,
  }) {
    return AnimatedTajwidCard(
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
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      )),
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
            const Icon(Icons.chevron_right_rounded, size: 30, color: Colors.black26),
          ],
        ),
      ),
    );
  }
}
