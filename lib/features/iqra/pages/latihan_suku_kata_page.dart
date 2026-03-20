import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../services/suku_kata_service.dart';

class LatihanSukuKataPage extends StatefulWidget {
  final SukuKataLevel level;

  const LatihanSukuKataPage({
    super.key,
    required this.level,
  });

  @override
  State<LatihanSukuKataPage> createState() => _LatihanSukuKataPageState();
}

class _LatihanSukuKataPageState extends State<LatihanSukuKataPage>
    with TickerProviderStateMixin {
  static const int _maxQuestions = 5;

  bool _loading = true;
  List<SukuKataQuestion> _questions = [];
  List<SukuKataQuestion> _sessionQuestions = [];

  int _questionIndex = 0;
  int _correctCount = 0;

  late AnimationController correctAnim;
  late AnimationController wrongAnim;

  @override
  void initState() {
    super.initState();

    correctAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.0,
      upperBound: 1.0,
    );

    _loadQuestions();
  }

  @override
  void dispose() {
    correctAnim.dispose();
    wrongAnim.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() => _loading = true);
    try {
      final questions = await SukuKataService.getLevelQuestions(widget.level.id);
      questions.shuffle();
      setState(() {
        _questions = questions;
        _sessionQuestions =
            questions.take(min(_maxQuestions, questions.length)).toList();
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil soal: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  List<String> _optionsFor(SukuKataQuestion question) {
    final random = Random();
    final pool = _questions.map((e) => e.latin).toSet().toList();
    pool.remove(question.latin);
    pool.shuffle(random);

    final options = <String>[question.latin, ...pool.take(2)];
    options.shuffle(random);
    return options;
  }

  Future<void> _checkAnswer(String answer) async {
    final current = _sessionQuestions[_questionIndex];
    final benar = answer.toUpperCase() == current.latin.toUpperCase();

    if (benar) {
      _correctCount++;
      correctAnim.forward(from: 0);
    } else {
      wrongAnim.forward(from: 0);
    }

    await Future.delayed(const Duration(milliseconds: 600));

    if (_questionIndex >= _sessionQuestions.length - 1) {
      await _finishLevel();
      return;
    }

    setState(() => _questionIndex++);
  }

  Future<void> _finishLevel() async {
    final total = _sessionQuestions.length;
    final scorePercent = total == 0 ? 0.0 : (_correctCount / total) * 100;
    final xpGain = _correctCount * 5;

    try {
      await SukuKataService.submitLevelScore(
        levelId: widget.level.id,
        score: scorePercent,
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Submit score gagal: $e')),
        );
      }
    }

    if (!mounted) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _resultDialog(scorePercent, xpGain, total),
    );
  }

  Widget _resultDialog(double score, int xpGain, int total) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 30),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              score >= 50 ? 'Bagus Sekali!' : 'Ayo Coba Lagi',
              style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.w800,
                color: score >= 50 ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Benar: $_correctCount dari $total\n+ $xpGain XP',
              style: GoogleFonts.poppins(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF50D1A0), Color(0xFF2FB576)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(
                    'Kembali',
                    style: GoogleFonts.poppins(
                      fontSize: 17,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label) {
    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.12).animate(
        CurvedAnimation(
          parent: correctAnim,
          curve: Curves.elasticOut,
        ),
      ),
      child: GestureDetector(
        onTap: () => _checkAnswer(label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFE8FFF0),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xFF50D1A0),
              width: 1.2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 23,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF42C88A),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_sessionQuestions.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.level.title, style: GoogleFonts.poppins()),
          backgroundColor: const Color(0xFF50D1A0),
        ),
        body: Center(
          child: Text(
            'Belum ada soal untuk level ini.',
            style: GoogleFonts.poppins(fontSize: 15),
          ),
        ),
      );
    }

    final current = _sessionQuestions[_questionIndex];
    final options = _optionsFor(current);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.level.title, style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_sessionQuestions.length, (i) {
                final active = i <= _questionIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 350),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: active ? 28 : 16,
                  height: 10,
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFF42C88A) : Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(20),
                  ),
                );
              }),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: BoxDecoration(
                color: const Color(0xFFF1FFF6),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.06),
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Center(
                child: Text(
                  current.arabic,
                  style: const TextStyle(
                    fontSize: 90,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF42C88A),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: Column(
                children: options
                    .map((opt) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildOption(opt),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
