import 'dart:convert';
import 'dart:io';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:jomngaji/models/evaluation_result.dart';
import 'package:jomngaji/services/evaluation_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../services/progress_service.dart';

class ExamTajwidPage extends StatefulWidget {
  const ExamTajwidPage({super.key});

  @override
  State<ExamTajwidPage> createState() => _ExamTajwidPageState();
}

enum _ExamType { mcq, pronunciation }

class _ExamQuestion {
  final _ExamType type;
  final String prompt;
  final String arabic;
  final List<String> options;
  final String correct;
  final String? targetPronunciation;
  final int? lessonId;

  const _ExamQuestion.mcq({
    required this.prompt,
    required this.arabic,
    required this.options,
    required this.correct,
  })  : type = _ExamType.mcq,
        targetPronunciation = null,
        lessonId = null;

  const _ExamQuestion.pronunciation({
    required this.prompt,
    required this.arabic,
    required this.targetPronunciation,
    required this.lessonId,
  })  : type = _ExamType.pronunciation,
        options = const [],
        correct = '';
}

class _ExamTajwidPageState extends State<ExamTajwidPage> {
  static const String _baseUrl = AuthService.baseUrl;

  final List<_ExamQuestion> _questions = const [
    _ExamQuestion.mcq(
      prompt: 'Pilih hukum tajwid yang tepat',
      arabic: 'مِنْ نُورٍ',
      options: ['Idzhar', 'Ikhfa', 'Iqlab'],
      correct: 'Idzhar',
    ),
    _ExamQuestion.pronunciation(
      prompt: 'Praktek bacaan',
      arabic: 'إِنَّ اللَّهَ',
      targetPronunciation: 'إِنَّ اللَّهَ',
      lessonId: 5,
    ),
    _ExamQuestion.mcq(
      prompt: 'Pilih hukum tajwid yang tepat',
      arabic: 'لَهُمْ مَغْفِرَةٌ',
      options: ['Idgham Mimi', 'Ikhfa Syafawi', 'Idzhar Syafawi'],
      correct: 'Idgham Mimi',
    ),
    _ExamQuestion.pronunciation(
      prompt: 'Praktek bacaan',
      arabic: 'قَدْ أَفْلَحَ',
      targetPronunciation: 'قَدْ أَفْلَحَ',
      lessonId: 4,
    ),
    _ExamQuestion.mcq(
      prompt: 'Pilih hukum tajwid yang tepat',
      arabic: 'جَاءَكُمْ',
      options: ['Mad Wajib Muttashil', 'Mad Thabi’i', 'Mad Lin'],
      correct: 'Mad Wajib Muttashil',
    ),
    _ExamQuestion.pronunciation(
      prompt: 'Praktek bacaan',
      arabic: 'مِنْ رَبِّهِمْ',
      targetPronunciation: 'مِنْ رَبِّهِمْ',
      lessonId: 1,
    ),
    _ExamQuestion.mcq(
      prompt: 'Pilih hukum tajwid yang tepat',
      arabic: 'أَنْبِئْهُمْ',
      options: ['Iqlab', 'Idgham', 'Ikhfa'],
      correct: 'Iqlab',
    ),
    _ExamQuestion.pronunciation(
      prompt: 'Praktek bacaan',
      arabic: 'وَمَنْ يَقُولُ',
      targetPronunciation: 'وَمَنْ يَقُولُ',
      lessonId: 1,
    ),
    _ExamQuestion.mcq(
      prompt: 'Pilih hukum tajwid yang tepat',
      arabic: 'يَدْخُلُونَ',
      options: ['Qalqalah Sughra', 'Qalqalah Kubra', 'Ghunnah'],
      correct: 'Qalqalah Sughra',
    ),
    _ExamQuestion.pronunciation(
      prompt: 'Praktek bacaan',
      arabic: 'إِنَّا أَعْطَيْنَاكَ',
      targetPronunciation: 'إِنَّا أَعْطَيْنَاكَ',
      lessonId: 5,
    ),
  ];

  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  late final EvaluationApi _api;
  late ConfettiController _resultConfetti;

  int _currentIndex = 0;
  int _mcqCorrect = 0;
  int _pronunciationPassed = 0;
  final List<double> _recordingScores = [];

  bool _answerLocked = false;
  String? _selectedOption;
  String _feedback = '';

  bool _recorderReady = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isEvaluating = false;
  String? _recordedPath;
  bool _pronunciationDone = false;

  @override
  void initState() {
    super.initState();
    _api = EvaluationApi(_baseUrl);
    _resultConfetti = ConfettiController(duration: const Duration(milliseconds: 900));
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    await Permission.microphone.request();
    await Permission.storage.request();

    if (!await Permission.microphone.isGranted) return;

    await _recorder.openRecorder();
    await _player.openPlayer();

    if (mounted) setState(() => _recorderReady = true);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    _api.dispose();
    _resultConfetti.dispose();
    super.dispose();
  }

