import 'package:flutter/material.dart';
import '../../../routes/app_routes.dart';
import '../widgets/animated_iqra_card.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class IqraDasarPage extends StatelessWidget {
  const IqraDasarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Iqra' Dasar"),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _sectionTitle("Belajar Iqra"),
          const SizedBox(height: 15),

          _iqraItem(
            context,
            color: const Color(0xFFEDE7FF),
            iconColor: const Color(0xFF7A49FF),
            title: "Huruf Hijaiyah",
            subtitle: "Belajar huruf hijaiyah dari Alif sampai Ya",
            icon: Icons.menu_book_rounded,
            route: AppRoutes.materiHijaiyah,
          ),

          _iqraItem(
            context,
            color: const Color(0xFFFFE4E9),
            iconColor: const Color(0xFFFF577F),
            title: "Latihan Baca",
            subtitle: "Harakat dasar & latihan suku kata",
            icon: Icons.edit_rounded,
            route: AppRoutes.latihanBaca,
          ),

          _iqraItem(
            context,
            color: const Color(0xFFE4FFF5),
            iconColor: const Color(0xFF20C997),
            title: "Pengucapan (Makhraj)",
            subtitle: "Latihan pelafalan huruf & makhraj",
            icon: Icons.record_voice_over_rounded,
            route: AppRoutes.pengucapan,
          ),

          _iqraItem(
            context,
            color: const Color(0xFFFFF4D8),
            iconColor: const Color(0xFFFFC107),
            title: "Tes Akhir",
            subtitle: "Uji kemampuan mengaji kamu",
            icon: Icons.quiz_rounded,
            route: AppRoutes.examIqra,
          ),

          const SizedBox(height: 25),
        ],
      ),
    );
  }

  // ================================
  // SECTION TITLE
  // ================================
  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // ================================
  // CUSTOM CARD ITEM
  // ================================
  Widget _iqraItem(
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
