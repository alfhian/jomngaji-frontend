import 'package:flutter/material.dart';

// Auth
import '../features/auth/pages/login_page.dart';
import '../features/auth/pages/register_page.dart';

// Home
import '../features/home/pages/home_page.dart';
import '../features/home/pages/profile_page.dart';
import '../features/home/pages/daily_quiz_page.dart';

// Iqra
import '../features/iqra/pages/iqra_dasar_page.dart';
import '../features/iqra/pages/latihan_baca_page.dart';
import '../features/iqra/pages/pengucapan_page.dart';
import '../features/iqra/pages/detail_huruf_hijaiyah_page.dart';
import '../features/iqra/pages/exam_iqra_page.dart';
import '../features/iqra/pages/latihan_pengucapan_page.dart';
import '../features/iqra/pages/materi_hijaiyah_page.dart';
import '../features/iqra/pages/materi_huruf_detail_page.dart';
import '../features/iqra/pages/latihan_harakat_page.dart';
import '../features/iqra/pages/latihan_suku_kata_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level2_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level3_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level4_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level5_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level6_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level7_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level8_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level9_page.dart';
import '../features/iqra/pages/latihan_suku_kata_level10_page.dart';
import '../features/iqra/pages/latihan_suku_kata_menu_page.dart';
import '../features/iqra/pages/dengarkan_tebak_page.dart';

// Tajwid
import '../features/tajwid/pages/tajwid_dasar_page.dart';
import '../features/tajwid/pages/exam_tajwid_page.dart';
import '../features/tajwid/pages/materi_tajwid_page.dart';
import '../features/tajwid/pages/materi_nun_tanwin_page.dart';
import '../features/tajwid/pages/materi_mim_mati_page.dart';
import '../features/tajwid/pages/materi_mad_page.dart';
import '../features/tajwid/pages/materi_qalqalah_page.dart';
import '../features/tajwid/pages/materi_ghunnah_page.dart';
import '../features/tajwid/pages/latihan_tajwid_page.dart';
import '../features/tajwid/pages/latihan_mim_mati_menu_page.dart';
import '../features/tajwid/pages/latihan_mim_mati_pilihan_page.dart';
import '../features/tajwid/pages/latihan_mim_mati_recording_page.dart';
import '../features/tajwid/pages/latihan_nun_tanwin_menu_page.dart';
import '../features/tajwid/pages/latihan_nun_tanwin_pilihan_page.dart';
import '../features/tajwid/pages/latihan_nun_tanwin_recording_page.dart';
import '../features/tajwid/pages/latihan_mad_menu_page.dart';
import '../features/tajwid/pages/latihan_mad_pilihan_page.dart';
import '../features/tajwid/pages/latihan_mad_recording_page.dart';
import '../features/tajwid/pages/latihan_qalqalah_menu_page.dart';
import '../features/tajwid/pages/latihan_qalqalah_pilihan_page.dart';
import '../features/tajwid/pages/latihan_qalqalah_recording_page.dart';
import '../features/tajwid/pages/latihan_ghunnah_menu_page.dart';
import '../features/tajwid/pages/latihan_ghunnah_pilihan_page.dart';
import '../features/tajwid/pages/latihan_ghunnah_recording_page.dart';

// Tilawah
import '../features/tilawah/pages/tilawah_menu_page.dart';
import '../features/tilawah/pages/latihan_tilawah_pilihan_page.dart';
import '../features/tilawah/pages/latihan_tilawah_recording_page.dart';

// Tahfidz
import '../features/tahfidz/pages/tahfidz_menu_page.dart';
import '../features/tahfidz/pages/latihan_tahfidz_pilihan_page.dart';
import '../features/tahfidz/pages/latihan_tahfidz_recording_page.dart';

// Tadarus
import '../features/tadarus/pages/tadarus_menu_page.dart';
import '../features/tadarus/pages/tadarus_detail_page.dart';
import '../models/surah.dart';

// Doa
import '../features/doa/pages/doa_menu_page.dart';
import '../features/doa/pages/doa_detail_page.dart';
import '../models/doa.dart';


class AppRoutes {
  // ========== ROUTE NAME ==========
  static const login = "/login";
  static const register = "/register";
  static const home = "/";
  static const profile = "/profile";

