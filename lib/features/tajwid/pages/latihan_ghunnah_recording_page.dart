import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatihanGhunnahRecordingPage extends StatefulWidget {
  const LatihanGhunnahRecordingPage({super.key});

  @override
  State<LatihanGhunnahRecordingPage> createState() =>
      _LatihanGhunnahRecordingPageState();
}

class _LatihanGhunnahRecordingPageState extends State<LatihanGhunnahRecordingPage> {
  bool _isRecording = false;
  bool _hasAudio = false;
  int ayatIndex = 0;

  final List<List<TextSpan>> ayatList = [
    // Ghunnah Nun Tasydid
    [
      const TextSpan(text: "إِنَّ"),
      const TextSpan(
        text: " اللَّهَ",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
    // Ghunnah Mim Tasydid
    [
      const TextSpan(text: "ثُمَّ"),
      const TextSpan(
        text: " إِلَيْنَا",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
    // Ghunnah Ikhfa Nun
    [
      const TextSpan(text: "مِنْ"),
      const TextSpan(
        text: " نُورٍ",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
    // Ghunnah Idgham
    [
      const TextSpan(text: "مَن"),
      const TextSpan(
        text: " يَعْمَلْ",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
  ];

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

  void _nextAyat() {
    if (ayatIndex < ayatList.length - 1) {
      setState(() {
        ayatIndex++;
        _hasAudio = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Latihan Selesai"),
          content: Text(
            "Kamu sudah mencoba semua contoh hukum Ghunnah.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42C88A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup"),
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final ayat = ayatList[ayatIndex];

    return Scaffold(
      appBar: AppBar(title: const Text("Latihan Ghunnah (Recording)")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Box kuning deskripsi
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    "Latihan membaca hukum Ghunnah dengan praktek suara.\n"
                    "Tekan tombol mic untuk mulai rekam, lalu putar dan nilai bacaanmu.\n"
                    "Setiap ayat menampilkan contoh Ghunnah (Nun/Mim tasydid, Ikhfa, Idgham).",
                    style: GoogleFonts.poppins(fontSize: 13, height: 1.4),
                  ),
                ),

                const SizedBox(height: 20),

                // Ayat contoh di tengah & besar dengan highlight
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                      children: ayat,
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                // Tombol rekam
                Center(
                  child: GestureDetector(
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
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    _isRecording ? "Sedang merekam..." : "Tap untuk rekam",
                    style: GoogleFonts.poppins(fontSize: 13),
                  ),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E60CE),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text("Nilai Pengucapan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _nextAyat,
                        icon: const Icon(Icons.navigate_next),
                        label: const Text("Lanjut Ayat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42C88A),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          // Background full width di bawah
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              "assets/images/background-mengaji.png",
              fit: BoxFit.cover,
              height: 100,
            ),
          ),
        ],
      ),
    );
  }
}
