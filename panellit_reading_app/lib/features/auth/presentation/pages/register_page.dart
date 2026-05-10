import 'package:flutter/material.dart';

import '../../../../core/services/auth_service.dart';
import '../widgets/auth_text_field.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../theme/auth_colors.dart';
import '../widgets/auth_divider_with_text.dart';
import '../widgets/auth_gradient_button.dart';
import '../widgets/auth_inline_link.dart';
import '../widgets/auth_page_header.dart';
import '../widgets/auth_section_icon.dart';
import '../widgets/auth_social_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController           = TextEditingController();
  final TextEditingController _passwordController        = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  Future<void> _handleRegister() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirm  = _confirmPasswordController.text.trim();

    // Client-side validation
    if (email.isEmpty || password.isEmpty) {
      _showError('Please fill in all fields.');
      return;
    }
    if (password != confirm) {
      _showError('Passwords do not match.');
      return;
    }
    if (password.length < 6) {
      _showError('Password must be at least 6 characters.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.register(email, password);
      if (!mounted) return;
      // Auto-login: navigate directly to HomePage after successful register
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomePage(isGuest: false)),
      );
    } catch (e) {
      if (!mounted) return;
      _showError(e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFB13B39),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final topPadding   = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: SizedBox.expand(
          child: SingleChildScrollView(
            padding: EdgeInsets.zero,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: screenHeight - topPadding),
              child: Container(
                width: double.infinity,
                constraints: BoxConstraints(minHeight: screenHeight - topPadding),
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                decoration: const BoxDecoration(color: AuthColors.pageBackground),
                child: Column(
                  children: [
                    const AuthPageHeader(
                      icon: AuthSectionIcon(
                        icon: Icons.person_outline_rounded,
                        size: 90,
                      ),
                      title: 'Create your account',
                      subtitle: 'Join the Panellit community of story lovers',
                    ),
                    const SizedBox(height: 28),
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
                          // ── Email ────────────────────────────────────────
                          const Text(
                            'EMAIL',
                            style: TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthTextField(
                            controller: _emailController,
                            hintText: 'hello@example.com',
                            icon: Icons.mail_outline_rounded,
                          ),
                          const SizedBox(height: 16),
                          // ── Password ─────────────────────────────────────
                          const Text(
                            'PASSWORD',
                            style: TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthTextField(
                            controller: _passwordController,
                            hintText: 'Min. 6 characters',
                            icon: Icons.lock_outline_rounded,
                            obscureText: true,
                          ),
                          const SizedBox(height: 16),
                          // ── Confirm Password ─────────────────────────────
                          const Text(
                            'CONFIRM PASSWORD',
                            style: TextStyle(
                              fontSize: 13,
                              color: AuthColors.label,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
                          AuthTextField(
                            controller: _confirmPasswordController,
                            hintText: 'Repeat password',
                            icon: Icons.lock_outline_rounded,
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          // ── Sign Up button ───────────────────────────────
                          _isLoading
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    child: CircularProgressIndicator(
                                      color: AuthColors.accent,
                                    ),
                                  ),
                                )
                              : AuthGradientButton(
                                  label: 'Sign Up',
                                  icon: Icons.arrow_forward,
                                  onPressed: _handleRegister,
                                ),
                          const SizedBox(height: 16),
                          AuthInlineLink(
                            leadingText: 'Already have an account? ',
                            actionText: 'Log In',
                            onTap: () => Navigator.of(context).pop(),
                          ),
                          const SizedBox(height: 24),
                          const AuthDividerWithText(text: 'OR CONTINUE WITH'),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: AuthSocialButton(
                                  icon: Icons.language_rounded,
                                  label: 'Google',
                                  iconColor: const Color(0xFF4285F4),
                                  onPressed: () {},
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: AuthSocialButton(
                                  icon: Icons.apple_rounded,
                                  label: 'Apple',
                                  iconColor: Colors.black,
                                  onPressed: () {},
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
