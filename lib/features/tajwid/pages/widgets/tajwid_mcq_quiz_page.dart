import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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

  int _questionIndex = 0;
  int _correctCount = 0;
  int _streak = 0;
  int _bestStreak = 0;
  String? _selectedOption;
  bool _lockedAnswer = false;

  int? _serverCorrect;
  int? _serverTotal;

  late AnimationController _correctAnim;
  late AnimationController _wrongAnim;

  @override
  void initState() {
    super.initState();
    _correctAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 360));
    _wrongAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 260));
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

      if (!mounted) return;
      setState(() => _questions = randomized);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _norm(String v) => v.trim().toLowerCase();

  bool _isCorrect(TajwidQuizQuestion q, String option) {
    if (q.correctAnswer.trim().isEmpty) return false;
    return _norm(option) == _norm(q.correctAnswer);
  }

  Future<void> _checkAnswer(String answer) async {
    if (_lockedAnswer || _questions.isEmpty) return;

    final current = _questions[_questionIndex];
    final hasCorrect = current.correctAnswer.trim().isNotEmpty;
    final benar = _isCorrect(current, answer);

    setState(() {
      _lockedAnswer = true;
      _selectedOption = answer;

      if (hasCorrect && benar) {
        _correctCount++;
        _streak++;
        if (_streak > _bestStreak) _bestStreak = _streak;
      } else if (hasCorrect) {
        _streak = 0;
      }

      _answers.add({
        'question_id': current.id,
        'selected_option': answer,
      });
    });

    if (hasCorrect) {
      if (benar) {
        _correctAnim.forward(from: 0);
      } else {
        _wrongAnim.forward(from: 0);
      }
    }

    final snackText = hasCorrect
        ? (benar
            ? '✅ Benar!'
            : '❌ Salah. Jawaban benar: ${current.correctAnswer}')
        : 'ℹ️ Jawaban dipilih. Benar/salah dihitung dari hasil submit backend.';

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          duration: const Duration(milliseconds: 850),
          backgroundColor: hasCorrect
              ? (benar ? const Color(0xFF2E7D32) : const Color(0xFFC62828))
              : const Color(0xFF334155),
          content: Text(
            snackText,
            style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ),
      );

    await Future.delayed(const Duration(milliseconds: 720));

    if (!mounted) return;

    if (_questionIndex >= _questions.length - 1) {
      await _finishQuiz();
      return;
    }

    setState(() {
      _questionIndex++;
      _lockedAnswer = false;
      _selectedOption = null;
    });
  }

  Future<void> _finishQuiz() async {
    try {
      final result = await TajwidQuizService.submitQuiz(
        quizCode: widget.quizCode,
        answers: _answers,
      );
      _serverCorrect = int.tryParse('${result['correct'] ?? ''}');
      _serverTotal = int.tryParse('${result['total'] ?? ''}');
    } catch (_) {
      // ignore
    }

    if (!mounted) return;
    _showResultDialog();
  }

  void _showResultDialog() {
    final total = _serverTotal ?? _questions.length;
    final correct = _serverCorrect ?? _correctCount;
    final score = total == 0 ? 0 : ((correct / total) * 100);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 30),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 30, 20, 30),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(26)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score >= 60 ? 'MasyaAllah, Lolos!' : 'Semangat, Coba Lagi!',
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: score >= 60 ? Colors.green : Colors.red,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Benar: $correct dari $total\nSkor: ${score.toStringAsFixed(0)}%',
                style: GoogleFonts.poppins(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(colors: [Color(0xFF50D1A0), Color(0xFF2FB576)]),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'Kembali',
                      style: GoogleFonts.poppins(fontSize: 17, color: Colors.white, fontWeight: FontWeight.w700),
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
          color: highlighted ? const Color(0xFF42C88A) : const Color(0xFF2C2C2C),
          fontWeight: highlighted ? FontWeight.w800 : FontWeight.w700,
        ),
      );
    }).toList();

    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: const TextStyle(fontSize: 74, height: 1, fontWeight: FontWeight.w700),
        children: spans,
      ),
    );
  }

  Widget _buildOption(TajwidQuizQuestion current, String label) {
    final hasCorrect = current.correctAnswer.trim().isNotEmpty;
    final isCorrect = _isCorrect(current, label);
    final isSelected = _selectedOption == label;

    Color bg = const Color(0xFFC9E2D4);
    Color border = const Color(0xFF42C88A);
    Color text = const Color(0xFF42C88A);
    IconData? icon;

    if (_lockedAnswer && hasCorrect) {
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
        bg = Colors.white.withOpacity(0.8);
        border = Colors.grey.shade300;
        text = Colors.grey.shade600;
      }
    }

    if (_lockedAnswer && !hasCorrect && isSelected) {
      bg = const Color(0xFFDCEBFF);
      border = const Color(0xFF3B82F6);
      text = const Color(0xFF3B82F6);
      icon = Icons.check_circle_rounded;
    }

    final anim = isSelected && _lockedAnswer
        ? (isCorrect ? _correctAnim : _wrongAnim)
        : kAlwaysDismissedAnimation;

    return ScaleTransition(
      scale: Tween(begin: 1.0, end: 1.06).animate(
        CurvedAnimation(parent: anim, curve: Curves.easeOutBack),
      ),
      child: GestureDetector(
        onTap: () => _checkAnswer(label),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border, width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: text,
                ),
              ),
              if (icon != null) ...[
                const SizedBox(width: 8),
                Icon(icon, color: text),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xFF50D1A0)),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xFF50D1A0)),
        body: Center(child: Text(_error!, textAlign: TextAlign.center)),
      );
    }

    if (_questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(backgroundColor: const Color(0xFF50D1A0)),
        body: const Center(child: Text('Soal belum tersedia.')),
      );
    }

    final current = _questions[_questionIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE9E4EA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF50D1A0),
        elevation: 0,
        title: Text(widget.title, style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: (_questionIndex + 1) / _questions.length,
                            minHeight: 8,
                            backgroundColor: Colors.grey.shade300,
                            color: const Color(0xFF42C88A),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text('${_questionIndex + 1}/${_questions.length}', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Streak: $_streak 🔥', style: GoogleFonts.poppins(color: const Color(0xFF1E915B), fontWeight: FontWeight.w700)),
                      Text('Best: $_bestStreak', style: GoogleFonts.poppins(color: Colors.black54)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 190,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD0DED8),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    alignment: Alignment.center,
                    child: _buildHighlightedArabicText(current.questionText),
                  ),
                  const SizedBox(height: 18),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.55),
                        borderRadius: BorderRadius.circular(24),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/background-mengaji.png'),
                          fit: BoxFit.cover,
                          opacity: 0.2,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text('Pilih bacaan latin yang tepat', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 24)),
                          const SizedBox(height: 12),
                          Expanded(
                            child: ListView(
                              children: current.options.map((o) => _buildOption(current, o)).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
