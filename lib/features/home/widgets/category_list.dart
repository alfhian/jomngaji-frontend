import 'package:flutter/material.dart';
import 'package:tabler_icons/tabler_icons.dart';
import '../../../routes/app_routes.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ("Iqra' Dasar", TablerIcons.book_2, AppRoutes.iqraDasar),
      ("Tajwid", TablerIcons.microphone, AppRoutes.tajwidDasar),
      ("Tilawah", TablerIcons.wave_sine, AppRoutes.tilawahMenu),
      ("Tahfidz", TablerIcons.moon_stars, AppRoutes.tahfidzMenu),
    ];

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 14,
        crossAxisSpacing: 14,
        childAspectRatio: 1.15,
      ),
      itemCount: categories.length,
      itemBuilder: (context, i) {
        final (title, icon, route) = categories[i];
        return _stampCard(
          context,
          title: title,
          icon: icon,
          route: route,
        );
      },
    );
  }

  // ⭐ STAMP CARD DENGAN BACKGROUND IMAGE
  Widget _stampCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    String? route,
  }) {
    return GestureDetector(
      onTap: route != null
          ? () => Navigator.pushNamed(context, route)
          : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),

          // ⭐ Background Image
          image: const DecorationImage(
            image: AssetImage("assets/images/grid_stamp_background.png"),
            fit: BoxFit.cover,
          ),

          // ⭐ Border stamp
          border: Border.all(
            color: Colors.black.withOpacity(0.4),
            width: 1.4,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICON
            Icon(
              icon,
              size: 36,
              color: const Color(0xFF42C88A),
            ),

            const Spacer(),

            // TITLE
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 15,
                color: Colors.black87,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 4),

            // Garis stempel kecil
            Container(
              height: 2,
              width: 40,
              color: const Color(0xFF42C88A),
            )
          ],
        ),
      ),
    );
  }
}
