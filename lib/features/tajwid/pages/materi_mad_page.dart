import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class MateriMadPage extends StatefulWidget {
  const MateriMadPage({super.key});

  @override
  State<MateriMadPage> createState() => _MateriMadPageState();
}

class _MateriMadPageState extends State<MateriMadPage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPlaying;

  Future<void> _playAudio(String fileName) async {
    if (_currentPlaying == fileName) {
      await _player.stop();
      setState(() => _currentPlaying = null);
    } else {
      await _player.play(AssetSource("audio/tajwid/mad-$fileName.mp3"));
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
      appBar: const CustomGradientAppBar(title: "Mad (Panjang Bacaan)"),
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
                    title: "Mad Thabi’i",
                    description: "Mad asli, panjang 2 harakat. Terjadi bila ada huruf mad (ا، و، ي) tanpa hamzah/sukun setelahnya.",
                    example: "قَالَ",
                    highlight: ["ا"],
                    audioFile: "thabi-i",
                  ),
                  _hukumCard(
                    title: "Mad Wajib Muttashil",
                    description: "Mad 4–5 harakat, terjadi bila huruf mad bertemu hamzah dalam satu kata.",
                    example: "جَاءَ",
                    highlight: ["ا", "ء"],
                    audioFile: "wajib-muttashil",
                  ),
                  _hukumCard(
                    title: "Mad Jaiz Munfashil",
                    description: "Mad 4–5 harakat, terjadi bila huruf mad di akhir kata bertemu hamzah di awal kata berikutnya.",
                    example: "فِيٓ أَنفُسِكُمْ",
                    highlight: ["ي", "أ"],
                    audioFile: "jaiz-munfashil",
                  ),
                  _hukumCard(
                    title: "Mad ‘Aridh Lissukun",
                    description: "Mad 2, 4, atau 6 harakat, terjadi bila huruf mad diakhiri sukun karena waqaf.",
                    example: "الْعَالَمِينْ",
                    highlight: ["يْ"],
                    audioFile: "aridh-lissukun",
                  ),
                  _hukumCard(
                    title: "Mad Lin",
                    description: "Mad 2, 4, atau 6 harakat, terjadi bila huruf lin (و، ي setelah huruf berharakat fathah) diakhiri sukun karena waqaf.",
                    example: "خَوْفْ",
                    highlight: ["وْ"],
                    audioFile: "lin",
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),

            // 👉 background mengaji ikut scroll, full width
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
        "Mad berarti panjang bacaan. Terjadi bila ada huruf mad (ا، و، ي) atau huruf lin, "
        "dan dibaca lebih panjang sesuai jenisnya. Ada beberapa macam: Mad Thabi’i, Wajib Muttashil, Jaiz Munfashil, ‘Aridh Lissukun, dan Mad Lin.",
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
