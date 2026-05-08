import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../discover/data/models/search_models.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../../../discover/presentation/widgets/search/search_results_section.dart';

/// Screen that lists all titles belonging to a specific genre/category.
/// Reached from the home screen's genre dropdown.
class CategoryResultsPage extends StatelessWidget {
  final String category;
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const CategoryResultsPage({
    super.key,
    required this.category,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  List<SearchResultModel> get _results {
    return const [];
  }

  void _openDetail(BuildContext context, SearchResultModel item) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: TitleDetailModel(
            id: item.slug,
            title: item.title,
            author: item.author,
            status: '',
            rating: item.rating,
            chapters: 0,
            readsLabel: '',
            synopsis: '',
            genres: item.genres,
            chapterUpdates: const [],
            reviewSummary: const ReviewSummaryModel(
              average: 0,
              ratingsCountLabel: '',
              bars: {},
            ),
            reviews: const [],
            relatedStories: const [],
            coverColor: item.coverColor,
          ),
          isGuest: isGuest || item.openAsGuest,
          onHomeTap: onHomeTap,
          onLibraryTap: onLibraryTap,
          onSearchTap: onSearchTap,
          onProfileTap: onProfileTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _results;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryTopBar(category: category),
            Expanded(
              child: results.isEmpty
                  ? _EmptyState(category: category)
                  : _ResultsList(
                      category: category,
                      results: results,
                      onResultTap: (item) => _openDetail(context, item),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _CategoryTopBar extends StatelessWidget {
  final String category;

  const _CategoryTopBar({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(4, 6, 20, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
            color: const Color(0xFF2F3B46),
            onPressed: () => Navigator.of(context).maybePop(),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A96A3),
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1C2333),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Results list ──────────────────────────────────────────────────────────────

class _ResultsList extends StatelessWidget {
  final String category;
  final List<SearchResultModel> results;
  final ValueChanged<SearchResultModel> onResultTap;

  const _ResultsList({
    required this.category,
    required this.results,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
      children: [
        // Header: All "Fantasy" Results:
        RichText(
          text: TextSpan(
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1C2333),
            ),
            children: [
              const TextSpan(text: 'All '),
              TextSpan(
                text: '"$category"',
                style: const TextStyle(color: Color(0xFF0F6F9B)),
              ),
              const TextSpan(text: ' Results:'),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          '${results.length} title${results.length == 1 ? '' : 's'} found',
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF8A96A3),
          ),
        ),
        const SizedBox(height: 20),
        ...results.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: SearchResultsSection(
              results: [item],
              onClearSearch: () {},
              onResultTap: onResultTap,
            ),
          ),
        ),
      ],
    );
  }
}

// ── Empty state ───────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  final String category;

  const _EmptyState({required this.category});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.search_off_rounded,
              size: 64,
              color: Color(0xFFB0BEC5),
            ),
            const SizedBox(height: 16),
            Text(
              'No titles in "$category"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C2333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Check back later for new additions.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF8A96A3)),
            ),
          ],
        ),
      ),
    );
  }
}
