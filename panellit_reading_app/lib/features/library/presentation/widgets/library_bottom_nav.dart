import 'package:flutter/material.dart';

import '../theme/library_colors.dart';

class LibraryBottomNav extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const LibraryBottomNav({
    super.key,
    required this.onHomeTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(10, 0, 10, 10),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 22,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BottomNavItem(
            icon: Icons.home_outlined,
            label: 'HOME',
            onTap: onHomeTap,
          ),
          const _BottomNavItem(
            icon: Icons.library_books_rounded,
            label: 'LIBRARY',
            active: true,
          ),
          _BottomNavItem(
            icon: Icons.search_rounded,
            label: 'SEARCH',
            onTap: onSearchTap,
          ),
          _BottomNavItem(
            icon: Icons.person_outline_rounded,
            label: 'PROFILE',
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? LibraryColors.primary : const Color(0xFFA2A9B2);
    final content = AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      padding: EdgeInsets.symmetric(
        horizontal: active ? 18 : 8,
        vertical: active ? 10 : 6,
      ),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFD9ECF8) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return content;
    }

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: content,
    );
  }
}
