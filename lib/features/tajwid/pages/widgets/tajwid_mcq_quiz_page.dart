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

class _TajwidMcqQuizPageState extends State<TajwidMcqQuizPage>
    with TickerProviderStateMixin {
  bool _loading = true;
  String? _error;
  List<TajwidQuizQuestion> _questions = [];
  final List<Map<String, dynamic>> _answers = [];

  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _locked = false;
  int? _serverCorrect;
  int? _serverTotal;

  late AnimationController _correctAnim;
  late AnimationController _wrongAnim;

  @override
  void initState() {
    super.initState();
    _correctAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 340),
    );
    _wrongAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _loadQuestions();
  }

  @override
  void dispose() {
    _correctAnim.dispose();
    _wrongAnim.dispose();
    super.dispose();
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final payload = await TajwidQuizService.fetchQuestions(widget.quizCode);
      if (!mounted) return;
      final randomized = payload.questions.map((q) {
        final options = [...q.options]..shuffle();
        return TajwidQuizQuestion(
          id: q.id,
          questionText: q.questionText,
          options: options,
          correctAnswer: q.correctAnswer,
        );
      }).toList()
        ..shuffle();

      setState(() {
        _questions = randomized;
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
    final hasCorrect = q.correctAnswer.isNotEmpty;
    final isCorrect = hasCorrect &&
        _normalizeAnswer(option) == _normalizeAnswer(q.correctAnswer);

    setState(() {
      _locked = true;
      _selected = option;
      if (isCorrect) _correct++;
      _answers.add({
        'question_id': q.id,
        'selected_option': option,
      });
    });

    if (hasCorrect) {
      if (isCorrect) {
        _correctAnim.forward(from: 0);
      } else {
        _wrongAnim.forward(from: 0);
      }
    }

    final message = hasCorrect
        ? (isCorrect
            ? '✅ Benar! Lanjutkan!'
            : '❌ Salah. Jawaban benar: ${q.correctAnswer}')
        : '✅ Jawaban dipilih. Cek skor final setelah submit.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          backgroundColor: hasCorrect
              ? (isCorrect ? const Color(0xFF2E7D32) : const Color(0xFFC62828))
              : const Color(0xFF334155),
          duration: const Duration(milliseconds: 900),
          content: Text(
            message,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );

    await Future.delayed(const Duration(milliseconds: 760));

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

  Future<void> _submitResult() async {
    try {
      final result = await TajwidQuizService.submitQuiz(
        quizCode: widget.quizCode,
        answers: _answers,
      );

      _serverCorrect = int.tryParse('${result['correct'] ?? ''}');
      _serverTotal = int.tryParse('${result['total'] ?? ''}');
    } catch (_) {
      // Non-blocking for UX.
    }
  }

  void _showResultDialog() {
    final total = _serverTotal ?? _questions.length;
    final correct = _serverCorrect ?? _correct;
    final score = total == 0 ? 0 : ((correct / total) * 100).round();

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 28),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score >= 60 ? 'MasyaAllah, Lolos!' : 'Semangat, Coba Lagi!',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: score >= 60 ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'Benar: $correct dari $total\nSkor: $score%',
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
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
                      'Selesai',
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomGradientAppBar(title: widget.title),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!, textAlign: TextAlign.center))
              : _questions.isEmpty
                  ? const Center(child: Text('Soal belum tersedia.'))
                  : _buildQuizBody(),
    );
  }

  Widget _buildQuizBody() {
    final q = _questions[_index];

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(14),
            children: [
              _buildInfoCard(),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (_index + 1) / _questions.length,
                backgroundColor: Colors.grey[300],
                color: const Color(0xFF50D1A0),
                minHeight: 8,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: _buildHighlightedArabicText(q.questionText),
              ),
              const SizedBox(height: 16),
              ...q.options.map((o) => _buildOptionTile(q, o)),
            ],
          ),
        ),
        SizedBox(
          width: double.infinity,
          child: Image.asset(
            'assets/images/background-mengaji.png',
            fit: BoxFit.cover,
            height: 96,
          ),
        ),
      ],
    );
  }

  String _normalizeAnswer(String value) {
    return value.trim().toLowerCase();
  }

  Set<String> _highlightCharsForCode(String code) {
    switch (code) {
      case 'nun_tanwin':
        return {'ن', 'ً', 'ٍ', 'ٌ'};
      case 'mim_mati':
        return {'م', 'ْ'};
      case 'mad':
        return {'ا', 'و', 'ي'};
      case 'qalqalah':
        return {'ق', 'ط', 'ب', 'ج', 'د'};
      case 'ghunnah':
        return {'ن', 'م'};
      default:
        return {};
    }
  }

  Widget _buildHighlightedArabicText(String text) {
    final highlights = _highlightCharsForCode(widget.quizCode);
    final spans = text.split('').map((ch) {
      final highlighted = highlights.contains(ch);
      return TextSpan(
        text: ch,
        style: TextStyle(
          color: highlighted ? const Color(0xFF2FB576) : Colors.black87,
          fontWeight: highlighted ? FontWeight.w800 : FontWeight.w700,
        ),
      );
    }).toList();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: GoogleFonts.poppins(
          fontSize: 34,
          fontWeight: FontWeight.w700,
        ),
        children: spans,
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF9C4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        widget.intro,
        style: GoogleFonts.poppins(fontSize: 12.5, height: 1.35),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionTile(TajwidQuizQuestion q, String option) {
    final hasCorrect = q.correctAnswer.isNotEmpty;
    final isCorrect = hasCorrect &&
        _normalizeAnswer(option) == _normalizeAnswer(q.correctAnswer);
    final isSelected = _selected == option;

    Color bg = const Color(0xFFE8FFF0);
    Color border = const Color(0xFF50D1A0);
    Color text = const Color(0xFF2FB576);
    IconData? icon;

    if (_locked) {
      if (hasCorrect) {
        if (isCorrect) {
          bg = const Color(0xFFD9F8E5);
          border = const Color(0xFF1E915B);
          text = const Color(0xFF1E915B);
          icon = Icons.check_circle_rounded;
        } else if (isSelected) {
          bg = const Color(0xFFFFE2E2);
          border = const Color(0xFFD84343);
          text = const Color(0xFFD84343);
          icon = Icons.cancel_rounded;
        } else {
          bg = Colors.white.withOpacity(0.75);
          border = Colors.grey.shade300;
          text = Colors.grey.shade600;
        }
      } else if (isSelected) {
        bg = const Color(0xFFDBEAFE);
        border = const Color(0xFF1D4ED8);
        text = const Color(0xFF1D4ED8);
        icon = Icons.check_circle_rounded;
      }
    }

    final anim = isSelected && _locked
        ? (isCorrect ? _correctAnim : _wrongAnim)
        : kAlwaysDismissedAnimation;

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.05).animate(
        CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      ),
      child: GestureDetector(
        onTap: () => _onOptionTap(option),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 10),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 14),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  option,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: text,
                  ),
                ),
              ),
              if (icon != null) Icon(icon, color: text),
            ],
          ),
        ),
      ),
    );
  }
}
