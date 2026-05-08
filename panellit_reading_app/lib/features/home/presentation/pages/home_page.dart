import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/network/models/home_feed_model.dart';
import '../../../../core/network/services/home_feed_service.dart';
import '../../../library/presentation/pages/library_page.dart';
import '../../../discover/presentation/pages/search_page.dart';
import '../../../discover/presentation/pages/notifications_page.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../../../discover/presentation/pages/category_results_page.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';
import '../widgets/home_bottom_nav.dart';
import '../widgets/home_page_content.dart';
import '../widgets/home_top_bar.dart';

class HomePage extends StatefulWidget {
  final bool isGuest;

  const HomePage({super.key, this.isGuest = false});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // ── State ────────────────────────────────────────────────────────────────
  List<HomeUpdateItem> _updateItems = []; // Empty start
  List<HomeRankItem> _popularItems = []; // Empty start
  TitleDetailModel _featuredDetail = TitleDetailModel(
    id: '',
    title: '',
    author: '',
    status: '',
    rating: 0,
    chapters: 0,
    readsLabel: '',
    synopsis: '',
    genres: const [],
    chapterUpdates: const [],
    reviewSummary: const ReviewSummaryModel(average: 0, ratingsCountLabel: '', bars: {}),
    reviews: const [],
    relatedStories: const [],
    coverColor: Colors.black,
  );
  String _featuredTitle = '';
  String _featuredSubtitle = '';

  final HomeFeedService _feedService = HomeFeedService();

  @override
  void initState() {
    super.initState();
    _fetchHomeFeed();
  }

  // ── API Fetch ─────────────────────────────────────────────────────────────

  Future<void> _fetchHomeFeed() async {
    try {
      final feedItems = await _feedService.getHomeFeed();
      if (!mounted || feedItems.isEmpty) return;

      // Map API items → HomeUpdateItem (for New Updates section)
      final updates = feedItems.take(4).map((item) {
        final detail = _buildDetailFromFeedItem(item);
        final latestChapter = item.chaptersLatest.isNotEmpty
            ? 'EP. ${item.chaptersLatest.first.chapterName}'
            : 'EP. 1';
        final genre = item.categories.isNotEmpty ? item.categories.first : 'Manga';
        return HomeUpdateItem(
          title: item.title,
          genre: genre,
          timeAgo: 'Recently',
          episode: latestChapter,
          coverTone: 'neutral',
          coverUrl: item.cover,
          detail: detail,
        );
      }).toList();

      // Map API items → HomeRankItem (for Popular section) — skip 4 already used
      final popular = feedItems.skip(4).take(5).toList().asMap().entries.map((entry) {
        final item = entry.value;
        final detail = _buildDetailFromFeedItem(item);
        return HomeRankItem(
          rank: '#${entry.key + 1}',
          title: item.title,
          description: item.categories.isNotEmpty
              ? item.categories.join(' · ')
              : 'Manga',
          detail: detail,
        );
      }).toList();

      // Use first item as featured
      final featured = feedItems.first;
      final featuredDetail = _buildDetailFromFeedItem(featured);

      setState(() {
        _updateItems = updates;
        _popularItems = popular;
        _featuredDetail = featuredDetail;
        _featuredTitle = featured.title;
        _featuredSubtitle = featured.categories.isNotEmpty
            ? '${featured.categories.take(2).join(' · ')} · ${featured.status}'
            : 'Read now';
      });
    } catch (_) {
      // Silently keep mock data on failure
    }
  }

