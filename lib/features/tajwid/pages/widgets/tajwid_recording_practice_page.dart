import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/custom_gradient_appbar.dart';
import 'tajwid_best_score_badge.dart';

class RecordingPrompt {
  final String arabicText;
  final String tip;

  const RecordingPrompt({required this.arabicText, required this.tip});
}

class TajwidRecordingPracticePage extends StatefulWidget {
  final String title;
  final String quizCode;
  final Color accent;
  final String intro;
  final List<RecordingPrompt> prompts;

  const TajwidRecordingPracticePage({
    super.key,
    required this.title,
    required this.quizCode,
    required this.accent,
    required this.intro,
    required this.prompts,
  });

  @override
  State<TajwidRecordingPracticePage> createState() => _TajwidRecordingPracticePageState();
}

class _TajwidRecordingPracticePageState extends State<TajwidRecordingPracticePage> {
  bool _isRecording = false;
  bool _hasAudio = false;
  int _index = 0;
  String _feedback = '';

  void _toggleRecording() {
    setState(() {
      if (_isRecording) {
        _isRecording = false;
        _hasAudio = true;
        _feedback = 'Rekaman selesai. Siap diputar & dinilai.';
      } else {
        _isRecording = true;
        _feedback = 'Sedang merekam...';
      }
    });
  }

  void _evaluateDummy() {
    final score = 70 + (_index * 5);
    setState(() {
      _feedback = 'Skor sementara: $score/100. ${widget.prompts[_index].tip}';
    });
  }

  void _nextPrompt() {
    if (_index >= widget.prompts.length - 1) return;
    setState(() {
      _index++;
      _isRecording = false;
      _hasAudio = false;
      _feedback = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final prompt = widget.prompts[_index];

    return Scaffold(
      appBar: CustomGradientAppBar(title: widget.title),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF7F9FF), Color(0xFFEFF7FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [widget.accent.withOpacity(0.18), widget.accent.withOpacity(0.08)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.intro,
                    style: GoogleFonts.poppins(fontSize: 13, height: 1.45),
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1),
                  const SizedBox(height: 10),
                  TajwidBestScoreBadge(
                    quizCode: widget.quizCode,
                    label: 'Best Score Praktek',
                    source: TajwidBestScoreSource.recording,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: (_index + 1) / widget.prompts.length,
              minHeight: 8,
              borderRadius: BorderRadius.circular(99),
              backgroundColor: const Color(0xFFE2E8F0),
              color: widget.accent,
            ),
            const SizedBox(height: 8),
            Text('Latihan ${_index + 1}/${widget.prompts.length}', style: GoogleFonts.poppins(fontSize: 12)),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12)],
              ),
              child: Text(
                prompt.arabicText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _toggleRecording,
                child: Container(
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    color: _isRecording ? Colors.red : widget.accent,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(_isRecording ? Icons.stop_rounded : Icons.mic_rounded, color: Colors.white, size: 36),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Center(child: Text(_isRecording ? 'Sedang merekam...' : 'Tap untuk rekam', style: GoogleFonts.poppins())),
            const SizedBox(height: 14),
            if (_hasAudio) ...[
              FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.play_arrow_rounded), label: const Text('Putar Rekaman')),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _evaluateDummy,
                icon: const Icon(Icons.auto_awesome_rounded),
                style: FilledButton.styleFrom(backgroundColor: widget.accent),
                label: const Text('Nilai Pengucapan'),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(onPressed: _nextPrompt, icon: const Icon(Icons.navigate_next_rounded), label: const Text('Soal Berikutnya')),
            ],
            if (_feedback.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: Text(_feedback, style: GoogleFonts.poppins(fontSize: 12.5)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
