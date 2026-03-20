import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class MateriNunTanwinPage extends StatefulWidget {
  const MateriNunTanwinPage({super.key});

  @override
  State<MateriNunTanwinPage> createState() => _MateriNunTanwinPageState();
}

class _MateriNunTanwinPageState extends State<MateriNunTanwinPage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPlaying;

  Future<void> _playAudio(String fileName) async {
    if (_currentPlaying == fileName) {
      await _player.stop();
      setState(() => _currentPlaying = null);
    } else {
      await _player.play(AssetSource("audio/tajwid/nun-tanwin-$fileName.mp3"));
      setState(() => _currentPlaying = fileName);

      _player.onPlayerComplete.listen((_) {
        setState(() => _currentPlaying = null);
      });
    }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F7FF),
      appBar: const CustomGradientAppBar(title: "Hukum Nun Mati & Tanwin"),
      body: SafeArea(
        child: ListView(
          children: [
            // konten utama dengan padding
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _introCard(),
                  const SizedBox(height: 20),

                  _hukumCard(
                    title: "Idzhar",
                    description: "Nun mati atau tanwin dibaca jelas saat bertemu huruf tenggorokan (ء، هـ، ع، ح، غ، خ).",
                    example: "مِنْهُمْ",
                    highlight: ["نْ", "ه"],
                    audioFile: "idzhar",
                  ),
                  _hukumCard(
                    title: "Idgham",
                    description: "Nun mati atau tanwin dilebur ke huruf setelahnya.",
                    example: "مَنْ يَقُولُ",
                    highlight: ["نْ", "ي"],
                    audioFile: "idgham",
                  ),
                  _hukumCard(
                    title: "Iqlab",
                    description: "Nun mati atau tanwin diganti menjadi mim saat bertemu huruf ب.",
                    example: "أَنْبِيَاءَ",
                    highlight: ["ن", "ب"],
                    audioFile: "iqlab",
                  ),
                  _hukumCard(
                    title: "Ikhfa",
                    description: "Nun mati atau tanwin dibaca samar saat bertemu huruf Ikhfa (15 huruf).",
                    example: "مِنْ رَبِّهِمْ",
                    highlight: ["نْ", "ر"],
                    audioFile: "ikhfa",
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // 👉 background mengaji ikut scroll, full width tanpa padding
            Image.asset(
              "assets/images/background-mengaji.png",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 120,
            ),
          ],
        ),
      ),
    );
  }



  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        "Hukum Nun Mati & Tanwin berlaku saat nun sukun (نْ) atau tanwin (ــًــٍــٌ) bertemu huruf hijaiyah lain. "
        "Ada 4 jenis hukum: Idzhar, Idgham, Iqlab, dan Ikhfa.",
        style: GoogleFonts.poppins(fontSize: 13, height: 1.4),
      ),
    );
  }

  Widget _hukumCard({
    required String title,
    required String description,
    required String example,
    required List<String> highlight,
    required String audioFile,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1FFF6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w700, color: const Color(0xFF2E7D32))),
          const SizedBox(height: 6),
          Text(description,
              style: GoogleFonts.poppins(fontSize: 13, color: Colors.black87, height: 1.4)),
          const SizedBox(height: 10),
          RichText(
            text: TextSpan(
              style: GoogleFonts.poppins(fontSize: 18, color: Colors.black87),
              children: _buildHighlightedText(example, highlight),
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => _playAudio(audioFile),
            icon: Icon(_currentPlaying == audioFile ? Icons.stop : Icons.play_arrow),
            label: Text(_currentPlaying == audioFile ? "Stop Audio" : "Putar Audio"),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF42C88A),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  List<TextSpan> _buildHighlightedText(String text, List<String> highlight) {
    final spans = <TextSpan>[];
    for (int i = 0; i < text.length; i++) {
      final char = text[i];
      final match = highlight.any((h) => h.contains(char));
      spans.add(TextSpan(
        text: char,
        style: TextStyle(
          color: match ? const Color(0xFF42C88A) : Colors.black87,
          fontWeight: match ? FontWeight.bold : FontWeight.normal,
        ),
      ));
    }
    return spans;
  }
}
