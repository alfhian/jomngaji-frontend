import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jomngaji/services/openai_pronunciation_service.dart';
import 'package:jomngaji/services/progress_service.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/hijaiyah_data.dart';

class LatihanPengucapanPage extends StatefulWidget {
  final String lessonTitle;
  final List<HijaiyahData> hurufList;

  const LatihanPengucapanPage({
    super.key,
    required this.lessonTitle,
    required this.hurufList,
  });

  @override
  State<LatihanPengucapanPage> createState() => _LatihanPengucapanPageState();
}

class _LatihanPengucapanPageState extends State<LatihanPengucapanPage> {
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final FlutterSoundPlayer _player = FlutterSoundPlayer();

  bool _recorderReady = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _isEvaluating = false;

  int _currentIndex = 0;
  late List<String?> _recordedPaths;

  @override
  void initState() {
    super.initState();
    _recordedPaths = List<String?>.filled(widget.hurufList.length, null);
    _initRecorder();
  }

  Future<void> _initRecorder() async {
    final perm = await Permission.microphone.request();
    if (!perm.isGranted) return;

    await _recorder.openRecorder();
    await _player.openPlayer();

    setState(() => _recorderReady = true);
  }

  @override
  void dispose() {
    _recorder.closeRecorder();
    _player.closePlayer();
    super.dispose();
  }

  // ----------------------------------------------------
  // RECORD
  // ----------------------------------------------------
  Future<void> _startRecording() async {
    if (!_recorderReady || _isRecording) return;

    if (_player.isPlaying) {
      await _player.stopPlayer();
    }

    final dir = await getTemporaryDirectory();
    final path =
        "${dir.path}/latihan_${_currentIndex}_${DateTime.now().millisecondsSinceEpoch}.aac";

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacADTS,
      sampleRate: 44100,
      numChannels: 1,
    );

    setState(() {
      _isRecording = true;
      _recordedPaths[_currentIndex] = path;
    });
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    final path = await _recorder.stopRecorder();
    setState(() {
      _isRecording = false;
      if (path != null) _recordedPaths[_currentIndex] = path;
    });
  }

  // ----------------------------------------------------
  // PLAYBACK
  // ----------------------------------------------------
  Future<void> _playRecorded() async {
    final path = _recordedPaths[_currentIndex];
    if (path == null) return;

    final file = File(path);
    if (!file.existsSync()) return;

    setState(() => _isPlaying = true);

    await _player.startPlayer(
      fromURI: path,
      whenFinished: () {
        if (mounted) setState(() => _isPlaying = false);
      },
    );
  }

  // ----------------------------------------------------
  // EVALUATION (placeholder - nanti diganti OpenAI)
  // ----------------------------------------------------
  Future<void> _onEvaluate() async {
  final path = _recordedPaths[_currentIndex];
    if (path == null || _isEvaluating) return;

    setState(() => _isEvaluating = true);

    try {
      final transcript = await OpenAIPronunciationService.transcribe(path);

      if (transcript == null) {
        _showError("Gagal transkripsi audio.");
        return;
      }

      final target = widget.hurufList[_currentIndex].caraBaca;
      final score = _scorePronunciation(transcript, target);

      _handleEvaluationResult(score);

    } catch (e) {
      _showError("Error menilai: $e");
    } finally {
      if (mounted) setState(() => _isEvaluating = false);
    }
  }


  // ----------------------------------------------------
  // SCORING (penilaian OpenAI)
  // ----------------------------------------------------
  // Fungsi untuk memberi skor berdasarkan kesesuaian antara transkripsi dan target
  int _scorePronunciation(String transcript, String target) {
    // Mengubah hasil transkripsi dan target ke huruf kecil dan menghapus spasi
    final t = transcript.toLowerCase().trim();
    final goal = target.toLowerCase().trim();

    // Kasus 1: Jika transkripsi dan target sama persis
    if (t == goal) return 100;

    // Kasus 2: Jika transkripsi mengandung target (sudah cukup mirip)
    if (t.contains(goal)) return 80;

    // Kasus 3: Jika target mengandung transkripsi (transkripsi kurang tepat, tetapi masih bisa dimengerti)
    if (goal.contains(t)) return 60;

    // Kasus 4: Jika ada transkripsi, tetapi tidak cocok sama sekali
    if (t.isNotEmpty) return 40;

    // Kasus 5: Jika tidak ada transkripsi (kosong)
    return 0;
  }


  // ----------------------------------------------------
  // HANDLE RESULT
  // ----------------------------------------------------
  Future<void> _handleEvaluationResult(int score) async {
    if (score < 50) {
      _showResult(score, "Kurang tepat, coba lagi ya.");
      return;
    }

    // Jika masih ada huruf selanjutnya
    if (_currentIndex < widget.hurufList.length - 1) {
      setState(() => _currentIndex++);
      _showResult(score, "Bagus! Lanjut ke huruf berikutnya.");
      return;
    }

    // Jika huruf terakhir → unlock lesson
    await ProgressService.saveLessonScore(1, 100);
    _showResult(score, "Kamu sudah menguasai seluruh huruf!");
  }

  // ----------------------------------------------------
  // UI HELPERS
  // ----------------------------------------------------
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }

  void _showResult(int score, String saran) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Hasil Penilaian",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Skor: $score / 100\n\n$saran",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------
  // UI COMPONENTS
  // ----------------------------------------------------
  Widget _infoCard() {
    final current = widget.hurufList[_currentIndex];
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7FFF2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        "Latihan bunyi: \"${current.caraBaca}\"",
        style: GoogleFonts.poppins(fontSize: 14),
      ),
    );
  }

  Widget _hurufTabs(List<HijaiyahData> list) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(list.length, (i) {
        final active = i == _currentIndex;

        return GestureDetector(
          onTap: () {
            if (_isRecording) return;
            setState(() => _currentIndex = i);
          },
          child: Container(
            margin: const EdgeInsets.all(4),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: active ? const Color(0xFF42C88A) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              list[i].caraBaca,
              style: GoogleFonts.poppins(
                color: active ? Colors.white : Colors.black,
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget _hurufPreview(HijaiyahData data) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            color: data.color,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Center(
            child: Text(
              data.huruf,
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          data.caraBaca,
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          data.nama,
          style: GoogleFonts.poppins(
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  Widget _recordControls() {
    return Column(
      children: [
        GestureDetector(
          onTap: _isRecording ? _stopRecording : _startRecording,
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
      ],
    );
  }

  Widget _playbackAndEvaluateButtons() {
    final hasAudio = _recordedPaths[_currentIndex] != null;
    if (!hasAudio) return const SizedBox.shrink();

    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: _isPlaying ? null : _playRecorded,
          icon: const Icon(Icons.play_arrow),
          label: Text(
            _isPlaying ? "Memutar..." : "Putar rekaman",
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF5E60CE),
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          onPressed: _isEvaluating ? null : _onEvaluate,
          icon: const Icon(Icons.auto_awesome),
          label: Text(
            _isEvaluating ? "Menilai..." : "Nilai Pengucapan",
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange.shade700,
          ),
        ),
      ],
    );
  }

  // ----------------------------------------------------
  // MAIN BUILD
  // ----------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lessonTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _infoCard(),
          if (widget.hurufList.length > 1) _hurufTabs(widget.hurufList),
          const SizedBox(height: 16),
          _hurufPreview(widget.hurufList[_currentIndex]),
          const SizedBox(height: 24),
          _recordControls(),
          const SizedBox(height: 20),
          _playbackAndEvaluateButtons(),
        ],
      ),
    );
  }
}
