import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

// Model Ayah
class Ayah {
  final int number;
  final String text;
  Ayah({required this.number, required this.text});
}

// Model Surah
class Surah {
  final int number;
  final String name;
  final List<Ayah> ayahs;
  double progress;

  Surah({
    required this.number,
    required this.name,
    required this.ayahs,
    this.progress = 0.0,
  });
}

class TadarusDetailPage extends StatefulWidget {
  final Surah surah;

  const TadarusDetailPage({super.key, required this.surah});

  @override
  State<TadarusDetailPage> createState() => _TadarusDetailPageState();
}

class _TadarusDetailPageState extends State<TadarusDetailPage> {
  late double progressValue;

  @override
  void initState() {
    super.initState();
    progressValue = widget.surah.progress;
  }

  void _updateProgress(int ayahIndex) {
    setState(() {
      progressValue = (ayahIndex + 1) / widget.surah.ayahs.length;
      widget.surah.progress = progressValue;
    });
    // TODO: simpan progress ke backend
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomGradientAppBar(title: "Tadarus AI"),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _headerCard(widget.surah),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: widget.surah.ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = widget.surah.ayahs[index];
                  return GestureDetector(
                    onTap: () => _updateProgress(index),
                    child: _ayatCard(ayah.number, ayah.text),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _headerCard(Surah surah) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(surah.name,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2E8B57))),
          const SizedBox(height: 6),
          Text("Surah ke-${surah.number}, ${surah.ayahs.length} ayat",
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54)),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progressValue,
              backgroundColor: Colors.grey.shade300,
              minHeight: 10,
              color: const Color(0xFF42C88A),
            ),
          ),
          const SizedBox(height: 8),
          Text("${(progressValue * 100).toStringAsFixed(0)}% selesai",
              style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _ayatCard(int number, String arabic) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ayat $number",
              style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2E8B57))),
          const SizedBox(height: 8),
          Text(
            arabic,
            textAlign: TextAlign.right,
            style: GoogleFonts.amiri(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}
