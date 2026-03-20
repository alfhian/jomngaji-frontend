import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/widgets/custom_gradient_appbar.dart';
import '../../../services/progress_service.dart'; // Untuk progress tracking

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int totalXP = 0;  // Pastikan menggunakan satu variabel untuk XP
  int examScore = 0;
  List<bool> levelsCompleted = List.generate(10, (index) => false); // 10 level
  List<FlSpot> xpData = [];

  @override
  void initState() {
    super.initState();
    loadData();  // Pastikan loadData dipanggil saat halaman dibuka
  }

  void loadData() async {
    totalXP = await ProgressService.getXP();  // Ambil XP dari SharedPreferences
    examScore = await ProgressService.getExamScore();  // Ambil skor tes dari SharedPreferences

    // Update grafik dengan XP yang benar-benar terbaru
    xpData = [
      FlSpot(0, totalXP.toDouble()),  // Grafik menunjukkan XP yang aktual
      FlSpot(1, totalXP.toDouble() + 10),
      FlSpot(2, totalXP.toDouble() + 20),
      FlSpot(3, totalXP.toDouble() + 30),
    ];

    setState(() {});  // Memperbarui UI dengan data terbaru
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomGradientAppBar(title: 'Profil Pengguna'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Profil & Progress',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            _buildProfileInfo(),
            const SizedBox(height: 20),
            _buildLevelProgress(),
            const SizedBox(height: 20),
            _buildXpChart(),
            const SizedBox(height: 20),
            _buildExamScore(),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileInfo() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.account_circle, size: 50, color: Color(0xFF42C88A)),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nama Pengguna', style: GoogleFonts.poppins(fontSize: 18)),
                const SizedBox(height: 8),
                Text('XP: $totalXP', style: GoogleFonts.poppins(fontSize: 14)),  // Gunakan totalXP yang sama
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLevelProgress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Level Progress', style: GoogleFonts.poppins(fontSize: 18)),
        const SizedBox(height: 8),
        Wrap(
          children: List.generate(10, (index) {
            return Icon(
              levelsCompleted[index] ? Icons.check_circle : Icons.circle,
              color: levelsCompleted[index] ? Colors.green : Colors.grey,
            );
          }),
        ),
      ],
    );
  }

  Widget _buildXpChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Grafik XP', style: GoogleFonts.poppins(fontSize: 18)),
        const SizedBox(height: 8),
        SizedBox(
          height: 200,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              minX: 0,
              maxX: 3,
              minY: 0,
              maxY: totalXP + 50,  // Gunakan totalXP yang sama untuk grafik
              lineBarsData: [
                LineChartBarData(
                  spots: xpData,
                  isCurved: true,
                  colors: [Color(0xFF42C88A)],
                  barWidth: 4,
                  isStrokeCapRound: true,
                  belowBarData: BarAreaData(show: false),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExamScore() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Skor Tes Akhir', style: GoogleFonts.poppins(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          'Skor kamu: $examScore',
          style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
