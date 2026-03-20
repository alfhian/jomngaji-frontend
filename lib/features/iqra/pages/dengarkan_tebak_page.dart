import 'dart:io';
import 'dart:math';
import 'dart:ui';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import '../../../services/progress_service.dart';

class DengarkanTebakPage extends StatefulWidget {
  const DengarkanTebakPage({super.key});

  @override
  _DengarkanTebakPageState createState() => _DengarkanTebakPageState();
}

class _DengarkanTebakPageState extends State<DengarkanTebakPage> {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _isPlaying = false;
  bool _challengeMode = true;
  bool challengeFinished = false;

  int _currentQuestionIndex = 1;
  int _correctCount = 0;

  late ConfettiController _confettiController;

  String _feedback = "";

  // ============================================================
  //  FULL HURUF HIJAIYAH
  // ============================================================
  final List<Map<String, String>> audioList = [
    {"audio": "fatah_a.mp3", "arab": "اَ"},
    {"audio": "fatah_ba.mp3", "arab": "بَ"},
    {"audio": "fatah_ta.mp3", "arab": "تَ"},
    {"audio": "fatah_tsa.mp3", "arab": "ثَ"},
    {"audio": "fatah_ja.mp3", "arab": "جَ"},
    {"audio": "fatah_ha.mp3", "arab": "حَ"},
    {"audio": "fatah_ka.mp3", "arab": "خَ"},
    {"audio": "fatah_da.mp3", "arab": "دَ"},
    {"audio": "fatah_dza.mp3", "arab": "ذَ"},
    {"audio": "fatah_ra.mp3", "arab": "رَ"},
    {"audio": "fatah_za.mp3", "arab": "زَ"},
    {"audio": "fatah_sa.mp3", "arab": "سَ"},
    {"audio": "fatah_sya.mp3", "arab": "شَ"},
    {"audio": "fatah_sho.mp3", "arab": "صَ"},
    {"audio": "fatah_dho.mp3", "arab": "ضَ"},
    {"audio": "fatah_tho.mp3", "arab": "طَ"},
    {"audio": "fatah_dzo.mp3", "arab": "ظَ"},
    {"audio": "fatah_aa.mp3", "arab": "عَ"},
    {"audio": "fatah_gho.mp3", "arab": "غَ"},
    {"audio": "fatah_fa.mp3", "arab": "فَ"},
    {"audio": "fatah_qo.mp3", "arab": "قَ"},
    {"audio": "fatah_ka.mp3", "arab": "كَ"},
    {"audio": "fatah_la.mp3", "arab": "لَ"},
    {"audio": "fatah_ma.mp3", "arab": "مَ"},
    {"audio": "fatah_na.mp3", "arab": "نَ"},
    {"audio": "fatah_haa.mp3", "arab": "هَ"},
    {"audio": "fatah_wa.mp3", "arab": "وَ"},
    {"audio": "fatah_ya.mp3", "arab": "يَ"},
  ];

  late Map<String, String> _question;
  List<String> options = [];

  @override
  void initState() {
    super.initState();
    _player.openPlayer();
    _confettiController =
        ConfettiController(duration: const Duration(milliseconds: 900));
    _generateQuestion();
  }

  // ============================================================
  // Random soal + opsi
  // ============================================================
  void _generateQuestion() {
    final random = Random();
    _question = audioList[random.nextInt(audioList.length)];

    options = [_question["arab"]!];

    while (options.length < 3) {
      final pick =
          audioList[random.nextInt(audioList.length)]["arab"]!;
      if (!options.contains(pick)) options.add(pick);
    }

    options.shuffle();

    _feedback = "";
    setState(() {});
  }

  // ============================================================
  // LOAD audio into temp
  // ============================================================
  Future<String> loadAsset(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final file = File(
        '${(await getTemporaryDirectory()).path}/${assetPath.split("/").last}');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    return file.path;
  }

  // ============================================================
  // Play Audio
  // ============================================================
  void _playAudio() async {
    setState(() => _isPlaying = true);

    final path =
        await loadAsset("assets/audio/huruf/${_question["audio"]}");

    await _player.startPlayer(
      fromURI: path,
      whenFinished: () => setState(() => _isPlaying = false),
    );
  }

  // ============================================================
  // CEK JAWABAN → Confetti → XP → Challenge next
  // ============================================================
  void _checkAnswer(String selected) async {
    if (challengeFinished) return; // prevent bug 11/10

    if (selected == _question["arab"]) {
      _confettiController.play();
      setState(() => _feedback = "Benar! 🎉");
      _correctCount++;

      int xp = await ProgressService.getXP();
      await ProgressService.saveXP(xp + 5);

      // CHALLENGE FINISHED
      if (_challengeMode && _currentQuestionIndex >= 10) {
        challengeFinished = true;
        Future.delayed(const Duration(milliseconds: 900), () {
          _showResultDialog();
        });
        return;
      }

      _currentQuestionIndex++;
      Future.delayed(const Duration(milliseconds: 700), () {
        _generateQuestion();
      });

    } else {
      setState(() => _feedback = "Salah 😢");
    }
  }

