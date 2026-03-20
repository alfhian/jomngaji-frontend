import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatihanMimMatiRecordingPage extends StatefulWidget {
  const LatihanMimMatiRecordingPage({super.key});

  @override
  State<LatihanMimMatiRecordingPage> createState() => _LatihanMimMatiRecordingPageState();
}

class _LatihanMimMatiRecordingPageState extends State<LatihanMimMatiRecordingPage> {
  bool _isRecording = false;
  bool _hasAudio = false;

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasAudio = true; // dummy selesai rekaman
      } else {
        _isRecording = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Latihan Mim Mati (Recording)")),
      body: Column(
        children: [
          // konten utama
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Box kuning deskripsi
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C4),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Text(
                      "Latihan membaca hukum Mim Mati dengan praktek suara.\n"
                      "Tekan tombol mic untuk mulai rekam, lalu putar dan nilai bacaanmu.",
                      style: GoogleFonts.poppins(fontSize: 13, height: 1.4),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Ayat contoh di tengah & besar
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(fontSize: 36, color: Colors.black),
                        children: [
                          TextSpan(text: "لَهُمْ "),
                          TextSpan(
                            text: "مَغْفِرَةٌ",
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Tombol rekam
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : const Color(0xFF42C88A),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isRecording ? Icons.stop : Icons.mic,
                        color: Colors.white,
                        size: 38,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isRecording ? "Sedang merekam..." : "Tap untuk rekam",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),

                  const SizedBox(height: 20),

                  // Tombol playback & evaluasi (dummy)
                  if (_hasAudio)
                    Column(
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow),
                          label: const Text("Putar rekaman"),
                          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF5E60CE)),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.auto_awesome),
                          label: const Text("Nilai Pengucapan"),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.orange.shade700),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),

          // 👉 gambar di paling bawah, tidak ikut scroll
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/background-mengaji.png",
              fit: BoxFit.cover,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
