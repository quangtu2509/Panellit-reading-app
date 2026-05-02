import 'package:flutter/material.dart';

import '../theme/home_colors.dart';

/// Top bar for the home screen.
///
/// Left side: hamburger (☰) icon → genre dropdown, followed by "Panellit" brand name.
/// Right side: notification bell with optional red-dot badge.
class HomeTopBar extends StatelessWidget {
  final String title;
  final bool hasUnreadNotifications;
  final VoidCallback onNotificationTap;
  final ValueChanged<String> onCategoryTap;

  const HomeTopBar({
    super.key,
    required this.title,
    required this.hasUnreadNotifications,
    required this.onNotificationTap,
    required this.onCategoryTap,
  });

  // All available categories — Novel and Manga always appear first.
  static const List<String> _categories = [
    'Novel',
    'Manga',
    'Action',
    'Adventure',
    'Drama',
    'Fantasy',
    'Sci-Fi',
    'Sports',
    'Romance',
    'Dark Fantasy',
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 20, 12),
      child: Row(
        children: [
          // ── Genre dropdown trigger ─────────────────────────────────────
          _GenreMenuButton(
            categories: _categories,
            onSelected: onCategoryTap,
          ),
          const SizedBox(width: 6),
          // ── Brand name ─────────────────────────────────────────────────
          Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: HomeColors.brand,
            ),
          ),
          const Spacer(),
          // ── Notification bell ──────────────────────────────────────────
          Stack(
            clipBehavior: Clip.none,
            children: [
              Material(
                color: HomeColors.surface,
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  onTap: onNotificationTap,
                  borderRadius: BorderRadius.circular(14),
                  child: Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE9EDF1)),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: HomeColors.mutedIcon,
                    ),
                  ),
                ),
              ),
              if (hasUnreadNotifications)
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFB13B39),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Genre dropdown button ─────────────────────────────────────────────────────

class _GenreMenuButton extends StatelessWidget {
  final List<String> categories;
  final ValueChanged<String> onSelected;

  const _GenreMenuButton({
    required this.categories,
    required this.onSelected,
  });

  IconData _iconForCategory(String cat) {
    switch (cat) {
      case 'Novel':
        return Icons.menu_book_rounded;
      case 'Manga':
        return Icons.auto_stories_rounded;
      case 'Action':
        return Icons.flash_on_rounded;
      case 'Adventure':
        return Icons.explore_rounded;
      case 'Drama':
        return Icons.theater_comedy_rounded;
      case 'Fantasy':
        return Icons.auto_fix_high_rounded;
      case 'Sci-Fi':
        return Icons.rocket_launch_rounded;
      case 'Sports':
        return Icons.sports_soccer_rounded;
      case 'Romance':
        return Icons.favorite_rounded;
      case 'Dark Fantasy':
        return Icons.nights_stay_rounded;
      default:
        return Icons.label_rounded;
    }
  }

  Color _colorForCategory(String cat) {
    switch (cat) {
      case 'Novel':
        return const Color(0xFF6D28D9);
      case 'Manga':
        return const Color(0xFF0F6F9B);
      default:
        return HomeColors.mutedIcon;
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          // Section header inside the menu
          const PopupMenuItem<String>(
            enabled: false,
            height: 36,
            child: Text(
              'BROWSE BY CATEGORY',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFFB0BEC5),
              ),
            ),
          ),
          const PopupMenuDivider(height: 1),
          ...categories.map(
            (cat) => PopupMenuItem<String>(
              value: cat,
              child: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _colorForCategory(cat).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      _iconForCategory(cat),
                      size: 18,
                      color: _colorForCategory(cat),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    cat,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: cat == 'Novel' || cat == 'Manga'
                          ? FontWeight.w800
                          : FontWeight.w600,
                      color: _colorForCategory(cat),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ];
      },
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: HomeColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE9EDF1)),
        ),
        child: const Icon(
          Icons.menu_rounded,
          color: HomeColors.mutedIcon,
        ),
      ),
    );
  }
}
