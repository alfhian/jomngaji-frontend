import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../models/doa.dart';

class DoaDetailPage extends StatelessWidget {
  final Doa doa;

  const DoaDetailPage({super.key, required this.doa});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(doa.title),
        backgroundColor: const Color(0xFF50D1A0),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ARAB
            Text(
              doa.arab,
              textAlign: TextAlign.right,
              style: GoogleFonts.amiri(
                fontSize: 26,
                height: 1.8,
              ),
            ),

            const SizedBox(height: 24),

            // LATIN
            Text(
              doa.latin,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),

            const SizedBox(height: 16),

            // ARTI
            Text(
              doa.arti,
              style: GoogleFonts.poppins(fontSize: 14),
            ),

            const SizedBox(height: 30),

            // AUDIO BUTTON
            if (doa.audioUrl != null)
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // TODO: play audio
                  },
                  icon: const Icon(Icons.volume_up),
                  label: const Text("Putar Audio"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50D1A0),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
