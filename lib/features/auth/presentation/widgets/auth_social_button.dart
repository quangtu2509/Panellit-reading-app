import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthSocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color iconColor;

  const AuthSocialButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onPressed,
    this.iconColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: iconColor),
        label: Text(
          label,
          style: const TextStyle(
            color: Color(0xFF3B3F42),
            fontWeight: FontWeight.w600,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: AuthColors.guestButtonFill,
          side: const BorderSide(color: AuthColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }
}
