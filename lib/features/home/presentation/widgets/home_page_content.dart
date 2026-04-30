import 'package:flutter/material.dart';

import '../../../discover/data/models/title_detail_model.dart';
import 'home_featured_banner.dart';
import 'home_popular_manga_section.dart';
import 'home_top_webnovels_section.dart';
import 'home_updates_section.dart';

class HomePageContent extends StatelessWidget {
  final String featuredTitle;
  final String featuredSubtitle;
  final TitleDetailModel featuredDetail;
  final ValueChanged<TitleDetailModel> onOpenDetail;

  const HomePageContent({
    super.key,
    required this.featuredTitle,
    required this.featuredSubtitle,
    required this.featuredDetail,
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
          onTap: () => onOpenDetail(featuredDetail),
        ),
        const SizedBox(height: 28),
        HomeUpdatesSection(onItemTap: (item) => onOpenDetail(item.detail)),
        const SizedBox(height: 24),
        HomePopularMangaSection(onItemTap: (item) => onOpenDetail(item.detail)),
        const SizedBox(height: 24),
        HomeTopWebnovelsSection(onItemTap: (item) => onOpenDetail(item.detail)),
      ],
    );
  }
}
