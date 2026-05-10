import 'package:flutter/material.dart';

import '../../../../core/services/auth_service.dart';
import 'login_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../theme/auth_colors.dart';

/// Splash screen shown at app startup.
///
/// While the logo is visible, it checks the device keychain for a stored JWT.
/// - Token found  → navigate directly to [HomePage] (logged-in)
/// - No token     → navigate to [LoginPage]
///
/// This gives users a seamless "stay logged in" experience across sessions.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Fade-in animation for the logo
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _checkSession();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _checkSession() async {
    // Give the logo animation a moment to show
    await Future.delayed(const Duration(milliseconds: 900));

    if (!mounted) return;

    final isLoggedIn = await AuthService.instance.isLoggedIn();

    if (!mounted) return;

    if (isLoggedIn) {
      _navigateTo(const HomePage(isGuest: false));
    } else {
      _navigateTo(const LoginPage());
    }
  }

  void _navigateTo(Widget page) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation, _) => page,
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        transitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AuthColors.pageBackground,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // App icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: AuthColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  size: 54,
                  color: AuthColors.accent,
                ),
              ),
              const SizedBox(height: 20),
              // Brand name
              const Text(
                'Panellit',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                  color: AuthColors.accent,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your story universe',
                style: TextStyle(
                  fontSize: 14,
                  color: AuthColors.label,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 48),
              // Loading indicator
              SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Color.fromRGBO(26, 158, 217, 0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