  // ============================================================
  // SHOW RESULT (Dialog)
  // ============================================================
  void _showResultDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.45),
      transitionDuration: const Duration(milliseconds: 350),
      pageBuilder: (_, __, ___) {
        return const SizedBox.shrink();
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedValue = Curves.easeOut.transform(animation.value);

        return Transform.scale(
          scale: curvedValue,
          child: Opacity(
            opacity: curvedValue,
            child: Stack(
              alignment: Alignment.center,
              children: [

                // =========================================================
                // MINI CONFETTI
                // =========================================================
                ConfettiWidget(
                  confettiController: _confettiController,
                  blastDirection: -pi / 2,
                  maxBlastForce: 12,
                  minBlastForce: 6,
                  emissionFrequency: 0.12,
                  numberOfParticles: 14,
                  gravity: 0.4,
                ),

                // =========================================================
                // MAIN CARD
                // =========================================================
                ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // efek glass
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.82,
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.88), // semi-transparent untuk glass
                        borderRadius: BorderRadius.circular(26),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 18,
                            offset: Offset(0, 6),
                          )
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // MASCOT (Lottie)
                          SizedBox(
                            height: 130,
                            child: Lottie.asset("assets/lottie/celebrate.json"),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            "Bagus Sekali!",
                            style: GoogleFonts.poppins(
                              fontSize: 26,
                              fontWeight: FontWeight.w800,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 10),

                          Text(
                            "Benar: $_correctCount dari 10\n+ ${_correctCount * 5} XP",
                            style: GoogleFonts.poppins(
                              fontSize: 17,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 20),

                          // Tombol ULANGI
                          GestureDetector(
                            onTap: () {
                              challengeFinished = false;
                              _correctCount = 0;
                              _currentQuestionIndex = 1;
                              _generateQuestion();
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                                ),
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.blue.withOpacity(0.3),
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  "Ulangi Tantangan",
                                  style: GoogleFonts.poppins(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Tombol KEMBALI
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context); // tutup dialog
                              Navigator.pop(context); // kembali ke halaman sebelumnya
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Kembali",
                                style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }


  @override
  void dispose() {
    _player.closePlayer();
    _confettiController.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F8FF),
      body: SafeArea(
        child: Stack(
          children: [
            // =========================================================
            // BACKGROUND TOP GRADIENT
            // =========================================================
            Container(
              height: 200,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF60A5FA), Color(0xFF2563EB)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),

            // =========================================================
            // MAIN CONTENT
            // =========================================================
            Column(
              children: [
                // ===========================================
                // MASCOT
                // ===========================================
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Center(
                    child: Image.asset(
                      "assets/images/mascot.png",
                      height: 100,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ===========================================
                // PROGRESS BAR
                // ===========================================
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Soal $_currentQuestionIndex dari 10",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: LinearProgressIndicator(
                          value: _currentQuestionIndex / 10,
                          minHeight: 10,
                          backgroundColor: Colors.white.withOpacity(0.3),
                          color: Colors.greenAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ===========================================
                // WHITE CARD BODY
                // ===========================================
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 14,
                          offset: Offset(0, -3),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        // ===========================================
                        // PLAY BUTTON — DOULINGO STYLE
                        // ===========================================
                        GestureDetector(
                          onTap: _isPlaying ? null : _playAudio,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 40, vertical: 28),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: _isPlaying
                                    ? [Color(0xFF4ADE80), Color(0xFF22C55E)]
                                    : [Color(0xFF60A5FA), Color(0xFF2563EB)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(28),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade200,
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _isPlaying
                                      ? Icons.volume_up_rounded
                                      : Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  _isPlaying ? "Memutar..." : "Dengarkan",
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 35),

                        // ===========================================
                        // MULTIPLE CHOICE CENTERED
                        // ===========================================
                        Center(
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 18,
                            runSpacing: 18,
                            children: options.map((opt) {
                              return GestureDetector(
                                onTap: () => _checkAnswer(opt),
                                child: AnimatedContainer(
                                  duration:
                                      const Duration(milliseconds: 250),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 28, vertical: 20),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(18),
                                    border: Border.all(
                                      color: Colors.black12,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.07),
                                        blurRadius: 12,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    opt,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ===========================================
                        // FEEDBACK TEXT
                        // ===========================================
                        Text(
                          _feedback,
                          style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: _feedback.contains("Benar")
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // =========================================================
            // CONFETTI TOP CENTER
            // =========================================================
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirection: -pi / 2,
                gravity: 0.4,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.orange,
                  Colors.red
                ],
                emissionFrequency: 0.15,
                numberOfParticles: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
