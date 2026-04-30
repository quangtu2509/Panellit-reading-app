import 'package:flutter/material.dart';

import 'home_featured_banner.dart';
import 'home_popular_manga_section.dart';
import 'home_top_webnovels_section.dart';
import 'home_updates_section.dart';

class HomePageContent extends StatelessWidget {
  final String featuredTitle;
  final String featuredSubtitle;
  final VoidCallback onOpenDetail;

  const HomePageContent({
    super.key,
    required this.featuredTitle,
    required this.featuredSubtitle,
    required this.onOpenDetail,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      children: [
        HomeFeaturedBanner(
          title: featuredTitle,
          subtitle: featuredSubtitle,
          onTap: onOpenDetail,
        ),
        const SizedBox(height: 28),
        HomeUpdatesSection(onItemTap: (_) => onOpenDetail()),
        const SizedBox(height: 24),
        HomePopularMangaSection(onItemTap: (_) => onOpenDetail()),
        const SizedBox(height: 24),
        HomeTopWebnovelsSection(onItemTap: (_) => onOpenDetail()),
      ],
    );
  }
}
