import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/widgets/custom_gradient_appbar.dart';
import '../../../../services/tajwid_quiz_service.dart';

class TajwidMcqQuizPage extends StatefulWidget {
  final String title;
  final String quizCode;
  final Color accent;
  final String intro;

  const TajwidMcqQuizPage({
    super.key,
    required this.title,
    required this.quizCode,
    required this.accent,
    required this.intro,
  });

  @override
  State<TajwidMcqQuizPage> createState() => _TajwidMcqQuizPageState();
}

class _TajwidMcqQuizPageState extends State<TajwidMcqQuizPage> {
  bool _loading = true;
  String? _error;
  List<TajwidQuizQuestion> _questions = [];
  final List<Map<String, dynamic>> _answers = [];

  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final payload = await TajwidQuizService.fetchQuestions(widget.quizCode);
      if (!mounted) return;
      setState(() {
        _questions = payload.questions;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _onOptionTap(String option) async {
    if (_locked || _questions.isEmpty) return;

    final q = _questions[_index];
    final isCorrect = _isCorrect(option);

    setState(() {
      _locked = true;
      _selected = option;
      if (isCorrect) _correct++;
      _answers.add({
        'question_id': q.id,
        'answer': option,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isCorrect ? Colors.green : Colors.red,
        duration: const Duration(milliseconds: 900),
        content: Text(
          isCorrect
              ? '✅ Jawaban benar! Lanjutkan!'
              : '❌ Kurang tepat. Coba perhatikan hukum bacaan.',
        ),
      ),
    );

    await Future.delayed(const Duration(milliseconds: 950));

    if (!mounted) return;

    if (_index >= _questions.length - 1) {
      await _submitResult();
      _showResultDialog();
      return;
    }

    setState(() {
      _index++;
      _selected = null;
      _locked = false;
    });
  }

  bool _isCorrect(String selected) {
    final q = _questions[_index];
    if (q.correctAnswer.isEmpty) {
      // Fallback jika backend belum kirim kunci jawaban.
      return selected == q.options.first;
    }
    return selected == q.correctAnswer;
  }

  Future<void> _submitResult() async {
    try {
      await TajwidQuizService.submitQuiz(
        quizCode: widget.quizCode,
        answers: _answers,
      );
    } catch (_) {
      // Non-blocking for UX.
    }
  }

  void _showResultDialog() {
    final total = _questions.length;
    final score = total == 0 ? 0 : ((_correct / total) * 100).round();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          score >= 60 ? 'MasyaAllah! 🎉' : 'Tetap Semangat 💪',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Skor kamu: $score\nBenar: $_correct / $total',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(height: 1.4),
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Selesai'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? Center(child: Text(_error!, textAlign: TextAlign.center))
                : _questions.isEmpty
                    ? const Center(child: Text('Soal belum tersedia.'))
                    : _buildQuizBody(),
      ),
    );
  }

  Widget _buildQuizBody() {
    final q = _questions[_index];

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _introCard(),
        const SizedBox(height: 14),
        LinearProgressIndicator(
          value: (_index + 1) / _questions.length,
          minHeight: 8,
          borderRadius: BorderRadius.circular(99),
          backgroundColor: const Color(0xFFE2E8F0),
          color: widget.accent,
        ),
        const SizedBox(height: 8),
        Text(
          'Soal ${_index + 1} dari ${_questions.length}',
          style: GoogleFonts.poppins(fontSize: 12, color: const Color(0xFF64748B)),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(color: Color(0x14000000), blurRadius: 12)],
          ),
          child: Text(
            q.questionText,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700, height: 1.5),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        ...q.options.map((o) => _optionTile(o)),
      ],
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: widget.accent.withOpacity(0.10),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        widget.intro,
        style: GoogleFonts.poppins(fontSize: 13, height: 1.45),
      ),
    );
  }

  Widget _optionTile(String option) {
    final selected = _selected == option;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: _locked ? null : () => _onOptionTap(option),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? widget.accent.withOpacity(0.12) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? widget.accent : const Color(0xFFE2E8F0),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
              if (selected)
                Icon(Icons.check_circle_rounded, color: widget.accent),
            ],
          ),
        ),
      ),
    );
  }
}
