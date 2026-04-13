import 'package:flutter/material.dart';

import '../../../library/presentation/pages/library_page.dart';
import '../../data/home_mock_data.dart';
import '../theme/home_colors.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_featured_banner.dart';
import '../widgets/home_novel_row.dart';
import '../widgets/home_rank_card.dart';
import '../widgets/home_section_header.dart';
import '../widgets/home_top_bar.dart';
import '../widgets/home_update_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const HomeTopBar(title: kHomeAppName),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 100),
                children: [
                  const HomeFeaturedBanner(
                    title: kHomeFeaturedTitle,
                    subtitle: kHomeFeaturedSubtitle,
                  ),
                  const SizedBox(height: 28),
                  const HomeSectionHeader(
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
                      children: [
                        HomeUpdateCard(item: kHomeUpdates[0]),
                        HomeUpdateCard(item: kHomeUpdates[1]),
                        HomeUpdateCard(item: kHomeUpdates[2]),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const HomeSectionHeader(
                    title: 'Popular Manga',
                    subtitle: '',
                    actionLabel: '',
                  ),
                  const SizedBox(height: 14),
                  ...kHomePopularManga.map((item) {
                    final index = kHomePopularManga.indexOf(item);
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: index == kHomePopularManga.length - 1 ? 0 : 12,
                      ),
                      child: HomeRankCard(item: item),
                    );
                  }),
                  const SizedBox(height: 24),
                  const HomeSectionHeader(
                    title: 'Top Webnovels',
                    subtitle: '',
                    actionLabel: '',
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: HomeColors.surface,
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
                      children: [
                        HomeNovelRow(item: kHomeTopWebnovels[0]),
                        HomeNovelRow(item: kHomeTopWebnovels[1]),
                        HomeNovelRow(item: kHomeTopWebnovels[2]),
                        HomeNovelRow(item: kHomeTopWebnovels[3], isLast: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        onLibraryTap: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LibraryPage()),
          );
        },
      ),
    );
  }
}
