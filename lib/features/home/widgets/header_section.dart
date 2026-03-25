import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/localization/app_localization.dart';
import '../../auth/services/auth_service.dart';

class HeaderSection extends StatefulWidget {
  const HeaderSection({super.key});

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  String _userName = 'Sahabat';

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final name = await AuthService.getUserName();
    if (!mounted || name == null || name.trim().isEmpty) return;
    setState(() => _userName = name.trim());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 230),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(34),
          bottomRight: Radius.circular(34),
        ),
        image: const DecorationImage(
          image: AssetImage('assets/images/home_banner.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xD9152238),
              Color(0xCC1D4ED8),
              Color(0xCC0F766E),
            ],
          ),
          border: Border.all(color: Colors.white24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x30000000),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white30),
                  ),
                  child: Text(
                    '✨ Daily Motivation',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              l10n.text('home.greeting', params: {'name': _userName}),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 17,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              l10n.text('home.subtitle'),
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.9),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 18),
            Text(
              l10n.text('home.findClass'),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.15,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.text('home.learnTopics'),
              style: GoogleFonts.poppins(
                color: Colors.white.withOpacity(0.88),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
