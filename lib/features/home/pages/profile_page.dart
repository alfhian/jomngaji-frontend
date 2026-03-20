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
  static const _baseUrl = 'http://192.168.1.141:4000';

  bool _loading = true;
  String _name = 'Pengguna';

  double _iqra = 0;
  double _tajwid = 0;
  double _tilawah = 0;
  double _tahfidz = 0;
  double _tadarus = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileProgress();
    });
  }

  double _normalizeProgress(dynamic value) {
    final raw = double.tryParse('${value ?? 0}') ?? 0;
    if (raw > 1) return (raw / 100).clamp(0, 1);
    return raw.clamp(0, 1);
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

      final avgRes = await http.get(
        Uri.parse('$_baseUrl/progress/average'),
        headers: headers,
      );

      final tadarusRes = await http.get(
        Uri.parse('$_baseUrl/tadarus/global-progress'),
        headers: headers,
      );

      if (avgRes.statusCode != 200) {
        throw Exception('Gagal mengambil progress average: ${avgRes.body}');
      }
      if (tadarusRes.statusCode != 200) {
        throw Exception('Gagal mengambil progress tadarus: ${tadarusRes.body}');
      }

      final avgJson = jsonDecode(avgRes.body) as Map<String, dynamic>;
      final tadarusJson = jsonDecode(tadarusRes.body) as Map<String, dynamic>;

      final tadarusProgress = tadarusJson['percentage'] ??
          ((tadarusJson['total_ayah'] ?? 0) == 0
              ? 0
              : ((tadarusJson['completed_ayah'] ?? 0) /
                  (tadarusJson['total_ayah'] ?? 1)));

      setState(() {
        _name = userName;
        _iqra = _normalizeProgress(avgJson['iqra_avg']);
        _tajwid = _normalizeProgress(avgJson['tajwid_avg']);
        _tilawah = _normalizeProgress(avgJson['tilawah_avg']);
        _tahfidz = _normalizeProgress(avgJson['tahfidz_avg']);
        _tadarus = _normalizeProgress(tadarusProgress);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE7FFF2),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_circle,
                            size: 50, color: Color(0xFF42C88A)),
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
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Progress belajar dari Iqra sampai Tadarus',
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Progress Pembelajaran',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 14),
                  _progressTile(
                      label: 'Iqra',
                      value: _iqra,
                      color: const Color(0xFF42C88A)),
                  _progressTile(
                      label: 'Tajwid',
                      value: _tajwid,
                      color: Colors.blueAccent),
                  _progressTile(
                      label: 'Tilawah',
                      value: _tilawah,
                      color: Colors.deepPurple),
                  _progressTile(
                      label: 'Tahfidz',
                      value: _tahfidz,
                      color: Colors.orange),
                  _progressTile(
                      label: 'Tadarus',
                      value: _tadarus,
                      color: Colors.teal),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
