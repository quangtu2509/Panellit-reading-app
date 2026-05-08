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

  /// OTruyen-aligned categories: display name → API slug.
  /// Order: format types first, then genres alphabetically.
  static const List<_Category> _categories = [
    _Category('Manga',        'manga'),
    _Category('Manhwa',       'manhwa'),
    _Category('Manhua',       'manhua'),
    _Category('Webtoon',      'webtoon'),
    _Category('Action',       'action'),
    _Category('Adventure',    'adventure'),
    _Category('Comedy',       'comedy'),
    _Category('Drama',        'drama'),
    _Category('Fantasy',      'fantasy'),
    _Category('Harem',        'harem'),
    _Category('Historical',   'historical'),
    _Category('Horror',       'horror'),
    _Category('Martial Arts', 'martial-arts'),
    _Category('Mystery',      'mystery'),
    _Category('Psychological','psychological'),
    _Category('Romance',      'romance'),
    _Category('School Life',  'school-life'),
    _Category('Sci-fi',       'sci-fi'),
    _Category('Seinen',       'seinen'),
    _Category('Shounen',      'shounen'),
    _Category('Slice of Life','slice-of-life'),
    _Category('Sports',       'sports'),
    _Category('Supernatural', 'supernatural'),
    _Category('Tragedy',      'tragedy'),
    _Category('Xuyên Không',  'xuyen-khong'),
    _Category('Chuyển Sinh',  'chuyen-sinh'),
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

// ── Data class ────────────────────────────────────────────────────────────────

class _Category {
  final String name;
  final String slug;
  const _Category(this.name, this.slug);
}

// ── Genre dropdown button ─────────────────────────────────────────────────────

class _GenreMenuButton extends StatelessWidget {
  final List<_Category> categories;
  final ValueChanged<String> onSelected;

  const _GenreMenuButton({
    required this.categories,
    required this.onSelected,
  });

  IconData _iconForSlug(String slug) {
    switch (slug) {
      case 'manga':          return Icons.auto_stories_rounded;
      case 'manhwa':         return Icons.collections_bookmark_rounded;
      case 'manhua':         return Icons.library_books_rounded;
      case 'webtoon':        return Icons.view_day_rounded;
      case 'action':         return Icons.flash_on_rounded;
      case 'adventure':      return Icons.explore_rounded;
      case 'comedy':         return Icons.sentiment_very_satisfied_rounded;
      case 'drama':          return Icons.theater_comedy_rounded;
      case 'fantasy':        return Icons.auto_fix_high_rounded;
      case 'harem':          return Icons.people_rounded;
      case 'historical':     return Icons.account_balance_rounded;
      case 'horror':         return Icons.warning_amber_rounded;
      case 'martial-arts':   return Icons.sports_martial_arts_rounded;
      case 'mystery':        return Icons.search_rounded;
      case 'psychological':  return Icons.psychology_rounded;
      case 'romance':        return Icons.favorite_rounded;
      case 'school-life':    return Icons.school_rounded;
      case 'sci-fi':         return Icons.rocket_launch_rounded;
      case 'seinen':         return Icons.person_rounded;
      case 'shounen':        return Icons.boy_rounded;
      case 'slice-of-life':  return Icons.wb_sunny_rounded;
      case 'sports':         return Icons.sports_soccer_rounded;
      case 'supernatural':   return Icons.nights_stay_rounded;
      case 'tragedy':        return Icons.heart_broken_rounded;
      case 'xuyen-khong':    return Icons.access_time_rounded;
      case 'chuyen-sinh':    return Icons.replay_rounded;
      default:               return Icons.label_rounded;
    }
  }

  Color _colorForSlug(String slug) {
    switch (slug) {
      // Format types — distinct colors
      case 'manga':    return const Color(0xFF0F6F9B);
      case 'manhwa':   return const Color(0xFF1A7A5A);
      case 'manhua':   return const Color(0xFFB36A00);
      case 'webtoon':  return const Color(0xFF6D28D9);
      // Genre categories — muted slate
      default:         return HomeColors.mutedIcon;
    }
  }

  bool _isFormatType(String slug) =>
      slug == 'manga' || slug == 'manhwa' || slug == 'manhua' || slug == 'webtoon';

  @override
  Widget build(BuildContext context) {
    // Split into format types and genre categories for grouped display
    final formatTypes = categories.where((c) => _isFormatType(c.slug)).toList();
    final genres = categories.where((c) => !_isFormatType(c.slug)).toList();

    PopupMenuItem<String> buildItem(_Category cat) {
      final color = _colorForSlug(cat.slug);
      final isBold = _isFormatType(cat.slug);
      return PopupMenuItem<String>(
        value: cat.slug,
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                _iconForSlug(cat.slug),
                size: 18,
                color: color,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              cat.name,
              style: TextStyle(
                fontSize: 15,
                fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<String>(
      offset: const Offset(0, 48),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      onSelected: onSelected,
      itemBuilder: (context) {
        return [
          // ── Section: Format ──────────────────────────────────────────
          const PopupMenuItem<String>(
            enabled: false,
            height: 36,
            child: Text(
              'ĐỊNH DẠNG',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFFB0BEC5),
              ),
            ),
          ),
          const PopupMenuDivider(height: 1),
          ...formatTypes.map(buildItem),
          // ── Section: Genres ──────────────────────────────────────────
          const PopupMenuItem<String>(
            enabled: false,
            height: 36,
            child: Text(
              'THỂ LOẠI',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.2,
                color: Color(0xFFB0BEC5),
              ),
            ),
          ),
          const PopupMenuDivider(height: 1),
          ...genres.map(buildItem),
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
