import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthPageHeader extends StatelessWidget {
  final Widget icon;
  final String title;
  final String subtitle;

  const AuthPageHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon,
        const SizedBox(height: 12),
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: AuthColors.title,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 15,
            height: 1.35,
            color: AuthColors.subtitle,
          ),
        ),
      ],
    );
  }
}
