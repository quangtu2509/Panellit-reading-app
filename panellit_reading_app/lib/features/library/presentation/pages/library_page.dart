import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/network/models/history_api_model.dart';
import '../../../../core/network/services/history_api_service.dart';
import '../../../../core/services/auth_service.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../discover/presentation/pages/search_page.dart';
import '../../../discover/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/models/library_completed_item.dart';
import '../../data/models/library_item.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../theme/library_colors.dart';
import '../widgets/library_bottom_nav.dart';
import '../widgets/library_card.dart';
import '../widgets/library_completed_card.dart';
import '../widgets/library_recommend_banner.dart';
import '../widgets/library_tab_section.dart';
import '../widgets/library_top_bar.dart';

class LibraryPage extends StatefulWidget {
  final bool isGuest;

  const LibraryPage({super.key, this.isGuest = false});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibrarySortOption _followingSort  = LibrarySortOption.newestToOldest;
  LibrarySortOption _completedSort  = LibrarySortOption.newestToOldest;

  // ── Reading history (from backend) ──────────────────────────────────────
  List<ApiHistoryItem> _historyItems = [];
  bool _isLoadingHistory             = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    final isLoggedIn = await AuthService.instance.isLoggedIn();
    if (!isLoggedIn || !mounted) return;

    setState(() => _isLoadingHistory = true);

    final items = await HistoryApiService().getMyHistory();

    if (!mounted) return;
    setState(() {
      _historyItems     = items;
      _isLoadingHistory = false;
    });
  }

  void _openHome() {
    Navigator.of(
      context,
    ).pushReplacement(buildSmoothPageRoute(HomePage(isGuest: widget.isGuest)));
  }

  void _openLibrary() {
    Navigator.of(context).pushReplacement(
      buildSmoothPageRoute(LibraryPage(isGuest: widget.isGuest)),
    );
  }

  void _openSearch({bool replace = false}) {
    final route = buildSmoothPageRoute(
      SearchPage(
        isGuest: widget.isGuest,
        onHomeTap: _openHome,
        onLibraryTap: _openLibrary,
        onProfileTap: _openProfile,
      ),
    );

    if (replace) {
      Navigator.of(context).pushReplacement(route);
    } else {
      Navigator.of(context).push(route);
    }
  }

  void _openNotifications() {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        NotificationsPage(
          isGuest: widget.isGuest,
          onHomeTap: _openHome,
          onLibraryTap: _openLibrary,
          onSearchTap: () => _openSearch(replace: true),
          onProfileTap: _openProfile,
        ),
      ),
    );
  }

  void _openProfile() {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        ProfilePage(
          isGuest: widget.isGuest,
          onHomeTap: _openHome,
          onLibraryTap: _openLibrary,
          onSearchTap: _openSearch,
        ),
      ),
    );
  }

  void _openDetail(TitleDetailModel detail) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: detail,
          isGuest: widget.isGuest,
          onHomeTap: _openHome,
          onLibraryTap: _openLibrary,
          onSearchTap: () => _openSearch(replace: true),
          onProfileTap: _openProfile,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: LibraryColors.pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              LibraryTopBar(onNotificationTap: _openNotifications),
              Container(
                decoration: const BoxDecoration(
                  color: LibraryColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x10000000),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: const TabBar(
                  labelColor: LibraryColors.primary,
                  unselectedLabelColor: Color(0xFF788391),
                  indicatorColor: LibraryColors.primary,
                  indicatorWeight: 3,
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                  unselectedLabelStyle: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: [
                    Tab(text: 'Following'),
                    Tab(text: 'Reading'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildFollowingTab(),
                    _buildReadingTab(),
                    _buildCompletedTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: LibraryBottomNav(
          onHomeTap: _openHome,
          onSearchTap: _openSearch,
          onProfileTap: _openProfile,
        ),
      ),
    );
  }

  Widget _buildFollowingTab() {
    final sortedItems = _sortedFollowingItems(const []);

    return LibraryTabSection(
      topPadding: 18,
      title: '0 Titles',
      selectedSort: _followingSort,
      onSortSelected: (value) {
        setState(() {
          _followingSort = value;
        });
      },
      children: [
        ...sortedItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: LibraryCard(
              item: item,
              onTap: () => _openDetail(item.detail),
            ),
          );
        }),
        const LibraryRecommendBanner(),
      ],
    );
  }

  Widget _buildReadingTab() {
    // Guest mode: show login prompt
    if (widget.isGuest) {
      return _buildLoginPrompt();
    }

    // Loading state
    if (_isLoadingHistory) {
      return const Center(
        child: CircularProgressIndicator(color: LibraryColors.primary),
      );
    }

    // Empty / error state
    if (_historyItems.isEmpty) {
      return RefreshIndicator(
        onRefresh: _fetchHistory,
        color: LibraryColors.primary,
        child: ListView(
          padding: const EdgeInsets.all(32),
          children: const [
            SizedBox(height: 80),
            Icon(Icons.auto_stories_outlined,
                size: 64, color: Color(0xFFBFC6CE)),
            SizedBox(height: 16),
            Text(
              'No reading history yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A4552),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Start reading a manga and your progress will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF8A96A3)),
            ),
          ],
        ),
      );
    }

    // Real history list
    return RefreshIndicator(
      onRefresh: _fetchHistory,
      color: LibraryColors.primary,
      child: ListView.separated(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
        itemCount: _historyItems.length,
        separatorBuilder: (context, index) => const SizedBox(height: 14),
        itemBuilder: (context, index) {
          final item = _historyItems[index];
          return _HistoryCard(
            item: item,
            onTap: () => _openDetail(
              TitleDetailModel(
                id:       item.mangaSlug,
                title:    item.manga.title.isNotEmpty ? item.manga.title : item.mangaSlug,
                author:   '',
                status:   '',
                rating:   0,
                chapters: 0,
                readsLabel: '',
                synopsis:   '',
                genres:     const [],
                chapterUpdates: const [],
                reviewSummary: const ReviewSummaryModel(
                  average: 0,
                  ratingsCountLabel: '',
                  bars: {},
                ),
                reviews:       const [],
                relatedStories: const [],
                coverColor: const Color(0xFF1C2333),
                coverUrl:   item.manga.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoginPrompt() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_outline_rounded,
                size: 56, color: Color(0xFFBFC6CE)),
            const SizedBox(height: 16),
            const Text(
              'Log in to see your reading history',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF3A4552),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Create a free account to sync your reading progress across devices.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF8A96A3)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _openProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: LibraryColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Log In',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompletedTab() {
    final sortedItems = _sortedCompletedItems(const []);

    return LibraryTabSection(
      topPadding: 16,
      selectedSort: _completedSort,
      onSortSelected: (value) {
        setState(() {
          _completedSort = value;
        });
      },
      children: [
        ...sortedItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: LibraryCompletedCard(
              item: item,
              onTap: () => _openDetail(item.detail),
            ),
          );
        }),
      ],
    );
  }

  List<LibraryItem> _sortedFollowingItems(List<LibraryItem> items) {
    final result = List<LibraryItem>.from(items);

    switch (_followingSort) {
      case LibrarySortOption.az:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case LibrarySortOption.za:
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case LibrarySortOption.newestToOldest:
        result.sort((a, b) => a.updatedHoursAgo.compareTo(b.updatedHoursAgo));
        break;
      case LibrarySortOption.oldestToNewest:
        result.sort((a, b) => b.updatedHoursAgo.compareTo(a.updatedHoursAgo));
        break;
    }

    return result;
  }


  List<LibraryCompletedItem> _sortedCompletedItems(
    List<LibraryCompletedItem> items,
  ) {
    final result = List<LibraryCompletedItem>.from(items);

    switch (_completedSort) {
      case LibrarySortOption.az:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case LibrarySortOption.za:
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case LibrarySortOption.newestToOldest:
        result.sort(
          (a, b) => a.completedHoursAgo.compareTo(b.completedHoursAgo),
        );
        break;
      case LibrarySortOption.oldestToNewest:
        result.sort(
          (a, b) => b.completedHoursAgo.compareTo(a.completedHoursAgo),
        );
        break;
    }

    return result;
  }
}

