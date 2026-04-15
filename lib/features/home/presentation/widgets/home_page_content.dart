import 'package:flutter/material.dart';

import 'home_featured_banner.dart';
import 'home_popular_manga_section.dart';
import 'home_top_webnovels_section.dart';
import 'home_updates_section.dart';

class HomePageContent extends StatelessWidget {
  final String featuredTitle;
  final String featuredSubtitle;

  const HomePageContent({
    super.key,
    required this.featuredTitle,
    required this.featuredSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
      children: [
        HomeFeaturedBanner(title: featuredTitle, subtitle: featuredSubtitle),
        const SizedBox(height: 28),
        const HomeUpdatesSection(),
        const SizedBox(height: 24),
        const HomePopularMangaSection(),
        const SizedBox(height: 24),
        const HomeTopWebnovelsSection(),
      ],
    );
  }
}