  /// Build a minimal TitleDetailModel from an API feed item.
  /// The real data will be loaded lazily when user opens the detail page.
  TitleDetailModel _buildDetailFromFeedItem(ApiHomeFeedItem item) {

    // Build a skeleton detail model — the TitleDetailPage will load the real data via API
    return TitleDetailModel(
      id: item.slug,
      title: item.title,
      author: '',
      status: item.status,
      rating: 0,
      chapters: item.chaptersLatest.length,
      readsLabel: '',
      synopsis: '',
      genres: item.categories,
      chapterUpdates: item.chaptersLatest
          .asMap()
          .entries
          .map((e) => ChapterUpdateModel(
                chapterNumber: e.key + 1,
                title: e.value.chapterName,
                timeLabel: 'Recently',
                chapterApiData: e.value.chapterApiData,
              ))
          .toList(),
      reviewSummary: const ReviewSummaryModel(
        average: 0,
        ratingsCountLabel: '',
        bars: {},
      ),
      reviews: const [],
      relatedStories: const [],
      coverColor: const Color(0xFF0D2742),
      coverUrl: item.cover,
    );
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  void _openHome(BuildContext context) {
    Navigator.of(context).pushReplacement(
      buildSmoothPageRoute(HomePage(isGuest: widget.isGuest)),
    );
  }

  void _openLibrary(BuildContext context) {
    Navigator.of(context).pushReplacement(
      buildSmoothPageRoute(LibraryPage(isGuest: widget.isGuest)),
    );
  }

  void _openSearch(BuildContext context, {bool replace = false}) {
    final route = buildSmoothPageRoute(
      SearchPage(
        isGuest: widget.isGuest,
        onHomeTap: () => _openHome(context),
        onLibraryTap: () => _openLibrary(context),
        onProfileTap: () => _openProfile(context),
      ),
    );
    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  void _openNotifications(BuildContext context) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        NotificationsPage(
          isGuest: widget.isGuest,
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context, replace: true),
          onProfileTap: () => _openProfile(context),
        ),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        ProfilePage(
          isGuest: widget.isGuest,
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context),
        ),
      ),
    );
  }

  /// Map from OTruyen slug → human-readable display name (mirrors home_top_bar.dart).
  static const Map<String, String> _slugToName = {
    'manga':         'Manga',
    'manhwa':        'Manhwa',
    'manhua':        'Manhua',
    'webtoon':       'Webtoon',
    'action':        'Action',
    'adventure':     'Adventure',
    'comedy':        'Comedy',
    'drama':         'Drama',
    'fantasy':       'Fantasy',
    'harem':         'Harem',
    'historical':    'Historical',
    'horror':        'Horror',
    'martial-arts':  'Martial Arts',
    'mystery':       'Mystery',
    'psychological': 'Psychological',
    'romance':       'Romance',
    'school-life':   'School Life',
    'sci-fi':        'Sci-fi',
    'seinen':        'Seinen',
    'shounen':       'Shounen',
    'slice-of-life': 'Slice of Life',
    'sports':        'Sports',
    'supernatural':  'Supernatural',
    'tragedy':       'Tragedy',
    'xuyen-khong':   'Xuyên Không',
    'chuyen-sinh':   'Chuyển Sinh',
  };

  void _openCategory(BuildContext context, String slug) {
    final displayName = _slugToName[slug] ?? slug;
    Navigator.of(context).push(
      buildSmoothPageRoute(
        CategoryResultsPage(
          categoryName: displayName,
          categorySlug: slug,
          isGuest: widget.isGuest,
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context),
          onProfileTap: () => _openProfile(context),
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, TitleDetailModel detail) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: detail,
          isGuest: widget.isGuest,
          onHomeTap: () => _openHome(context),
          onLibraryTap: () => _openLibrary(context),
          onSearchTap: () => _openSearch(context, replace: true),
          onProfileTap: () => _openProfile(context),
        ),
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HomeColors.background,
      body: SafeArea(
        child: Column(
          children: [
            HomeTopBar(
              title: 'Panellit',
              hasUnreadNotifications: false,
              onNotificationTap: () => _openNotifications(context),
              onCategoryTap: (cat) => _openCategory(context, cat),
            ),
            Expanded(
              child: HomePageContent(
                featuredTitle: _featuredTitle,
                featuredSubtitle: _featuredSubtitle,
                featuredDetail: _featuredDetail,
                updateItems: _updateItems,
                popularItems: _popularItems,
                onOpenDetail: (detail) => _openDetail(context, detail),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: HomeBottomNav(
        onLibraryTap: () => _openLibrary(context),
        onSearchTap: () => _openSearch(context),
        onProfileTap: () => _openProfile(context),
      ),
    );
  }
}
