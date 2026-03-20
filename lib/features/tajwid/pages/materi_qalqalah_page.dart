import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';

class MateriQalqalahPage extends StatefulWidget {
  const MateriQalqalahPage({super.key});

  @override
  State<MateriQalqalahPage> createState() => _MateriQalqalahPageState();
}

class _MateriQalqalahPageState extends State<MateriQalqalahPage> {
  final AudioPlayer _player = AudioPlayer();
  String? _currentPlaying;

  Future<void> _playAudio(String fileName) async {
    if (_currentPlaying == fileName) {
      await _player.stop();
      setState(() => _currentPlaying = null);
    } else {
      await _player.play(AssetSource("audio/tajwid/qalqalah-$fileName.mp3"));
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
      appBar: const CustomGradientAppBar(title: "Qalqalah"),
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
                    title: "Qalqalah Kubra",
                    description: "Pantulan suara kuat pada huruf qalqalah (ق، ط، ب، ج، د) bila di akhir bacaan (waqaf).",
                    example: "يَجْعَلْ",
                    highlight: ["جْ", "لْ"],
                    audioFile: "kubra",
                  ),
                  _hukumCard(
                    title: "Qalqalah Sughra",
                    description: "Pantulan suara ringan pada huruf qalqalah bila di tengah bacaan.",
                    example: "يَقْطَعُونَ",
                    highlight: ["قْ", "طْ"],
                    audioFile: "sughra",
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
        "Qalqalah berarti memantulkan suara. Terjadi pada huruf ب، ج، د، ط، ق ketika berharakat sukun. "
        "Ada dua jenis: Qalqalah Sughra (di tengah bacaan) dan Qalqalah Kubra (di akhir bacaan saat waqaf).",
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
