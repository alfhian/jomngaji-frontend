import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../services/suku_kata_service.dart';
import 'latihan_suku_kata_page.dart';

class LatihanSukuKataMenuPage extends StatefulWidget {
  const LatihanSukuKataMenuPage({super.key});

  @override
  State<LatihanSukuKataMenuPage> createState() => _LatihanSukuKataMenuPageState();
}

class _LatihanSukuKataMenuPageState extends State<LatihanSukuKataMenuPage> {
  bool _loading = true;
  List<SukuKataLevel> _levels = [];
  double _progressFromApi = 0.0;

  @override
  void initState() {
    super.initState();
    _loadLevels();
  }

  Future<void> _loadLevels() async {
    setState(() => _loading = true);
    try {
      final payload = await SukuKataService.getLevels();
      setState(() {
        _levels = payload.levels;
        _progressFromApi = payload.progressPercentage;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal mengambil level: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  double get _progressValue {
    if (_progressFromApi > 0) return _progressFromApi.clamp(0.0, 1.0);
    if (_levels.isEmpty) return 0.0;
    final unlocked = _levels.where((e) => e.isUnlocked).length;
    return unlocked / _levels.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: 'Latihan Suku Kata'),
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
            : RefreshIndicator(
                onRefresh: _loadLevels,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                  children: [
                    _introCard(),
                    const SizedBox(height: 18),
                    _progressCard(),
                    const SizedBox(height: 14),
                    if (_levels.isEmpty)
                      _emptyCard()
                    else
                      ..._levels.map((level) => _levelCard(context, level: level)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _introCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF155EEF), Color(0xFF22A06B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33155EEF),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.spellcheck_rounded, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                'Latihan Bertahap',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pilih level suku kata dari mudah ke menengah, lalu selesaikan untuk membuka level berikutnya.',
            style: GoogleFonts.poppins(
              color: Colors.white.withOpacity(0.95),
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }

  Widget _progressCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDBEAFE)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progress ${(_progressValue * 100).toInt()}%',
            style: GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: _progressValue,
              minHeight: 8,
              backgroundColor: const Color(0xFFE2E8F0),
              color: const Color(0xFF22A06B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Text(
        'Belum ada level dari server.',
        style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF475569)),
      ),
    );
  }

  Widget _levelCard(
    BuildContext context, {
    required SukuKataLevel level,
  }) {
    final unlocked = level.isUnlocked;
    final accent = unlocked ? const Color(0xFF22A06B) : const Color(0xFF64748B);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: unlocked
            ? () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LatihanSukuKataPage(level: level),
                  ),
                ).then((_) => _loadLevels())
            : null,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: accent.withOpacity(0.18)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 14,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  unlocked ? Icons.menu_book_rounded : Icons.lock_rounded,
                  color: accent,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      level.title,
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      level.description.isEmpty ? 'Soal: ${level.totalQuestions}' : level.description,
                      style: GoogleFonts.poppins(
                        fontSize: 12.8,
                        color: const Color(0xFF475569),
                        height: 1.45,
                      ),
                    ),
                    if (level.isPremium) ...[
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: GoogleFonts.poppins(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16, color: accent),
            ],
          ),
        ),
      ),
    );
  }
}
