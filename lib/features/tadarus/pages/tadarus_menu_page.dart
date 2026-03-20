import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../routes/app_routes.dart';
import '../../../models/surah.dart';
import '../data/quran_loader.dart';
import '../../auth/services/auth_service.dart';

class TadarusMenuPage extends StatefulWidget {
  const TadarusMenuPage({super.key});

  @override
  State<TadarusMenuPage> createState() => _TadarusMenuPageState();
}

class _TadarusMenuPageState extends State<TadarusMenuPage> {
  // ================= STATE =================

  List<Surah> _allSurahs = [];
  List<Surah> _filteredSurahs = [];
  bool _loading = true;

  double _globalProgress = 0.0;
  String _checkpointLabel = "Checkpoint 1";

  final TextEditingController _searchCtrl = TextEditingController();
  String _ayatRangeLabel = "Ayat 1–7";

  String _lastRead = "-";
  String _lastRecited = "-";

  int _completedAyahGlobal = 0;
  int _totalAyahGlobal = 0;

  // ================= LIFECYCLE =================

  @override
  void initState() {
    super.initState();
    _initPage();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ================= INIT FLOW =================

  Future<void> _initPage() async {
    setState(() => _loading = true);

    await Future.wait([
      _loadGlobalProgress(),
      _loadSurahs(),
      _loadLastActivity(),
    ]);

    setState(() => _loading = false);
  }

  // ================= API =================
  Future<void> _loadLastActivity() async {
    try {
      final headers = await AuthService.authHeaders();

      final res = await http.get(
        Uri.parse('http://10.71.164.20:4000/tadarus/last-activity'),
        headers: headers,
      );

      if (res.statusCode != 200) return;

      final json = jsonDecode(res.body);

      setState(() {
        _lastRead =
            "${json['last_read']['surah_name']}, Ayat ${json['last_read']['ayah']}";
        _lastRecited =
            "${json['last_recited']['surah_name']}, Ayat ${json['last_recited']['ayah']}";
      });
    } catch (e) {
      debugPrint("Gagal load last activity: $e");
    }
  }

  String _formatPercent(double value) {
    final percent = value * 100;
    if (percent < 1) {
      return percent.toStringAsFixed(2); // 0.02%
    }
    return percent.toStringAsFixed(1); // 12.3%
  }


  Future<void> _loadGlobalProgress() async {
    try {
      final headers = await AuthService.authHeaders();

      final res = await http.get(
        Uri.parse('http://10.71.164.20:4000/tadarus/global-progress'),
        headers: headers,
      );

      if (res.statusCode != 200) return;

      final json = jsonDecode(res.body);

      final completed = (json['completed_ayah'] ?? 0).toInt();
      final total = (json['total_ayah'] ?? 0).toInt();

      final progress =
          total > 0 ? completed / total : 0.0;

      setState(() {
        _completedAyahGlobal = completed;
        _totalAyahGlobal = total;
        _globalProgress = progress;
        _checkpointLabel = _resolveCheckpoint(progress);
      });
    } catch (e) {
      debugPrint("Gagal load global progress: $e");
    }
  }

  Future<void> _loadSurahs() async {
    try {
      final headers = await AuthService.authHeaders();
      final data = await loadQuranDataset();

      final List<Surah> result = [];

      for (final s in data) {
        double progress = 0.0;

        try {
          final res = await http.get(
            Uri.parse(
              'http://10.71.164.20:4000/tadarus/progress?surah=${s.number}',
            ),
            headers: headers,
          );

          if (res.statusCode == 200) {
            final json = jsonDecode(res.body);
            final completed = (json['completed_ayah'] ?? 0).toDouble();
            progress = s.ayahCount > 0 ? completed / s.ayahCount : 0.0;
          }
        } catch (_) {}

        result.add(s.copyWith(progress: progress));
      }

      _allSurahs = result;
      _filteredSurahs = result;
    } catch (e) {
      debugPrint("Gagal load surah: $e");
    }
  }

  // ================= LOGIC =================

  String _resolveCheckpoint(double progress) {
    final pct = (progress * 100).round();
    if (pct >= 75) return "Checkpoint 4";
    if (pct >= 50) return "Checkpoint 3";
    if (pct >= 25) return "Checkpoint 2";
    return "Checkpoint 1";
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      _filteredSurahs = q.isEmpty
          ? _allSurahs
          : _allSurahs.where((s) {
              return s.name.toLowerCase().contains(q) ||
                  s.number.toString().contains(q);
            }).toList();
    });
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const CustomGradientAppBar(title: "Tadarus"),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _progressCard(),
                  const SizedBox(height: 16),
                  _searchRow(),
                  const SizedBox(height: 16),
                  _lastActivityCard(),
                  const SizedBox(height: 16),
                  Text("Daftar Surah",
                      style: GoogleFonts.poppins(
                          fontSize: 15, fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Expanded(child: _surahList()),
                ],
              ),
            ),
    );
  }

  // ================= WIDGETS =================

  Widget _progressCard() {
    final percentText = _formatPercent(_globalProgress);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7FFF2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF42C88A),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.menu_book_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lanjutkan Khatam Al-Qur’an",
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                // 👇 TOTAL AYAT
                Text(
                  "$_completedAyahGlobal / $_totalAyahGlobal Ayat",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _globalProgress,
                          minHeight: 8,
                          backgroundColor: Colors.grey.shade300,
                          color: const Color(0xFF42C88A),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$percentText%",
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  _checkpointLabel,
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
    );
  }

  Widget _searchRow() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: "Cari Surah",
        hintStyle: GoogleFonts.poppins(fontSize: 14),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchCtrl.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchCtrl.clear();
                  _applyFilter();
                },
              )
            : null,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 14,
          horizontal: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _lastActivityCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05), blurRadius: 6)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Aktivitas Terakhir",
              style: GoogleFonts.poppins(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text("Terakhir Dibaca: $_lastRead",
              style: GoogleFonts.poppins(fontSize: 13)),
          Text("Terakhir Dilafalkan: $_lastRecited",
              style: GoogleFonts.poppins(fontSize: 13)),
        ],
      ),
    );
  }

  Widget _surahList() {
    return ListView.builder(
      itemCount: _filteredSurahs.length,
      itemBuilder: (context, index) {
        final s = _filteredSurahs[index];
        final percent = (s.progress * 100).toStringAsFixed(0);

        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.tadarus,
              arguments: s,
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 6)
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.name,
                    style: GoogleFonts.poppins(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text("${s.ayahCount} Ayat",
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: Colors.black54)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: s.progress,
                        backgroundColor: Colors.grey.shade300,
                        color: const Color(0xFF42C88A),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "$percent%",
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
