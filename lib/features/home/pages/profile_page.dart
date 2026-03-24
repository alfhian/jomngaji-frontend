import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../auth/services/auth_service.dart';
import '../widgets/app_bottom_nav.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  static const _baseUrl = 'http://10.71.164.20:4000';

  bool _loading = true;
  bool _resetLoading = false;
  String _name = 'Pengguna';

  double _iqra = 0;
  double _tajwid = 0;
  double _tilawah = 0;
  double _tahfidz = 0;
  double _tadarus = 0;

  int _iqraScore = 0;
  int _tajwidScore = 0;
  int _tilawahScore = 0;
  int _tahfidzScore = 0;

  final _oldPasswordCtrl = TextEditingController();
  final _newPasswordCtrl = TextEditingController();
  final _confirmPasswordCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileProgress();
    });
  }

  @override
  void dispose() {
    _oldPasswordCtrl.dispose();
    _newPasswordCtrl.dispose();
    _confirmPasswordCtrl.dispose();
    super.dispose();
  }

  double _normalizeProgress(dynamic value) {
    final raw = double.tryParse('${value ?? 0}') ?? 0;
    if (raw > 1) return (raw / 100).clamp(0, 1);
    return raw.clamp(0, 1);
  }

  int _normalizeScore(dynamic value) {
    final raw = double.tryParse('${value ?? 0}') ?? 0;
    if (raw > 100) return 100;
    if (raw < 0) return 0;
    return raw.round();
  }

  Future<void> _loadProfileProgress() async {
    setState(() => _loading = true);
    try {
      final token = await AuthService.getAccessToken();
      if (token == null || token.isEmpty) {
        throw Exception('Session login tidak ditemukan. Silakan login ulang.');
      }

      final headers = {'Authorization': 'Bearer $token'};
      final userName = (await AuthService.getUserName()) ?? 'Pengguna';

      final responses = await Future.wait([
        http.get(Uri.parse('$_baseUrl/progress/average'), headers: headers),
        http.get(Uri.parse('$_baseUrl/tadarus/global-progress'), headers: headers),
        http.get(Uri.parse('$_baseUrl/progress/summary'), headers: headers),
      ]);

      final avgRes = responses[0];
      final tadarusRes = responses[1];
      final summaryRes = responses[2];

      if (avgRes.statusCode != 200) {
        throw Exception('Gagal mengambil progress average: ${avgRes.body}');
      }
      if (tadarusRes.statusCode != 200) {
        throw Exception('Gagal mengambil progress tadarus: ${tadarusRes.body}');
      }
      if (summaryRes.statusCode != 200) {
        throw Exception('Gagal mengambil ringkasan skor ujian: ${summaryRes.body}');
      }

      final avgJson = jsonDecode(avgRes.body) as Map<String, dynamic>;
      final tadarusJson = jsonDecode(tadarusRes.body) as Map<String, dynamic>;
      final summaryJson = jsonDecode(summaryRes.body) as Map<String, dynamic>;

      final tadarusProgress = tadarusJson['percentage'] ??
          ((tadarusJson['total_ayah'] ?? 0) == 0
              ? 0
              : ((tadarusJson['completed_ayah'] ?? 0) /
                  (tadarusJson['total_ayah'] ?? 1)));

      if (!mounted) return;
      setState(() {
        _name = userName;
        _iqra = _normalizeProgress(avgJson['iqra_avg']);
        _tajwid = _normalizeProgress(avgJson['tajwid_avg']);
        _tilawah = _normalizeProgress(avgJson['tilawah_avg']);
        _tahfidz = _normalizeProgress(avgJson['tahfidz_avg']);
        _tadarus = _normalizeProgress(tadarusProgress);

        _iqraScore = _normalizeScore(summaryJson['iqra_score']);
        _tajwidScore = _normalizeScore(summaryJson['tajwid_score']);
        _tilawahScore = _normalizeScore(summaryJson['tilawah_score']);
        _tahfidzScore = _normalizeScore(summaryJson['tahfidz_score']);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal load profile: $e')),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _handleResetPassword() async {
    final oldPass = _oldPasswordCtrl.text.trim();
    final newPass = _newPasswordCtrl.text.trim();
    final confirmPass = _confirmPasswordCtrl.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty || confirmPass.isEmpty) {
      _showMessage('Semua field reset password wajib diisi.');
      return;
    }

    if (newPass.length < 6) {
      _showMessage('Password baru minimal 6 karakter.');
      return;
    }

    if (newPass != confirmPass) {
      _showMessage('Konfirmasi password tidak sama.');
      return;
    }

    setState(() => _resetLoading = true);

    try {
      await AuthService.resetPassword(
        oldPassword: oldPass,
        newPassword: newPass,
      );

      _oldPasswordCtrl.clear();
      _newPasswordCtrl.clear();
      _confirmPasswordCtrl.clear();

      _showMessage('Password berhasil direset.', success: true);
    } catch (e) {
      _showMessage('Reset password gagal: $e');
    } finally {
      if (mounted) setState(() => _resetLoading = false);
    }
  }

  void _showMessage(String message, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? const Color(0xFF16A34A) : null,
      ),
    );
  }

  Widget _progressTile({
    required String label,
    required double value,
    required Color color,
  }) {
    final percent = (value * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  )),
              Text('$percent%',
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.black54,
                  )),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: value,
              minHeight: 10,
              backgroundColor: Colors.grey.shade300,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _examScoreCard({
    required String title,
    required int score,
    required IconData icon,
    required List<Color> gradient,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradient),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.white24,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(
            '$score',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Widget _profileHeader() {
    final avg = ((_iqra + _tajwid + _tilawah + _tahfidz + _tadarus) / 5) * 100;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: Colors.white12,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Icon(Icons.person_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _name,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Rata-rata progress: ${avg.toStringAsFixed(1)}%',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _loadProfileProgress,
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _resetPasswordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reset Password',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _oldPasswordCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password Lama',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _newPasswordCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _confirmPasswordCtrl,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Konfirmasi Password Baru',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _resetLoading ? null : _handleResetPassword,
              icon: _resetLoading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.lock_reset_rounded),
              label: Text(_resetLoading ? 'Menyimpan...' : 'Simpan Password Baru'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF42C88A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      appBar: const CustomGradientAppBar(title: 'Profil Pengguna'),
      extendBody: true,
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadProfileProgress,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _profileHeader(),
                  const SizedBox(height: 20),
                  Text(
                    'Skor Ujian Terbaru',
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  _examScoreCard(
                    title: 'Exam Iqra',
                    score: _iqraScore,
                    icon: Icons.auto_stories_rounded,
                    gradient: const [Color(0xFF22C55E), Color(0xFF16A34A)],
                  ),
                  const SizedBox(height: 10),
                  _examScoreCard(
                    title: 'Exam Tajwid',
                    score: _tajwidScore,
                    icon: Icons.graphic_eq_rounded,
                    gradient: const [Color(0xFF38BDF8), Color(0xFF0284C7)],
                  ),
                  const SizedBox(height: 10),
                  _examScoreCard(
                    title: 'Exam Tilawah',
                    score: _tilawahScore,
                    icon: Icons.multitrack_audio_rounded,
                    gradient: const [Color(0xFFA78BFA), Color(0xFF7C3AED)],
                  ),
                  const SizedBox(height: 10),
                  _examScoreCard(
                    title: 'Exam Tahfidz',
                    score: _tahfidzScore,
                    icon: Icons.school_rounded,
                    gradient: const [Color(0xFFF59E0B), Color(0xFFEA580C)],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Progress Pembelajaran',
                    style: GoogleFonts.poppins(fontSize: 17, fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 14),
                  _progressTile(
                    label: 'Iqra',
                    value: _iqra,
                    color: const Color(0xFF42C88A),
                  ),
                  _progressTile(
                    label: 'Tajwid',
                    value: _tajwid,
                    color: Colors.blueAccent,
                  ),
                  _progressTile(
                    label: 'Tilawah',
                    value: _tilawah,
                    color: Colors.deepPurple,
                  ),
                  _progressTile(
                    label: 'Tahfidz',
                    value: _tahfidz,
                    color: Colors.orange,
                  ),
                  _progressTile(
                    label: 'Tadarus',
                    value: _tadarus,
                    color: Colors.teal,
                  ),
                  const SizedBox(height: 8),
                  _resetPasswordCard(),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
