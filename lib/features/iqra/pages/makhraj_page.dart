import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MakhrajPage extends StatefulWidget {
  const MakhrajPage({super.key});

  @override
  State<MakhrajPage> createState() => _MakhrajPageState();
}

class _MakhrajPageState extends State<MakhrajPage> {
  int currentIndex = 0;
  final List<String> hurufList = ["ب", "ت", "ث", "ج", "ح"];
  String feedback = "";

  @override
  Widget build(BuildContext context) {
    final currentHuruf = hurufList[currentIndex];
    final progress = (currentIndex + 1) / hurufList.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: null,
      body: ListView(
        children: [
          _heroSection(context),
          const SizedBox(height: 18),
          _descriptionSection(),
          const SizedBox(height: 18),
          _progressSection(progress),
          const SizedBox(height: 18),
          _makhrajInfoCard(),
          const SizedBox(height: 18),
          _latihanCards(currentHuruf),
          const SizedBox(height: 28),
        ],
      ),
    );
  }

  Widget _heroSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/hijaiyah_banner_2.png'),
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
              Colors.black.withOpacity(0.42),
            ],
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 36),
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
            const SizedBox(height: 24),
            Text(
              'Latihan Pengucapan',
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Makhraj Huruf\nHijaiyah',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 31,
                height: 1.2,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _descriptionSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        'Belajar mengucapkan huruf hijaiyah sesuai tempat keluarnya suara agar bacaan lebih fasih.',
        style: GoogleFonts.poppins(fontSize: 14, color: Colors.black87),
      ),
    );
  }

  Widget _progressSection(double progress) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress Latihan',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.grey.shade300,
              color: const Color(0xFF50D1A0),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${(progress * 100).toInt()}% selesai',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.black54),
          ),
        ],
      ),
    );
  }

  Widget _makhrajInfoCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF8E6),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFFECB3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.record_voice_over_rounded, color: Color(0xFF8D6E63)),
                const SizedBox(width: 8),
                Text(
                  'Apa itu Makhraj?',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF6D4C41),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'Makhraj adalah tempat keluarnya huruf saat diucapkan (misalnya dari tenggorokan, lidah, atau bibir). '
              'Memahami makhraj membantu pengucapan huruf jadi jelas dan benar.',
              style: GoogleFonts.poppins(
                fontSize: 13,
                height: 1.45,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _latihanCards(String currentHuruf) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          ...List.generate(hurufList.length, (i) {
            final active = i == currentIndex;
            return GestureDetector(
              onTap: () => setState(() => currentIndex = i),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: active ? const Color(0xFFE7FFF2) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? const Color(0xFF50D1A0) : Colors.grey.shade300,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: active
                          ? const Color(0xFF50D1A0)
                          : Colors.grey.shade300,
                      child: Text(
                        hurufList[i],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Text(
                        'Latihan huruf ${hurufList[i]}',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    Icon(
                      active ? Icons.play_circle_fill_rounded : Icons.chevron_right_rounded,
                      color: active ? const Color(0xFF50D1A0) : Colors.black45,
                    ),
                  ],
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              image: const DecorationImage(
                image: AssetImage('assets/images/background-mengaji.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: Colors.white.withOpacity(0.82),
              ),
              child: Column(
                children: [
                  Text(
                    'Huruf aktif: $currentHuruf',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF42C88A),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        feedback = 'Sedang merekam huruf $currentHuruf...';
                      });
                    },
                    icon: const Icon(Icons.mic_rounded),
                    label: Text(
                      'Mulai Rekam',
                      style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    feedback,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