  // Iqra
  static const iqraDasar = '/iqra-dasar';
  static const examIqra = '/exam-iqra';
  static const materiHijaiyah = '/materi-hijaiyah';
  static const materiHurufDetail = '/materi-huruf-detail';
  static const latihanPengucapan = '/latihan-pengucapan';
  static const latihanBaca = '/latihan-baca';
  static const latihanHarakat = '/latihan-harakat';
  static const latihanSukuKata = '/latihan-suku-kata';
  static const latihanSukuKataMenu = '/latihan-suku-kata-menu';
  static const latihanSukuKataLevel2 = '/latihan-suku-kata-level2';
  static const latihanSukuKataLevel3 = '/latihan-suku-kata-level3';
  static const latihanSukuKataLevel4 = '/latihan-suku-kata-level4';
  static const latihanSukuKataLevel5 = '/latihan-suku-kata-level5';
  static const latihanSukuKataLevel6 = '/latihan-suku-kata-level6';
  static const latihanSukuKataLevel7 = '/latihan-suku-kata-level7';
  static const latihanSukuKataLevel8 = '/latihan-suku-kata-level8';
  static const latihanSukuKataLevel9 = '/latihan-suku-kata-level9';
  static const latihanSukuKataLevel10 = '/latihan-suku-kata-level10';
  static const pengucapan = '/pengucapan';
  static const detailHuruf = '/detail-huruf';
  static const latihanDengar = '/latihan-dengar';

  // Tajwid
  static const tajwidDasar = '/tajwid-dasar';
  static const examTajwid = '/exam-tajwid';
  static const materiTajwid = '/materi-tajwid';
  static const materiNunTanwin = '/materi-nun-tanwin';
  static const materiMimMati = '/materi-mim-mati';
  static const materiMad = '/materi-mad';
  static const materiQalqalah = '/materi-qalqalah';
  static const materiGhunnah = '/materi-ghunnah';
  static const latihanTajwid = '/latihan-tajwid';
  static const latihanMimMatiMenu = "/latihan-mim-mati-menu";
  static const latihanMimMatiPilihan = "/latihan-mim-mati-pilihan";
  static const latihanMimMatiRecording = "/latihan-mim-mati-recording";
  static const latihanNunTanwinMenu = "/latihan-nun-tanwin-menu";
  static const latihanNunTanwinPilihan = "/latihan-nun-tanwin-pilihan";
  static const latihanNunTanwinRecording = "/latihan-nun-tanwin-recording";
  static const latihanMadMenu = "/latihan-mad-menu";
  static const latihanMadPilihan = "/latihan-mad-pilihan";
  static const latihanMadRecording = "/latihan-mad-recording";
  static const latihanQalqalahMenu = "/latihan-qalqalah-menu";
  static const latihanQalqalahPilihan = "/latihan-qalqalah-pilihan";
  static const latihanQalqalahRecording = "/latihan-qalqalah-recording";
  static const latihanGhunnahMenu = "/latihan-ghunnah-menu";
  static const latihanGhunnahPilihan = "/latihan-ghunnah-pilihan";
  static const latihanGhunnahRecording = "/latihan-ghunnah-recording";

  // Tilawah
  static const tilawahMenu = "/tilawah-menu";
  static const latihanTilawahPilihan = "/latihan-tilawah-pilihan";
  static const latihanTilawahRecording = "/latihan-tilawah-recording";

  // Tahfidz
  static const tahfidzMenu = "/tahfidz-menu";
  static const latihanTahfidzPilihan = "/latihan-tahfidz-pilihan";
  static const latihanTahfidzRecording = "/latihan-tahfidz-recording";

  // Tadarus
  static const dailyQuiz = "/daily-quiz";
  static const tadarusMenu = "/tadarus-menu";
  static const tadarus = "/tadarus";

  // Doa
  static const doaMenu = "/doa-menu";
  static const doaDetail = "/doa-detail";

  // ========== ROUTING ==========
  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginPage(),
    register: (_) => const RegisterPage(),
    home: (_) => const HomePage(),
    profile: (_) => const ProfilePage(),

    // Iqra
    iqraDasar: (_) => const IqraDasarPage(),
    examIqra: (_) => const ExamIqraPage(),
    materiHijaiyah: (_) => const MateriHijaiyahPage(),
    materiHurufDetail: (_) => const MateriHurufDetailPage(
          lessonTitle: '',
          hurufList: [], 
          lessonId: 0,
        ),
    latihanPengucapan: (_) => const LatihanPengucapanPage(
          hurufList: [],
          lessonTitle: '',
          lessonId: 0,
        ),
    latihanBaca: (_) => const LatihanBacaPage(),
    pengucapan: (_) => const PengucapanPage(),
    latihanHarakat: (_) => const LatihanHarakatPage(),
    latihanSukuKata: (_) => const LatihanSukuKataPage(),
    latihanSukuKataMenu: (_) => const LatihanSukuKataMenuPage(),
    latihanSukuKataLevel2: (_) => const LatihanSukuKataLevel2Page(),
    latihanSukuKataLevel3: (_) => const LatihanSukuKataLevel3Page(),
    latihanSukuKataLevel4: (_) => const LatihanSukuKataLevel4Page(),
    latihanSukuKataLevel5: (_) => const LatihanSukuKataLevel5Page(),
    latihanSukuKataLevel6: (_) => const LatihanSukuKataLevel6Page(),
    latihanSukuKataLevel7: (_) => const LatihanSukuKataLevel7Page(),
    latihanSukuKataLevel8: (_) => const LatihanSukuKataLevel8Page(),
    latihanSukuKataLevel9: (_) => const LatihanSukuKataLevel9Page(),
    latihanSukuKataLevel10: (_) => const LatihanSukuKataLevel10Page(),
    latihanDengar: (_) => const DengarkanTebakPage(),

