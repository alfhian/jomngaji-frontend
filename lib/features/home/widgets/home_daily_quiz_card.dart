import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/daily_quiz_bank.dart';

class HomeDailyQuizCard extends StatefulWidget {
  const HomeDailyQuizCard({super.key});

  @override
  State<HomeDailyQuizCard> createState() => _HomeDailyQuizCardState();
}

class _HomeDailyQuizCardState extends State<HomeDailyQuizCard> {
  static const _dateKey = 'daily_quiz_answered_date';
  static const _pickedKey = 'daily_quiz_picked_index';
  static const _selectedKey = 'daily_quiz_selected_answer';
  static const _isCorrectKey = 'daily_quiz_is_correct';

  DailyQuizItem? _quiz;
  int _pickedIndex = 0;
  bool _loading = true;
  bool _answered = false;
  String? _selected;
  bool _isCorrect = false;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
  }

  String _today() {
    final d = DateTime.now();
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  Future<void> _loadQuiz() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _today();

    final savedDate = prefs.getString(_dateKey);
    final sameDay = savedDate == today;

    int picked = prefs.getInt(_pickedKey) ?? Random().nextInt(dailyQuizBank.length);
    if (!sameDay) {
      picked = Random().nextInt(dailyQuizBank.length);
      await prefs.setString(_dateKey, today);
      await prefs.setInt(_pickedKey, picked);
      await prefs.remove(_selectedKey);
      await prefs.remove(_isCorrectKey);
    }

    setState(() {
      _pickedIndex = picked;
      _quiz = dailyQuizBank[picked];
      _selected = prefs.getString(_selectedKey);
      _answered = _selected != null;
      _isCorrect = prefs.getBool(_isCorrectKey) ?? false;
      _loading = false;
    });
  }

  Future<void> _answer(String option) async {
    if (_answered || _quiz == null) return;

    final correct = option == _quiz!.answer;
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_selectedKey, option);
    await prefs.setBool(_isCorrectKey, correct);

    setState(() {
      _answered = true;
      _selected = option;
      _isCorrect = correct;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _quiz == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final q = _quiz!;
    final tomorrow = DateTime.now().add(const Duration(days: 1));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quiz Harian • ${q.category}',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Text(
            q.question,
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          const SizedBox(height: 12),
          ...q.options.map((opt) {
            final selected = _selected == opt;
            final correctOpt = _answered && opt == q.answer;
            final wrongSelected = _answered && selected && opt != q.answer;

            Color bg = Colors.white;
            Color border = Colors.grey.shade300;
            if (correctOpt) {
              bg = const Color(0xFFD9F8E5);
              border = const Color(0xFF2F9E6E);
            } else if (wrongSelected) {
              bg = const Color(0xFFFFE2E2);
              border = const Color(0xFFD84343);
            }

            return GestureDetector(
              onTap: () => _answer(opt),
              child: Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: border),
                ),
                child: Text(
                  opt,
                  style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                ),
              ),
            );
          }),
          const SizedBox(height: 8),
          Text(
            _answered
                ? (_isCorrect
                    ? '✅ Benar! Soal baru akan terbuka besok.'
                    : '❌ Belum tepat. Soal baru terbuka besok (${tomorrow.day}/${tomorrow.month}).')
                : 'Jawab sekarang, lalu kembali lagi besok untuk soal baru.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