  _ExamQuestion get _q => _questions[_currentIndex];

  Future<void> _answerMcq(String selected) async {
    if (_answerLocked) return;

    final correct = _q.correct;
    final isCorrect = selected == correct;

    setState(() {
      _answerLocked = true;
      _selectedOption = selected;
      _feedback = isCorrect ? '✅ Benar' : '❌ Salah. Jawaban: $correct';
      if (isCorrect) _mcqCorrect++;
    });

    await Future<void>.delayed(const Duration(milliseconds: 850));
    _goNext();
  }

  Future<void> _startRecording() async {
    if (!_recorderReady || _isRecording) return;

    final dir = await getTemporaryDirectory();
    final path = '${dir.path}/exam_tajwid_${DateTime.now().millisecondsSinceEpoch}.aac';

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
      sampleRate: 16000,
      numChannels: 1,
      bitRate: 16000,
    );

    setState(() {
      _isRecording = true;
      _recordedPath = path;
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;
    final path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      if (path != null) _recordedPath = path;
    });
  }

  Future<void> _playRecorded() async {
    if (_recordedPath == null || _isPlaying) return;
    if (!File(_recordedPath!).existsSync()) return;

    setState(() => _isPlaying = true);
    await _player.startPlayer(
      fromURI: _recordedPath,
      whenFinished: () {
        if (mounted) setState(() => _isPlaying = false);
      },
    );
  }

  Future<void> _evaluatePronunciation() async {
    if (_isEvaluating) return;
    if (_recordedPath == null) {
      _showSnack('Rekam suara dulu sebelum dinilai.');
      return;
    }

    final lessonId = _q.lessonId ?? 1;

    setState(() => _isEvaluating = true);
    try {
      final json = await _api.evaluateTajwid(
        audioPath: _recordedPath!,
        targetText: _q.targetPronunciation!,
        lessonId: lessonId,
      );
      final result = EvaluationResult.fromJson(json);
      final score = result.score.clamp(0, 100);

      _recordingScores.add(score.toDouble());
      if (score >= 50) _pronunciationPassed++;

      setState(() {
        _pronunciationDone = true;
        _feedback = 'Skor pengucapan: $score';
      });

      await _showScorePopup(result);
    } catch (e) {
      _showSnack('Gagal evaluasi pengucapan: $e');
    } finally {
      if (mounted) setState(() => _isEvaluating = false);
    }
  }

  Future<void> _showScorePopup(EvaluationResult r) async {
    final score = r.score.clamp(0, 100);
    Color scoreColor;
    String label;
    String emoji;

    if (score >= 90) {
      scoreColor = const Color(0xFF42C88A);
      label = 'MasyaAllah!';
      emoji = '🌟';
    } else if (score >= 75) {
      scoreColor = const Color(0xFF5FB3F3);
      label = 'Bagus!';
      emoji = '👍';
    } else if (score >= 50) {
      scoreColor = Colors.orange;
      label = 'Cukup Baik';
      emoji = '🙂';
    } else {
      scoreColor = Colors.redAccent;
      label = 'Perlu Latihan';
      emoji = '⚠️';
    }

    await showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'score',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (_, __, ___) => Center(
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.85,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              boxShadow: const [BoxShadow(blurRadius: 30, color: Colors.black26)],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$emoji  $label',
                  style: GoogleFonts.poppins(
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                    color: scoreColor,
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 124,
                  height: 124,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: score / 100,
                        strokeWidth: 11,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: AlwaysStoppedAnimation<Color>(scoreColor),
                      ),
                      Text(
                        '$score',
                        style: GoogleFonts.poppins(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: scoreColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  r.feedback,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(fontSize: 13.5, height: 1.5, color: Colors.black87),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scoreColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: Text('Tutup', style: GoogleFonts.poppins(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      transitionBuilder: (_, anim, __, child) {
        return Transform.scale(
          scale: Curves.easeOutBack.transform(anim.value),
          child: Opacity(opacity: anim.value, child: child),
        );
      },
    );
  }

  Future<void> _goNext() async {
    if (!mounted) return;

    if (_currentIndex >= _questions.length - 1) {
      await _finishExam();
      return;
    }

    setState(() {
      _currentIndex++;
      _answerLocked = false;
      _selectedOption = null;
      _feedback = '';
      _recordedPath = null;
      _pronunciationDone = false;
    });
  }

  Future<void> _finishExam() async {
    final totalQuestions = _questions.length;
    final totalCorrect = _mcqCorrect + _pronunciationPassed;
    final finalScore = (totalCorrect / totalQuestions) * 100;

    try {
      await _submitTajwidExam(
        totalQuestions: totalQuestions,
        correctAnswers: totalCorrect,
        recordingScores: _recordingScores,
      );
    } catch (e) {
      _showSnack('Gagal submit exam ke server: $e');
    }

    try {
      await ProgressService.saveExamScore(totalCorrect);
      await ProgressService.saveXP(totalCorrect * 10);
    } catch (_) {}

    if (!mounted) return;
    final isGreat = finalScore >= 80;
    if (isGreat) _resultConfetti.play();

    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'result',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 320),
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (_, anim, __, ___) {
        final v = Curves.easeOutBack.transform(anim.value);
        return Opacity(
          opacity: v,
          child: Transform.scale(
            scale: v,
            child: Stack(
              alignment: Alignment.center,
              children: [
                if (isGreat)
                  ConfettiWidget(
                    confettiController: _resultConfetti,
                    blastDirection: -3.14 / 2,
                    numberOfParticles: 14,
                    gravity: 0.3,
                  ),
                _resultCard(totalCorrect, totalQuestions, finalScore),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _resultCard(int totalCorrect, int totalQuestions, double finalScore) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.86,
        padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 26)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              finalScore >= 80 ? 'MasyaAllah, Keren!' : 'Terus Latihan, Kamu Bisa!',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: finalScore >= 80 ? const Color(0xFF42C88A) : Colors.orange,
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Skor: ${finalScore.toStringAsFixed(0)}%\nBenar: $totalCorrect dari $totalQuestions',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(fontSize: 15),
            ),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF42C88A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Kembali', style: GoogleFonts.poppins(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitTajwidExam({
    required int totalQuestions,
    required int correctAnswers,
    required List<double> recordingScores,
  }) async {
    final headers = await AuthService.authHeaders(extra: {'Content-Type': 'application/json'});
    final response = await http.post(
      Uri.parse('$_baseUrl/tajwid-exam/submit'),
      headers: headers,
      body: jsonEncode({
        'total_questions': totalQuestions,
        'correct_answers': correctAnswers,
        'recording_scores': recordingScores,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Submit gagal: ${response.body}');
    }
  }

  void _showSnack(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  Widget _mcqOption(String opt) {
    final selected = _selectedOption == opt;
    final correct = opt == _q.correct;

    Color bg = Colors.white;
    if (_answerLocked && correct) bg = const Color(0xFFD9F8E5);
    if (_answerLocked && selected && !correct) bg = const Color(0xFFFFE2E2);

    return GestureDetector(
      onTap: () => _answerMcq(opt),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD1D5DB)),
        ),
        child: Center(
          child: Text(
            opt,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final progress = (_currentIndex + 1) / _questions.length;

    return Scaffold(
      appBar: const CustomGradientAppBar(title: 'Tes Akhir Tajwid'),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FF), Color(0xFFEFF7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  borderRadius: BorderRadius.circular(99),
                  color: const Color(0xFF42C88A),
                  backgroundColor: const Color(0xFFE5E7EB),
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    '${_currentIndex + 1}/${_questions.length}',
                    style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12)],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _q.prompt,
                        style: GoogleFonts.poppins(fontSize: 13, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _q.arabic,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 44, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Expanded(
                  child: _q.type == _ExamType.mcq ? _buildMcqBody() : _buildPronBody(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMcqBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pilih jawaban paling tepat:',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 10),
        ..._q.options.map(_mcqOption),
        if (_feedback.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: Text(_feedback, style: GoogleFonts.poppins(fontSize: 12.5)),
          ),
      ],
    );
  }

  Widget _buildPronBody() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _isRecording ? _stopRecording : _startRecording,
                icon: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded),
                label: Text(_isRecording ? 'Stop Rekam' : 'Mulai Rekam'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: _isPlaying ? null : _playRecorded,
                icon: Icon(_isPlaying ? Icons.graphic_eq_rounded : Icons.play_arrow_rounded),
                label: Text(_isPlaying ? 'Memutar...' : 'Putar Rekaman'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: FilledButton.icon(
                onPressed: _isEvaluating ? null : _evaluatePronunciation,
                icon: _isEvaluating
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.auto_awesome_rounded),
                style: FilledButton.styleFrom(backgroundColor: const Color(0xFF42C88A)),
                label: Text(_isEvaluating ? 'Menilai...' : 'Nilai Pengucapan'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (_feedback.isNotEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(_feedback, style: GoogleFonts.poppins(fontSize: 12.5)),
          ),
        const Spacer(),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _pronunciationDone ? _goNext : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF111827),
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              _currentIndex == _questions.length - 1 ? 'Selesaikan Tes' : 'Lanjut Soal',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }
}
