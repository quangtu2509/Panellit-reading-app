import 'package:flutter/material.dart';

import '../../data/title_detail_mock_data.dart';
import '../../data/models/title_detail_model.dart';
import '../theme/title_detail_colors.dart';
import '../widgets/detail/detail_bottom_nav.dart';
import '../widgets/detail/detail_chapters_section.dart';
import '../widgets/detail/detail_header_hero.dart';
import '../widgets/detail/detail_related_section.dart';
import '../widgets/detail/detail_reviews_section.dart';
import '../widgets/detail/detail_stats_genres_actions.dart';
import '../widgets/detail/detail_synopsis_section.dart';

class TitleDetailPage extends StatelessWidget {
  final TitleDetailModel detail;
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;

  const TitleDetailPage({
    super.key,
    this.detail = kTitleDetail,
    this.isGuest = false,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TitleDetailColors.pageBackground,
      body: Column(
        children: [
          DetailHeaderHero(
            detail: detail,
            onBackTap: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 96),
              children: [
                DetailStatsGenresActions(detail: detail),
                const SizedBox(height: 24),
                DetailSynopsisSection(detail: detail),
                const SizedBox(height: 24),
                DetailChaptersSection(chapters: detail.chapterUpdates),
                const SizedBox(height: 24),
                DetailReviewsSection(
                  isGuest: isGuest,
                  summary: detail.reviewSummary,
                  reviews: detail.reviews,
                ),
                const SizedBox(height: 24),
                DetailRelatedSection(stories: detail.relatedStories),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DetailBottomNav(
        onHomeTap: onHomeTap,
        onLibraryTap: onLibraryTap,
        onSearchTap: onSearchTap,
      ),
    );
  }
}
