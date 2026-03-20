import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/auth/services/auth_service.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final loggedIn = await AuthService.isLoggedIn();
  runApp(JomNgajiApp(isLoggedIn: loggedIn));
}

class JomNgajiApp extends StatelessWidget {
  final bool isLoggedIn;

  const JomNgajiApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JomNgaji',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.poppinsTextTheme(),
        fontFamilyFallback: const [
          'Cairo',
          'Amiri',
          'Roboto',
        ],
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
          foregroundColor: Colors.white,
          backgroundColor: Colors.green,
        ),
      ),
      initialRoute: isLoggedIn ? AppRoutes.home : AppRoutes.login,
      routes: AppRoutes.routes,
      onGenerateRoute: AppRoutes.onGenerateRoute,
    );
  }
}
