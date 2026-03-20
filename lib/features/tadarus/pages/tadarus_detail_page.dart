import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:http/http.dart' as http;

import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../auth/services/auth_service.dart';
import '../data/quran_loader.dart';
import '../../../models/surah.dart';
import 'evaluate_page.dart';

class TadarusDetailPage extends StatefulWidget {
  final Surah surah;

  const TadarusDetailPage({super.key, required this.surah});

  @override
  State<TadarusDetailPage> createState() => _TadarusDetailPageState();
}

class _TadarusDetailPageState extends State<TadarusDetailPage> {
  Surah? surah;
  double progressValue = 0.0;

  int _currentAyahIndex = 0;
  int? _playingIndex;

  bool _ignoreCompletion = false;

  final Map<int, GlobalKey> _ayahKeys = {};

  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();

    _player = AudioPlayer();
    _player.setVolume(3.5);
    _player.setSpeed(1.0);

    _initAudioSession();
    _loadSurahAndProgress();

    _player.processingStateStream.listen((state) async {
      if (state != ProcessingState.completed) return;
      if (_ignoreCompletion) {
        _ignoreCompletion = false;
        return;
      }

      final next = _currentAyahIndex + 1;
      if (surah != null && next < surah!.ayahs.length) {
        _playAyahAudio(next);
      } else {
        await _player.stop();
        setState(() => _playingIndex = null);
      }
    });
  }

  Future<void> _initAudioSession() async {
    final session = await AudioSession.instance;
    await session.configure(
      const AudioSessionConfiguration(
        avAudioSessionCategory: AVAudioSessionCategory.playback,
        androidAudioAttributes: AndroidAudioAttributes(
          usage: AndroidAudioUsage.media,
          contentType: AndroidAudioContentType.music,
        ),
      ),
    );
  }

  // ===================== 🔥 BACKEND PROGRESS =====================
  Future<int> _fetchCompletedAyahCount(int surahNumber) async {
    final headers = await AuthService.authHeaders();
    final res = await http.get(
      Uri.parse(
        'http://192.168.1.141:4000/tadarus/progress?surah=$surahNumber',
      ),
      headers: headers,
    );

    if (res.statusCode != 200) return 0;

    final json = jsonDecode(res.body);
    return json['completed_ayah'] ?? 0; // <-- ini harus sesuai key API
  }

  Future<void> _loadSurahAndProgress() async {
    final s = await loadSurahDetail(widget.surah.number);

    final completed = await _fetchCompletedAyahCount(s.number);

    final index =
        completed.clamp(0, s.ayahs.length - 1);

    setState(() {
      surah = s;
      progressValue = completed / s.ayahs.length;
      _currentAyahIndex = index;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToAyah(index);
    });
  }

  // ===================== AUDIO =====================
  Future<void> _playAyahAudio(int index) async {
    if (surah == null) return;
    if (index < 0 || index >= surah!.ayahs.length) return;

    final s = surah!.number.toString().padLeft(3, '0');
    final a = index.toString().padLeft(3, '0');
    final asset = 'assets/audio/tadarus/$s$a.mp3';

    try {
      if (_playingIndex == index && _player.playing) {
        await _player.pause();
        return;
      }

      if (_playingIndex != index) {
        await _player.stop();
        await _player.setAsset(asset);

        setState(() {
          _playingIndex = index;
          _currentAyahIndex = index;
          progressValue = (index + 1) / surah!.ayahs.length;
        });

        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scrollToAyah(index);
        });
      }

      await _player.play();
    } catch (e) {
      _showError("Audio gagal diputar:\n$e");
    }
  }

  void _scrollToAyah(int index) {
    final key = _ayahKeys[index];
    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 400),
        alignment: 0.3,
      );
    }
  }

  void _playNextAyah() => _playAyahAudio(_currentAyahIndex + 1);
  void _playPreviousAyah() => _playAyahAudio(_currentAyahIndex - 1);

  void _onEvaluateAyah(Ayah ayah) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EvaluatePage(
          surah: surah!,
          ayah: ayah,
        ),
      ),
    );

    // 🔥 refresh progress setelah evaluasi
    await _loadSurahAndProgress();
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    if (surah == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: const CustomGradientAppBar(title: "Tadarus AI"),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _headerCard(surah!),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: surah!.ayahs.length,
                itemBuilder: (context, index) {
                  final ayah = surah!.ayahs[index];
                  final isActive = _playingIndex == index;
                  final key =
                      _ayahKeys.putIfAbsent(index, () => GlobalKey());

                  return Container(
                    key: key,
                    child: _ayahBlock(ayah, isActive),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _playerControls(),
    );
  }

  Widget _playerControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            onPressed: _playPreviousAyah,
            icon: const Icon(Icons.skip_previous),
            iconSize: 32,
          ),
          IconButton(
            icon: Icon(
              _player.playing ? Icons.pause : Icons.play_arrow,
              size: 36,
            ),
            onPressed: () => _playAyahAudio(_currentAyahIndex),
          ),
          IconButton(
            onPressed: _playNextAyah,
            icon: const Icon(Icons.skip_next),
            iconSize: 32,
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS =====================
  Widget _headerCard(Surah surah) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFE7FFF2),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(surah.name,
              style: GoogleFonts.poppins(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(
            "Surah ke-${surah.number}, ${surah.ayahs.length} ayat",
            style: GoogleFonts.poppins(fontSize: 13),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: progressValue,
            minHeight: 8,
            backgroundColor: Colors.grey.shade300,
            color: const Color(0xFF42C88A),
          ),
          const SizedBox(height: 6),
          Text(
            "${(progressValue * 100).toStringAsFixed(0)}% selesai",
            style: GoogleFonts.poppins(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _ayahBlock(Ayah ayah, bool isActive) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFE6FFF2) : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Ayat ${ayah.ayah}",
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          const SizedBox(height: 14),
          Directionality(
            textDirection: TextDirection.rtl,
            child: Text(
              ayah.text,
              textAlign: TextAlign.right, // 🔥 INI KUNCINYA
              style: GoogleFonts.amiri(
                fontSize: 28,
                height: 2,
              ),
            ),
          ),
          if (ayah.transliteration?.isNotEmpty == true) ...[
            const SizedBox(height: 12),
            Text(ayah.transliteration!,
                style: GoogleFonts.notoSerif(
                    fontStyle: FontStyle.italic)),
          ],
          if (ayah.translation?.isNotEmpty == true) ...[
            const SizedBox(height: 8),
            Text(ayah.translation!,
                style: GoogleFonts.poppins())],
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: () => _onEvaluateAyah(ayah),
              icon: const Icon(Icons.record_voice_over),
              label: const Text("Rekam & Nilai Ayat Ini"),
            ),
          ),
        ],
      ),
    );
  }
}
