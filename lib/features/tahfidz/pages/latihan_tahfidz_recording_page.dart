import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LatihanTahfidzRecordingPage extends StatefulWidget {
  const LatihanTahfidzRecordingPage({super.key});

  @override
  State<LatihanTahfidzRecordingPage> createState() =>
      _LatihanTahfidzRecordingPageState();
}

class _LatihanTahfidzRecordingPageState extends State<LatihanTahfidzRecordingPage> {
  bool _isRecording = false;
  bool _hasAudio = false;
  int ayatIndex = 0;

  final List<List<TextSpan>> ayatList = [
    [const TextSpan(text: "قُلْ هُوَ اللَّهُ أَحَدٌ")],
    [const TextSpan(text: "اللَّهُ الصَّمَدُ")],
    [const TextSpan(text: "إِنَّا أَعْطَيْنَاكَ الْكَوْثَرَ")],
  ];

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasAudio = true; // dummy selesai rekaman
      } else {
        _isRecording = true;
        _hasAudio = false;
      }
    });
  }

  void _nextAyat() {
    if (ayatIndex < ayatList.length - 1) {
      setState(() {
        ayatIndex++;
        _hasAudio = false;
        _isRecording = false;
      });
    } else {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Latihan Selesai"),
          content: Text(
            "Kamu sudah mencoba semua contoh hafalan.",
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42C88A),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      appBar: AppBar(title: const Text("Latihan Tahfidz (Recording)")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // Info card kuning
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
                    ],
                  ),
                  child: Text(
                    "Latihan hafalan dengan praktek suara.\n"
                    "Tekan tombol mic untuk mulai rekam, lalu putar dan nilai bacaanmu.",
                    style: GoogleFonts.poppins(fontSize: 13, height: 1.4),
                  ),
                ),

                const SizedBox(height: 18),

                // Progress
                LinearProgressIndicator(
                  value: (ayatIndex + 1) / ayatList.length,
                  backgroundColor: Colors.grey[300],
                  color: const Color(0xFF42C88A),
                  minHeight: 8,
                ),

                const SizedBox(height: 22),

                // Ayat besar
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDFDFD),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
                    ],
                  ),
                  child: Center(
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
                ),

                const SizedBox(height: 26),

                // Tombol mic
                Center(
                  child: GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: _isRecording ? Colors.red : const Color(0xFF42C88A),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
                        ],
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

                const SizedBox(height: 18),

                // Playback + evaluasi + next (muncul setelah rekaman selesai)
                if (_hasAudio)
                  Column(
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.play_arrow),
                        label: const Text("Putar rekaman"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF5E60CE),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.auto_awesome),
                        label: const Text("Nilai Pengucapan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange.shade700,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _nextAyat,
                        icon: const Icon(Icons.navigate_next),
                        label: const Text("Lanjut Ayat"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF42C88A),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
