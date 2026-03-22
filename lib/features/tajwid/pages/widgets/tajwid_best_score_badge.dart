import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../services/tajwid_quiz_service.dart';

class TajwidBestScoreBadge extends StatefulWidget {
  final String quizCode;
  final String label;

  const TajwidBestScoreBadge({
    super.key,
    required this.quizCode,
    this.label = 'Best score',
  });

  @override
  State<TajwidBestScoreBadge> createState() => _TajwidBestScoreBadgeState();
}

class _TajwidBestScoreBadgeState extends State<TajwidBestScoreBadge> {
  static final Map<String, double?> _scoreCache = {};

  Future<double?> _load() async {
    if (_scoreCache.containsKey(widget.quizCode)) {
      return _scoreCache[widget.quizCode];
    }

    try {
      final progress = await TajwidQuizService.getQuizProgress(widget.quizCode);
      final value = _extractBestScore(progress);
      _scoreCache[widget.quizCode] = value;
      return value;
    } catch (_) {
      _scoreCache[widget.quizCode] = null;
      return null;
    }
  }

  double? _extractBestScore(Map<String, dynamic> progress) {
    double? parsePercent(dynamic raw, {bool percentAlready = true}) {
      final value = double.tryParse('${raw ?? ''}');
      if (value == null) return null;
      final normalized = percentAlready ? value : value * 100;
      return normalized.clamp(0, 100).toDouble();
    }

    return parsePercent(progress['best_score']) ??
        parsePercent(progress['highest_score']) ??
        parsePercent(progress['high_score']) ??
        parsePercent(progress['score']) ??
        parsePercent(progress['progress'], percentAlready: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double?>(
      future: _load(),
      builder: (_, snapshot) {
        final score = snapshot.data;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFFBDE9D4)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.emoji_events_rounded, size: 14, color: Color(0xFF2F9E6E)),
              const SizedBox(width: 6),
              Text(
                '${widget.label}: ${score == null ? '--' : '${score.toStringAsFixed(0)}%'}',
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF2F9E6E),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
