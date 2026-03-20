import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../features/auth/services/auth_service.dart';
import '../../../routes/app_routes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  bool isGoogleLoading = false;

  Future<void> _handleLogin() async {
    setState(() => isLoading = true);
    try {
      await AuthService.login(emailController.text, passwordController.text);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _handleGoogleLogin() async {
    setState(() => isGoogleLoading = true);
    try {
      final googleSignIn = GoogleSignIn(scopes: ['email']);
      final account = await googleSignIn.signIn();
      if (account == null) return;

      final auth = await account.authentication;
      final idToken = auth.idToken;

      if (idToken == null || idToken.isEmpty) {
        throw Exception('Google ID token tidak tersedia');
      }

      await AuthService.loginWithGoogle(idToken);
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Google login gagal: $e')),
      );
    } finally {
      if (mounted) setState(() => isGoogleLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Selamat datang 👋',
                  style: GoogleFonts.poppins(
                      fontSize: 24, fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Text('Silakan login untuk melanjutkan',
                  style: GoogleFonts.poppins(
                      fontSize: 14, color: Colors.grey.shade600)),
              const SizedBox(height: 32),

              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email_outlined),
                  labelText: 'Email',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),

              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  labelText: 'Password',
                  border:
                      OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: isLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Text('Login'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: (isLoading || isGoogleLoading) ? null : _handleLogin,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.g_mobiledata, size: 22),
                  label: isGoogleLoading
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Login dengan Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: (isLoading || isGoogleLoading)
                      ? null
                      : _handleGoogleLogin,
                ),
              ),

              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pushNamed(context, AppRoutes.register),
                  child: const Text('Belum punya akun? Register'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
