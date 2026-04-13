import 'package:flutter/material.dart';

import '../../../library/presentation/pages/library_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Panellit',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0F5A84),
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: const Color(0xFFE9EDF1)),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF4B647E),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                children: [
                  _FeaturedBanner(),
                  const SizedBox(height: 28),
                  _SectionHeader(
                    title: 'New Updates',
                    subtitle: 'Fresh chapters from your favorite artists',
                    actionLabel: 'See All',
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 250,
                    child: GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.73,
                      children: const [
                        _UpdateCard(
                          title: 'Star-Crossed...',
                          genre: 'Romance',
                          timeAgo: '2h ago',
                          episode: 'EP. 142',
                          color: Color(0xFFD7E9F1),
                        ),
                        _UpdateCard(
                          title: 'Void Walker',
                          genre: 'Dark Fantasy',
                          timeAgo: '5h ago',
                          episode: 'EP. 89',
                          color: Color(0xFF111827),
                        ),
                        _UpdateCard(
                          title: 'Final Quarter',
                          genre: 'Sports',
                          timeAgo: '8h ago',
                          episode: 'EP. 24',
                          color: Color(0xFFE7E7E7),
                        ),
                        SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const _TitleRow(title: 'Popular Manga'),
                  const SizedBox(height: 14),
                  const _RankCard(
                    rank: '#1',
                    title: 'Eternal Horizon',
                    description:
                        'A journey beyond the edge of the known universe.',
                  ),
                  const SizedBox(height: 12),
                  const _RankCard(
                    rank: '#2',
                    title: 'Shadow Architect',
                    description: 'Building worlds in darkness of the mind.',
                  ),
                  const SizedBox(height: 12),
                  const _RankCard(
                    rank: '#3',
                    title: 'Cursed Legacy',
                    description:
                        'The sins of the father shall be the power of the son.',
                  ),
                  const SizedBox(height: 12),
                  const _RankCard(
                    rank: '#4',
                    title: 'Wind Whisperer',
                    description:
                        'Listen to the breeze, it tells the tales of old.',
                  ),
                  const SizedBox(height: 24),
                  const _TitleRow(title: 'Top Webnovels'),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 24,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: const [
                        _NovelRow(
                          number: '01',
                          title: 'Solo Ascension: The Infinite Library',
                          tag: 'PROGRESSION',
                          reads: '1.2M Reads',
                        ),
                        _NovelRow(
                          number: '02',
                          title: 'My System is a Gacha Machine',
                          tag: 'COMEDY',
                          reads: '980k Reads',
                        ),
                        _NovelRow(
                          number: '03',
                          title: 'Reincarnated as a Spirit Forge',
                          tag: 'CRAFTING',
                          reads: '850k Reads',
                        ),
                        _NovelRow(
                          number: '04',
                          title: 'The Alchemist of Silent Hill',
                          tag: 'MYSTERY',
                          reads: '720k Reads',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
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
            const _BottomNavItem(
              icon: Icons.explore_rounded,
              label: 'EXPLORE',
              active: true,
            ),
            _BottomNavItem(
              icon: Icons.library_books_outlined,
              label: 'LIBRARY',
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LibraryPage()),
                );
              },
            ),
            const _BottomNavItem(
              icon: Icons.menu_book_outlined,
              label: 'READING',
            ),
            const _BottomNavItem(
              icon: Icons.person_outline_rounded,
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}

class _FeaturedBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: const LinearGradient(
          colors: [Color(0xFF0B1630), Color(0xFF153C6B), Color(0xFF08111D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x26000000),
            blurRadius: 24,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    Colors.white.withOpacity(0.95),
                    const Color(0xFFB8D9FF),
                  ],
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _Chip(label: 'FEATURED'),
                  const SizedBox(width: 8),
                  _Chip(
                    label: 'ACTION',
                    backgroundColor: Colors.white.withOpacity(0.14),
                  ),
                ],
              ),
              const Spacer(),
              const Text(
                'The Azure\nSentinel:\nRebirth',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  height: 1.05,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'In a world where the stars have\nforgotten their names, one...',
                style: TextStyle(
                  color: Color(0xFFD4E5F7),
                  fontSize: 16,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: 150,
                height: 52,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF1A9CD4), Color(0xFF4EC0EC)],
                    ),
                  ),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Read Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
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

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String actionLabel;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.actionLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF31363A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 13, color: Color(0xFF7D848C)),
              ),
            ],
          ),
        ),
        Text(
          '$actionLabel ›',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0F7AA5),
          ),
        ),
      ],
    );
  }
}

class _UpdateCard extends StatelessWidget {
  final String title;
  final String genre;
  final String timeAgo;
  final String episode;
  final Color color;

  const _UpdateCard({
    required this.title,
    required this.genre,
    required this.timeAgo,
    required this.episode,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  Positioned(top: 0, right: 0, child: _MiniTag(label: episode)),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF33363A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '$genre · $timeAgo',
              style: const TextStyle(fontSize: 12, color: Color(0xFF65728A)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TitleRow extends StatelessWidget {
  final String title;

  const _TitleRow({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w800,
        color: Color(0xFF31363A),
      ),
    );
  }
}

class _RankCard extends StatelessWidget {
  final String rank;
  final String title;
  final String description;

  const _RankCard({
    required this.rank,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 72,
            height: 96,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const LinearGradient(
                colors: [Color(0xFFD8EAF4), Color(0xFFBED2DF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.image_outlined,
              color: Colors.white70,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'RANK $rank',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0F7AA5),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF31363A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF7D848C),
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 16,
                      color: Color(0xFF0F7AA5),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '4.9',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF31363A),
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

class _NovelRow extends StatelessWidget {
  final String number;
  final String title;
  final String tag;
  final String reads;
  final bool isLast;

  const _NovelRow({
    required this.number,
    required this.title,
    required this.tag,
    required this.reads,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 38,
              child: Text(
                number,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF31363A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill(text: tag),
                      const SizedBox(width: 8),
                      Text(
                        reads,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A929A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE4F0FA),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: Color(0xFF0F7AA5),
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final Color? backgroundColor;

  const _Chip({required this.label, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFF0C6D9C),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;

  const _MiniTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F7AA5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _BottomNavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = active ? const Color(0xFF0F7AA5) : const Color(0xFFA2A9B2);
    return Column(
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
    );
  }
}
