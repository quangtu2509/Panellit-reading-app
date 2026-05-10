import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/storage/token_storage.dart';
import '../theme/profile_colors.dart';

/// Screen that lets a logged-in user:
///   • Change their display name
///   • Change their password
class AccountSettingsPage extends StatefulWidget {
  final String currentEmail;
  final String currentName;

  const AccountSettingsPage({super.key, required this.currentEmail, required this.currentName});

  @override
  State<AccountSettingsPage> createState() => _AccountSettingsPageState();
}

class _AccountSettingsPageState extends State<AccountSettingsPage> {
  // ── Name form ──────────────────────────────────────────────────────────────
  final _nameKey        = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  bool  _nameLoading    = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.currentName);
  }

  // ── Password form ──────────────────────────────────────────────────────────
  final _pwKey          = GlobalKey<FormState>();
  final _currentPwCtrl  = TextEditingController();
  final _newPwCtrl      = TextEditingController();
  final _confirmPwCtrl  = TextEditingController();
  bool  _pwLoading      = false;
  bool  _showCurrent    = false;
  bool  _showNew        = false;
  bool  _showConfirm    = false;

  final Dio _dio = ApiClient().dio;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentPwCtrl.dispose();
    _newPwCtrl.dispose();
    _confirmPwCtrl.dispose();
    super.dispose();
  }

  // ── Handlers ───────────────────────────────────────────────────────────────

  Future<void> _saveName() async {
    if (!(_nameKey.currentState?.validate() ?? false)) return;
    setState(() => _nameLoading = true);
    try {
      await _dio.put('/api/auth/update-name', data: {
        'name': _nameCtrl.text.trim(),
      });
      // Persist locally
      await TokenStorage.instance.updateUserName(_nameCtrl.text.trim());

      _showSnack('Name updated successfully!', success: true);
      // Optional: delay slightly and pop so the previous screen can refresh
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) Navigator.of(context).pop(true);
      });
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : 'Failed to update name.';
      _showSnack(errorMsg);
    } finally {
      if (mounted) setState(() => _nameLoading = false);
    }
  }

  Future<void> _savePassword() async {
    if (!(_pwKey.currentState?.validate() ?? false)) return;
    setState(() => _pwLoading = true);
    try {
      await _dio.put('/api/auth/update-password', data: {
        'currentPassword': _currentPwCtrl.text,
        'newPassword':     _newPwCtrl.text,
      });
      _showSnack('Password updated successfully!', success: true);
      _currentPwCtrl.clear();
      _newPwCtrl.clear();
      _confirmPwCtrl.clear();
    } on DioException catch (e) {
      final data = e.response?.data;
      final errorMsg = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : 'Failed to update password.';
      _showSnack(errorMsg);
    } finally {
      if (mounted) setState(() => _pwLoading = false);
    }
  }

  void _showSnack(String msg, {bool success = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? const Color(0xFF2E7D32) : const Color(0xFFC45555),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: ProfileColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          color: ProfileColors.primary,
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Account Settings',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: ProfileColors.textPrimary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(18, 8, 18, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Current account info ──────────────────────────────────────
            _SectionLabel('ACCOUNT'),
            _InfoTile(icon: Icons.email_outlined, label: 'Email', value: widget.currentEmail),
            const SizedBox(height: 24),

            // ── Change name ───────────────────────────────────────────────
            _SectionLabel('CHANGE DISPLAY NAME'),
            const SizedBox(height: 12),
            _Card(
              child: Form(
                key: _nameKey,
                child: Column(
                  children: [
                    _Field(
                      controller: _nameCtrl,
                      label: 'New display name',
                      icon: Icons.person_outline_rounded,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) return 'Name cannot be empty';
                        if (v.trim().length < 2) return 'At least 2 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _ActionButton(
                      label: 'Save Name',
                      loading: _nameLoading,
                      onPressed: _saveName,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // ── Change password ───────────────────────────────────────────
            _SectionLabel('CHANGE PASSWORD'),
            const SizedBox(height: 12),
            _Card(
              child: Form(
                key: _pwKey,
                child: Column(
                  children: [
                    _Field(
                      controller: _currentPwCtrl,
                      label: 'Current password',
                      icon: Icons.lock_outline_rounded,
                      obscure: !_showCurrent,
                      suffix: IconButton(
                        icon: Icon(
                          _showCurrent ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: ProfileColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _showCurrent = !_showCurrent),
                      ),
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Enter current password';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _Field(
                      controller: _newPwCtrl,
                      label: 'New password',
                      icon: Icons.lock_rounded,
                      obscure: !_showNew,
                      suffix: IconButton(
                        icon: Icon(
                          _showNew ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: ProfileColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _showNew = !_showNew),
                      ),
                      validator: (v) {
                        if (v == null || v.length < 6) return 'At least 6 characters';
                        return null;
                      },
                    ),
                    const SizedBox(height: 14),
                    _Field(
                      controller: _confirmPwCtrl,
                      label: 'Confirm new password',
                      icon: Icons.lock_reset_rounded,
                      obscure: !_showConfirm,
                      suffix: IconButton(
                        icon: Icon(
                          _showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                          color: ProfileColors.textSecondary,
                          size: 20,
                        ),
                        onPressed: () => setState(() => _showConfirm = !_showConfirm),
                      ),
                      validator: (v) {
                        if (v != _newPwCtrl.text) return 'Passwords do not match';
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _ActionButton(
                      label: 'Update Password',
                      loading: _pwLoading,
                      onPressed: _savePassword,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Reusable sub-widgets ─────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          letterSpacing: 1.2,
          fontWeight: FontWeight.w700,
          color: ProfileColors.textSecondary,
        ),
      );
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: ProfileColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Color(0x08000000), blurRadius: 12)],
      ),
      child: Row(
        children: [
          Icon(icon, color: ProfileColors.primary, size: 20),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 11, color: ProfileColors.textSecondary, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontSize: 15, color: ProfileColors.textPrimary, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final Widget child;
  const _Card({required this.child});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: ProfileColors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Color(0x0B000000), blurRadius: 20, offset: Offset(0, 6))],
        ),
        child: child,
      );
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _Field({
    required this.controller,
    required this.label,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      validator: validator,
      style: const TextStyle(fontSize: 15, color: ProfileColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: ProfileColors.textSecondary, fontSize: 14),
        prefixIcon: Icon(icon, color: ProfileColors.primary, size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: const Color(0xFFF6F7F9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E4EA)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE0E4EA)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: ProfileColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFC45555)),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFC45555), width: 1.6),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final bool loading;
  final VoidCallback onPressed;

  const _ActionButton({required this.label, required this.loading, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: loading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfileColors.primary,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB0CAD9),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: loading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
              )
            : Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800)),
      ),
    );
  }
}
