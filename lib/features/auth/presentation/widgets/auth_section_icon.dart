import 'package:flutter/material.dart';

import '../theme/auth_colors.dart';

class AuthSectionIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  const AuthSectionIcon({super.key, required this.icon, this.size = 38});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: const BoxDecoration(
        color: AuthColors.iconCircle,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AuthColors.iconCircleContent, size: size * 0.52),
    );
  }
}