    // Tajwid
    tajwidDasar: (_) => const TajwidDasarPage(),
    examTajwid: (_) => const ExamTajwidPage(),
    materiTajwid: (_) => const MateriTajwidPage(),
    latihanTajwid: (_) => const LatihanTajwidMenuPage(),
    materiNunTanwin: (_) => const MateriNunTanwinPage(),
    materiMimMati: (_) => const MateriMimMatiPage(),
    materiMad: (_) => const MateriMadPage(),
    materiQalqalah: (_) => const MateriQalqalahPage(),
    materiGhunnah: (_) => const MateriGhunnahPage(),
    latihanMimMatiMenu: (_) => const LatihanMimMatiMenuPage(),
    latihanMimMatiPilihan: (_) => const LatihanMimMatiPilihanPage(),
    latihanMimMatiRecording: (_) => const LatihanMimMatiRecordingPage(),
    latihanNunTanwinMenu: (_) => const LatihanNunTanwinMenuPage(),
    latihanNunTanwinPilihan: (_) => const LatihanNunTanwinPilihanPage(),
    latihanNunTanwinRecording: (_) => const LatihanNunTanwinRecordingPage(),
    latihanMadMenu: (_) => const LatihanMadMenuPage(),
    latihanMadPilihan: (_) => const LatihanMadPilihanPage(),
    latihanMadRecording: (_) => const LatihanMadRecordingPage(),
    latihanQalqalahMenu: (_) => const LatihanQalqalahMenuPage(),
    latihanQalqalahPilihan: (_) => const LatihanQalqalahPilihanPage(),
    latihanQalqalahRecording: (_) => const LatihanQalqalahRecordingPage(),
    latihanGhunnahMenu: (_) => const LatihanGhunnahMenuPage(),
    latihanGhunnahPilihan: (_) => const LatihanGhunnahPilihanPage(),
    latihanGhunnahRecording: (_) => const LatihanGhunnahRecordingPage(),

    // Tilawah
    tilawahMenu: (_) => const TilawahMenuPage(),
    latihanTilawahPilihan: (_) => const LatihanTilawahPilihanPage(),
    latihanTilawahRecording: (_) => const LatihanTilawahRecordingPage(),

    // Tahfidz
    tahfidzMenu: (_) => const TahfidzMenuPage(),
    latihanTahfidzPilihan: (_) => const LatihanTahfidzPilihanPage(),
    latihanTahfidzRecording: (_) => const LatihanTahfidzRecordingPage(),

    // Tadarus & Quiz
    dailyQuiz: (_) => const DailyQuizPage(),
    tadarusMenu: (_) => TadarusMenuPage(),

    // Doa
    doaMenu: (_) => const DoaMenuPage(),
  };

  // ========== ROUTE DYNAMIC ==========
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    if (settings.name == tadarus) {
      final surah = settings.arguments as Surah;
      return MaterialPageRoute(
        builder: (_) => TadarusDetailPage(surah: surah),
      );
    }

    if (settings.name == doaDetail) {
      final doa = settings.arguments as Doa;
      return MaterialPageRoute(
        builder: (_) => DoaDetailPage(doa: doa),
      );
    }

    if (settings.name == detailHuruf) {
      final args = settings.arguments as Map<String, dynamic>;
      return MaterialPageRoute(
        builder: (_) => DetailHurufHijaiyahPage(
          huruf: args["huruf"],
          nama: args["nama"],
          caraBaca: args["caraBaca"],
          awal: args["awal"],
          tengah: args["tengah"],
          akhir: args["akhir"],
          fathah: args["fathah"],
          kasrah: args["kasrah"],
          dhammah: args["dhammah"],
          tanwinFathah: args["tanwinFathah"],
          tanwinKasrah: args["tanwinKasrah"],
          tanwinDhammah: args["tanwinDhammah"],
        ),
      );
    }

    return null;
  }
}
