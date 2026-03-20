import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const JomNgajiApp());
}

class JomNgajiApp extends StatelessWidget {
  const JomNgajiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "JomNgaji",
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,

        // ========================================
        // 1. Default UI Font = Poppins
        // ========================================
        textTheme: GoogleFonts.poppinsTextTheme(),

        // ========================================
        // 2. IMPORTANT FIX:
        // Pastikan Arab tidak kena override Poppins
        // ========================================
        fontFamilyFallback: [
          'Cairo',     // untuk huruf Arab
          'Amiri',     // fallback arab tambahan
          'Roboto',    // fallback default
        ],

        // ========================================
        // 3. AppBar tetap pakai Cairo (lebih Islami)
        // ========================================
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green, // bisa gradient di custom widget
        ),
      ),

      initialRoute: AppRoutes.home,
      routes: AppRoutes.routes,
    );
  }
}
