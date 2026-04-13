import 'package:flutter/material.dart';

class AuthInlineLink extends StatelessWidget {
  final String leadingText;
  final String actionText;
  final VoidCallback onTap;
  final double fontSize;

  const AuthInlineLink({
    super.key,
    required this.leadingText,
    required this.actionText,
    required this.onTap,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: TextStyle(color: const Color(0xFF7E8389), fontSize: fontSize),
          children: [
            TextSpan(text: leadingText),
            TextSpan(
              text: actionText,
              style: const TextStyle(
                color: Color(0xFF1B7FA9),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
