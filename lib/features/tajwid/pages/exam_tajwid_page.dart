import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../services/progress_service.dart';

class ExamTajwidPage extends StatefulWidget {
  const ExamTajwidPage({super.key});

  @override
  State<ExamTajwidPage> createState() => _ExamTajwidPageState();
}

class _ExamTajwidPageState extends State<ExamTajwidPage> {
  // =========================
  // Data soal pilihan ganda
  // =========================
  final List<Map<String, String>> examQuestions = [
    {"ar": "قَالَ", "lat": "QAALA"},
    {"ar": "قَدْ أَفْلَحَ", "lat": "QAD AFLAHA"},
    {"ar": "إِنَّ اللَّهَ", "lat": "INNALLAH"},
  ];

  int currentIndex = 0;
  int score = 0;
  int totalXP = 0;
  List<String> options = [];

  // =========================
  // State exam (tahap recording)
  // =========================
  bool inRecordingStage = false;
  bool isRecording = false;
  bool hasAudio = false;
  int recordingIndex = 0;

  final List<List<TextSpan>> recordingAyatList = [
    // Contoh Ghunnah (Nun tasydid)
    [
      const TextSpan(text: "إِنَّ"),
      const TextSpan(
        text: " اللَّهَ",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
    // Contoh Ghunnah (Mim tasydid)
    [
      const TextSpan(text: "ثُمَّ"),
      const TextSpan(
        text: " إِلَيْنَا",
        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
      ),
    ],
  ];

  @override
  void initState() {
    super.initState();
    generateOptions();
  }

  // =========================
  // Pilihan ganda helpers
  // =========================
  void generateOptions() {
    final random = Random();
    final correct = examQuestions[currentIndex]["lat"]!;
    options = [correct];

    while (options.length < 3) {
      final randomOpt =
          examQuestions[random.nextInt(examQuestions.length)]["lat"]!;
      if (!options.contains(randomOpt)) options.add(randomOpt);
    }
    options.shuffle();
    setState(() {});
  }

  void answer(String selected) async {
    final correct = examQuestions[currentIndex]["lat"]!;
    if (selected == correct) {
      score++;
      totalXP += 10;
    }

    if (currentIndex == examQuestions.length - 1) {
      // selesai pilihan ganda → masuk recording stage
      setState(() {
        inRecordingStage = true;
      });
      return;
    }

    currentIndex++;
    generateOptions();
  }

  // =========================
  // Recording helpers
  // =========================
  void toggleRecording() {
    setState(() {
      if (isRecording) {
        isRecording = false;
        hasAudio = true; // selesai rekam (dummy)
      } else {
        isRecording = true;
      }
    });
  }

  void nextRecording() async {
    if (recordingIndex < recordingAyatList.length - 1) {
      setState(() {
        recordingIndex++;
        hasAudio = false;
      });
    } else {
      // selesai semua tahap → simpan progress & tampilkan hasil
      await ProgressService.saveExamScore(score);
      await ProgressService.saveXP(totalXP);
      showResult();
    }
  }

  void showResult() {
    String feedbackMessage;
    if (score == examQuestions.length) {
      feedbackMessage = "🎉 LULUS! Semua jawaban benar, kamu luar biasa!";
    } else if (score > examQuestions.length / 2) {
      feedbackMessage = "Bagus! Jawaban kamu lebih banyak benar. Terus belajar!";
    } else {
      feedbackMessage = "Perlu latihan lagi 😊. Jangan menyerah, kamu bisa!";
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          "Tes Selesai!",
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        content: Text(
          "Skor pilihan ganda: $score dari ${examQuestions.length}\n+ $totalXP XP\n\n$feedbackMessage",
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
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text("Kembali"),
          ),
        ],
      ),
    );
  }

  // =========================
  // UI builders
  // =========================
  Widget buildOption(String text) {
    return GestureDetector(
      onTap: () => answer(text),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF42C88A),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String desc) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4), // kuning pastel
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF5D4037),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black87,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBackgroundImage() {
    return SizedBox(
      width: double.infinity,
      child: Image.asset(
        "assets/images/background-mengaji.png",
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Tes Akhir Tajwid"),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: inRecordingStage ? buildRecordingStage() : buildPilihanGandaStage(),
            ),
          ),
          buildBackgroundImage(),
        ],
      ),
    );
  }

  // =========================
  // Stage Pilihan Ganda
  // =========================
  Widget buildPilihanGandaStage() {
    final data = examQuestions[currentIndex];
    return Column(
      children: [
        buildInfoCard(
          "Tahap Pilihan Ganda",
          "Tahap pertama adalah soal pilihan ganda untuk menguji pemahaman hukum bacaan.",
        ),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: (currentIndex + 1) / examQuestions.length,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFF42C88A),
          minHeight: 8,
        ),
        const SizedBox(height: 18),
        Text(
          "Baca bacaan berikut:",
          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFDFD),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
            ],
          ),
          child: Center(
            child: Text(
              data["ar"]!,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 42,
                color: Color(0xFF42C88A),
                fontWeight: FontWeight.bold,
                height: 1.6,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView.separated(
            itemCount: options.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) => buildOption(options[i]),
          ),
        ),
      ],
    );
  }

  // =========================
  // Stage Recording
  // =========================
  Widget buildRecordingStage() {
    final ayat = recordingAyatList[recordingIndex];
    return Column(
      children: [
        buildInfoCard(
          "Tahap Recording",
          "Tahap kedua adalah praktek bacaan dengan suara. Tekan mic untuk rekam.",
        ),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: (recordingIndex + 1) / recordingAyatList.length,
          backgroundColor: Colors.grey[300],
          color: const Color(0xFF42C88A),
          minHeight: 8,
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
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
        const SizedBox(height: 24),
        // Tombol mic + status
        GestureDetector(
          onTap: toggleRecording,
          child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              color: isRecording ? Colors.red : const Color(0xFF42C88A),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 6),
              ],
            ),
            child: Icon(
              isRecording ? Icons.stop : Icons.mic,
              color: Colors.white,
              size: 38,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          isRecording ? "Sedang merekam..." : "Tap untuk rekam",
          style: GoogleFonts.poppins(fontSize: 13),
        ),
        const SizedBox(height: 18),
        // Playback + evaluasi + next
        if (hasAudio)
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
                onPressed: nextRecording,
                icon: const Icon(Icons.navigate_next),
                label: const Text("Lanjut Soal"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42C88A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        const SizedBox(height: 8),
        // Spacer agar tombol tidak mepet bawah saat belum ada rekaman
        if (!hasAudio) const Spacer(),
      ],
    );
  }
}