// \u2500\u2500 Private widget: one card in the reading-history list \u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500\u2500

class _HistoryCard extends StatelessWidget {
  final ApiHistoryItem item;
  final VoidCallback onTap;

  const _HistoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Cover image
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(14)),
              child: item.manga.cover.isNotEmpty
                  ? Image.network(
                      item.manga.cover,
                      width: 72,
                      height: 96,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stack) => _coverFallback(),
                      loadingBuilder: (_, child, progress) =>
                          progress == null ? child : _coverPlaceholder(),
                    )
                  : _coverFallback(),
            ),
            const SizedBox(width: 12),
            // Info column
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.manga.title.isNotEmpty
                          ? item.manga.title
                          : item.mangaSlug,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C2333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.bookmark_rounded,
                            size: 14, color: Color(0xFF0F6F9B)),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            'Chapter ${item.chapterId}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFF0F6F9B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(Icons.chevron_right_rounded,
                  color: Color(0xFFB0BEC5)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _coverFallback() => Container(
        width: 72,
        height: 96,
        color: const Color(0xFF1C2333),
        child: const Icon(Icons.image_not_supported_outlined,
            color: Colors.white38, size: 28),
      );

  Widget _coverPlaceholder() => Container(
        width: 72,
        height: 96,
        color: const Color(0xFFE9EDF1),
        child: const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
                strokeWidth: 2, color: Color(0xFF0F6F9B)),
          ),
        ),
      );
}
