import 'package:flutter/material.dart';
import '../../../core/widgets/search_field.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          _backgroundHeader(),
          const Positioned(
            left: 20,
            right: 20,
            bottom: -25, // supaya floating naik sedikit
            child: Material(
              elevation: 6,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              child: SearchField(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _backgroundHeader() {
    return Container(
      width: double.infinity,
      height: 230,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        image: const DecorationImage(
          image: AssetImage("assets/images/home_banner.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // gradient overlay biar teks tetap terbaca
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.0),
              Colors.black.withOpacity(0.4),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            SizedBox(height: 8),
            Text(
              "Assalamu’alaikum, Dylan",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 18,
              ),
            ),
            SizedBox(height: 4),
            Text(
              "Semoga ngaji hari ini berkah ✨",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
            SizedBox(height: 24),
            Text(
              "Temukan kelas\nngaji favoritmu!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Belajar Iqra, Tajwid, dan Tilawah",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
