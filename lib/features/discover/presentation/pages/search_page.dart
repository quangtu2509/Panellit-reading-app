import 'package:flutter/material.dart';

class SearchPage extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;

  const SearchPage({
    super.key,
    required this.onHomeTap,
    required this.onLibraryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 18, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back_rounded),
                    color: const Color(0xFF0F6F9B),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F6F9B),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 96),
                children: [
                  Container(
                    height: 64,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9ECEE),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.search_rounded,
                          color: Color(0xFF7D848C),
                          size: 30,
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Search titles, authors...',
                              hintStyle: TextStyle(
                                color: Color(0xFFA0A6AD),
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                              border: InputBorder.none,
                              isCollapsed: true,
                            ),
                            style: TextStyle(
                              color: Color(0xFF30353A),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _SectionHeader(
                    title: 'Recent Searches',
                    actionLabel: 'Clear All',
                    onActionTap: () {},
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _RecentSearchChip(
                          label: 'Solo Leveling',
                          isRemovable: true,
                        ),
                        const SizedBox(width: 14),
                        _RecentSearchChip(label: 'The Beginning After the End'),
                        const SizedBox(width: 14),
                        _RecentSearchChip(label: 'Omniscient Reader'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 34),
                  const Text(
                    'Trending Now',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF31363A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._kTrendingItems.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _TrendingCard(item: item),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Popular Genres',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF31363A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Expanded(
                        child: _GenreCard(
                          title: 'Action',
                          subtitle: '1.2k+ Titles',
                          backgroundColor: Color(0xFF087A9A),
                        ),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: _GenreCard(
                          title: 'Fantasy',
                          subtitle: '850 Titles',
                          backgroundColor: Color(0xFFBBC8FA),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const _GenreBannerCard(
                    title: 'Romance',
                    subtitle: 'Trending this week',
                    avatarCountLabel: '+40',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _SearchBottomNav(
        onHomeTap: onHomeTap,
        onLibraryTap: onLibraryTap,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionLabel;
  final VoidCallback onActionTap;

  const _SectionHeader({
    required this.title,
    required this.actionLabel,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Color(0xFF31363A),
            ),
          ),
        ),
        TextButton(
          onPressed: onActionTap,
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0F6F9B),
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionLabel,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _RecentSearchChip extends StatelessWidget {
  final String label;
  final bool isRemovable;

  const _RecentSearchChip({required this.label, this.isRemovable = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFBEE2FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF305C7B),
            ),
          ),
          if (isRemovable) ...[
            const SizedBox(width: 10),
            const Icon(Icons.close_rounded, size: 18, color: Color(0xFF305C7B)),
          ],
        ],
      ),
    );
  }
}

class _TrendingItem {
  final String rank;
  final String title;
  final String author;
  final String genre;
  final double rating;
  final Color coverColor;

  const _TrendingItem({
    required this.rank,
    required this.title,
    required this.author,
    required this.genre,
    required this.rating,
    required this.coverColor,
  });
}

const List<_TrendingItem> _kTrendingItems = [
  _TrendingItem(
    rank: '#1',
    title: 'Omniscient...',
    author: 'Umi & Sleepy-C',
    genre: 'ACTION',
    rating: 4.9,
    coverColor: Color(0xFF0E243A),
  ),
  _TrendingItem(
    rank: '#2',
    title: 'The World Afte...',
    author: 'Sing Shong',
    genre: 'FANTASY',
    rating: 4.7,
    coverColor: Color(0xFF5C6C95),
  ),
  _TrendingItem(
    rank: '#3',
    title: 'Eleceed',
    author: 'Jeho Son & ZHENA',
    genre: 'ACTION/COMEDY',
    rating: 4.8,
    coverColor: Color(0xFF0E1024),
  ),
];

class _TrendingCard extends StatelessWidget {
  final _TrendingItem item;

  const _TrendingCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 118,
            height: 130,
            decoration: BoxDecoration(
              color: item.coverColor,
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'RANK ${item.rank}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F6F9B),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Expanded(
                      child: Divider(height: 1, color: Color(0xFFE4E7EA)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  item.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF31363A),
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  item.author,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Color(0xFF647596),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDAECF9),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.genre,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2C6A8E),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.star_rounded,
                      color: Color(0xFFF1B400),
                      size: 26,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      item.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF42484D),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0F2F3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.chevron_right_rounded,
                        color: Color(0xFF0F6F9B),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GenreCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final Color backgroundColor;

  const _GenreCard({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isLight = backgroundColor.red > 180;
    final titleColor = isLight ? const Color(0xFF2E405E) : Colors.white;
    final subtitleColor = isLight ? const Color(0xFF5A6C8D) : Colors.white70;

    return Container(
      height: 150,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(subtitle, style: TextStyle(fontSize: 15, color: subtitleColor)),
        ],
      ),
    );
  }
}

class _GenreBannerCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String avatarCountLabel;

  const _GenreBannerCard({
    required this.title,
    required this.subtitle,
    required this.avatarCountLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFFC5E1FB),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF295374),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Trending this week',
                  style: TextStyle(fontSize: 15, color: Color(0xFF5F84A2)),
                ),
              ],
            ),
          ),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const _AvatarCircle(color: Color(0xFF8A5F4A)),
              const Positioned(
                left: -22,
                child: _AvatarCircle(color: Color(0xFF17253A)),
              ),
              Positioned(
                left: 40,
                top: 10,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      avatarCountLabel,
                      style: const TextStyle(
                        color: Color(0xFF0F6F9B),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
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

class _AvatarCircle extends StatelessWidget {
  final Color color;

  const _AvatarCircle({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
    );
  }
}

class _SearchBottomNav extends StatelessWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;

  const _SearchBottomNav({required this.onHomeTap, required this.onLibraryTap});

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
          _SearchNavItem(
            icon: Icons.home_outlined,
            label: 'Home',
            onTap: onHomeTap,
          ),
          _SearchNavItem(
            icon: Icons.book_outlined,
            label: 'Library',
            onTap: onLibraryTap,
          ),
          const _SearchNavItem(
            icon: Icons.search_rounded,
            label: 'Search',
            active: true,
          ),
          const _SearchNavItem(
            icon: Icons.person_outline_rounded,
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class _SearchNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback? onTap;

  const _SearchNavItem({
    required this.icon,
    required this.label,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0F6F9B) : const Color(0xFFA2A9B2);

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
