import 'package:flutter/material.dart';

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../features/iqra/widgets/animated_iqra_card.dart';
import '../../../routes/app_routes.dart';

class TilawahMenuPage extends StatelessWidget {
  const TilawahMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: 'Tilawah Dasar'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFF1F7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _heroCard(),
            const SizedBox(height: 18),
            _levelItem(
              context,
              color: const Color(0xFFEAF3FF),
              iconColor: const Color(0xFF2563EB),
              title: 'Tingkatan 1 — Pemula',
              subtitle: 'Fokus kelancaran dasar tilawah dan adab membaca.',
              icon: Icons.looks_one_rounded,
              description:
                  'Mulai dengan bacaan pendek, tempo pelan, dan fokus makhraj dasar.',
            ),
            _levelItem(
              context,
              color: const Color(0xFFECFDF3),
              iconColor: const Color(0xFF16A34A),
              title: 'Tingkatan 2 — Menengah',
              subtitle: 'Perkuat tartil, waqaf-ibtida, dan kestabilan ritme.',
              icon: Icons.looks_two_rounded,
              description:
                  'Latihan ayat lebih panjang dengan konsistensi hukum tajwid.',
            ),
            _levelItem(
              context,
              color: const Color(0xFFFFFBEB),
              iconColor: const Color(0xFFF59E0B),
              title: 'Tingkatan 3 — Mahir',
              subtitle: 'Uji ketepatan bacaan dan kepercayaan diri tilawah.',
              icon: Icons.looks_3_rounded,
              description:
                  'Simulasi tilawah lengkap dengan evaluasi pengucapan lanjutan.',
            ),
          ],
        ),
      ),
    );
  }

  Widget _heroCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          colors: [Color(0xFF155EEF), Color(0xFF0EA5E9)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Belajar Tilawah Bertahap',
            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 6),
          Text(
            'Pilih 3 tingkatan pembelajaran tilawah. Di setiap tingkat tersedia latihan soal interaktif dan praktek bacaan tilawah.',
            style: TextStyle(color: Colors.white, fontSize: 13, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _levelItem(
    BuildContext context, {
    required Color color,
    required Color iconColor,
    required String title,
    required String subtitle,
    required IconData icon,
    required String description,
  }) {
    return AnimatedIqraCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => _TilawahLevelPage(
            title: title,
            description: description,
            color: color,
          ),
        ),
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: iconColor),
          ],
        ),
      ),
    );
  }
}

class _TilawahLevelPage extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const _TilawahLevelPage({
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomGradientAppBar(title: title),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF8FBFF), Color(0xFFF1F7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                color: color,
              ),
              child: Text(
                description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF334155),
                  height: 1.45,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _activityItem(
              context,
              color: const Color(0xFFEAF3FF),
              iconColor: const Color(0xFF2563EB),
              title: 'Latihan Soal Interaktif',
              subtitle: 'Uji pemahaman bacaan tilawah lewat soal pilihan.',
              icon: Icons.quiz_rounded,
              route: AppRoutes.latihanTilawahPilihan,
            ),
            _activityItem(
              context,
              color: const Color(0xFFFFF1F2),
              iconColor: const Color(0xFFE11D48),
              title: 'Praktek Bacaan Tilawah',
              subtitle: 'Rekam suara untuk melatih kelancaran dan pelafalan.',
              icon: Icons.record_voice_over_rounded,
              route: AppRoutes.latihanTilawahRecording,
            ),
          ],
        ),
      ),
    );
  }

  Widget _activityItem(
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
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(color: Color(0x12000000), blurRadius: 12, offset: Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, size: 24, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, size: 16, color: iconColor),
          ],
        ),
      ),
    );
  }
}
