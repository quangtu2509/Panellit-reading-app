import 'package:flutter/material.dart';

import '../widgets/auth_text_field.dart';
import 'register_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_divider_with_text.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/auth_page_header.dart';
import '../widgets/auth_section_icon.dart';
import '../widgets/auth_social_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  static const String _mockEmail = 'user123@gmail.com';
  static const String _mockPassword = 'user123';

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (email != _mockEmail || password != _mockPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid email or password.')),
      );
      return;
    }
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage(isGuest: false)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight - topPadding),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(
                  minHeight: screenHeight - topPadding,
                ),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                decoration: const BoxDecoration(
                  color: AuthColors.pageBackground,
                ),
                child: Column(
                  children: [
                    const AuthPageHeader(
                      icon: AuthSectionIcon(icon: Icons.menu_book_rounded),
                      title: 'Welcome Back',
                      subtitle:
                          'Continue your journey through the world of books.',
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AuthColors.softSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AuthColors.border),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Email',
                            style: TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthTextField(
                            hintText: 'name@example.com',
                            icon: Icons.mail_outline_rounded,
                            controller: _emailController,
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Password',
                            style: TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthTextField(
                            hintText: '........',
                            icon: Icons.lock_outline_rounded,
                            obscureText: true,
                            controller: _passwordController,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AuthColors.accent,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: const Size(0, 0),
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Forgot password?',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: AuthColors.label,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          AuthGradientButton(
                            label: 'Login',
                            icon: Icons.arrow_forward,
                            onPressed: _handleLogin,
                          ),
                          const SizedBox(height: 16),
                          const AuthDividerWithText(text: 'or continue with'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: AuthSocialButton(
                                  icon: Icons.no_accounts_outlined,
                                  label: 'Login as Guest',
                                  iconColor: AuthColors.guestIcon,
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const HomePage(isGuest: true),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text.rich(
                      TextSpan(
                        style: TextStyle(
                          color: AuthColors.footerText,
                          fontSize: 12,
                        ),
                        children: [
                          TextSpan(text: 'By continuing, you agree to our '),
                          TextSpan(
                            text: 'Terms of Service.',
                            style: TextStyle(
                              color: AuthColors.accent,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
