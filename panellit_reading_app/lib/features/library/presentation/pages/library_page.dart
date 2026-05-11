import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/network/models/history_api_model.dart';
import '../../../../core/network/services/history_api_service.dart';
import '../../../../core/network/services/bookmark_api_service.dart';
import '../../../../core/network/models/bookmark_api_model.dart';
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
  LibrarySortOption _bookmarksSort = LibrarySortOption.newestToOldest;
  LibrarySortOption _continueSort = LibrarySortOption.newestToOldest;
  LibrarySortOption _completedSort = LibrarySortOption.newestToOldest;
  String _bookmarksStatusFilter = 'All'; // 'All', 'Ongoing', 'Completed'

  // ── Reading history (from backend) ──────────────────────────────────────
  List<ApiHistoryItem> _historyItems = [];
  bool _isLoadingHistory             = false;

  // ── Bookmarks (from backend) ────────────────────────────────────────────
  List<ApiBookmarkItem> _bookmarkItems = [];
  bool _isLoadingBookmarks             = false;

  @override
  void initState() {
    super.initState();
    if (!widget.isGuest) {
      _fetchHistory();
      _fetchBookmarks();
    }
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

  Future<void> _fetchBookmarks() async {
    final isLoggedIn = await AuthService.instance.isLoggedIn();
    if (!isLoggedIn || !mounted) return;

    setState(() => _isLoadingBookmarks = true);

    final items = await BookmarkApiService().getMyBookmarks();

    if (!mounted) return;
    setState(() {
      _bookmarkItems     = items;
      _isLoadingBookmarks = false;
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
                    Tab(text: 'Bookmarks'),
                    Tab(text: 'Continue'),
                    Tab(text: 'Completed'),
                  ],
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    _buildBookmarksTab(),
                    _buildContinueTab(),
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

  Widget _buildBookmarksTab() {
    // Guest mode: show login prompt
    if (widget.isGuest) {
      return _buildLoginPrompt();
    }

    // Loading state
    if (_isLoadingBookmarks) {
      return const Center(
        child: CircularProgressIndicator(color: LibraryColors.primary),
      );
    }

    final sortedItems = _sortedBookmarkItems(_bookmarkItems);

    return LibraryTabSection(
      topPadding: 18,
      title: '${sortedItems.length} Titles',
      selectedSort: _bookmarksSort,
      onSortSelected: (value) {
        setState(() {
          _bookmarksSort = value;
        });
      },
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: ['All', 'Ongoing', 'Completed'].map((status) {
              final isSelected = _bookmarksStatusFilter == status;
              return Padding(
                padding: const EdgeInsets.only(right: 8.0, bottom: 16.0),
                child: FilterChip(
                  label: Text(status),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _bookmarksStatusFilter = status;
                      });
                    }
                  },
                  selectedColor: LibraryColors.primary.withValues(alpha: 0.15),
                  checkmarkColor: LibraryColors.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? LibraryColors.primary : const Color(0xFF5B6A7A),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                  backgroundColor: LibraryColors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: isSelected ? LibraryColors.primary : const Color(0xFFE9EDF1),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        if (sortedItems.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 40),
            child: Column(
              children: [
                const Icon(Icons.bookmark_border, size: 64, color: Color(0xFFBCC6D1)),
                const SizedBox(height: 16),
                const Text(
                  'No bookmarks yet',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Color(0xFF334155),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Save your favorite mangas to read them later.',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 14,
                    color: Color(0xFF94A3B8),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ...sortedItems.map((item) {
          final slug = item.mangaSlug ?? item.novelSlug ?? '';
          final title = item.manga?.title ?? item.novel?.title ?? 'Unknown';
          final cover = item.manga?.cover ?? item.novel?.cover ?? '';
          final isNovel = item.novelSlug != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: Dismissible(
              key: Key(slug),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
              ),
              onDismissed: (_) {
                setState(() {
                  _bookmarkItems.removeWhere((e) => (e.mangaSlug ?? e.novelSlug) == slug);
                });
                BookmarkApiService().deleteBookmark(slug);
              },
              child: _BookmarkCard(
                item: item,
                onTap: () {
                  final skeletonDetail = TitleDetailModel(
                    id: slug,
                    title: title,
                    coverUrl: cover,
                    author: 'Unknown',
                    status: 'Ongoing',
                    rating: 0.0,
                    chapters: 0,
                    readsLabel: '0',
                    coverColor: Colors.grey,
                    genres: isNovel ? const ['Light Novel'] : const [],
                    synopsis: 'Loading...',
                    chapterUpdates: const [],
                    relatedStories: const [],
                    reviews: const [],
                    reviewSummary: const ReviewSummaryModel(
                      average: 0,
                      ratingsCountLabel: '0',
                      bars: {},
                    ),
                    pdfUrl: isNovel ? 'placeholder' : null, // Mark as novel to trigger PDF reader logic
                  );
                  _openDetail(skeletonDetail);
                },
              ),
            ),
          );
        }),
        if (sortedItems.isNotEmpty) const LibraryRecommendBanner(),
      ],
    );
  }

  Widget _buildContinueTab() {
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
    final sortedItems = _sortedContinueItems(_historyItems);

    return RefreshIndicator(
      onRefresh: _fetchHistory,
      color: LibraryColors.primary,
      child: LibraryTabSection(
        topPadding: 16,
        selectedSort: _continueSort,
        onSortSelected: (value) {
          setState(() {
            _continueSort = value;
          });
        },
        children: sortedItems.map((item) {
          final slug = item.mangaSlug ?? item.novelSlug ?? '';
          final title = item.manga?.title ?? item.novel?.title ?? slug;
          final cover = item.manga?.cover ?? item.novel?.cover ?? '';
          final isNovel = item.novelSlug != null;

          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Dismissible(
              key: Key(slug),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
              ),
              onDismissed: (_) {
                setState(() {
                  _historyItems.removeWhere((e) => (e.mangaSlug ?? e.novelSlug) == slug);
                });
                HistoryApiService().deleteHistory(slug);
              },
              child: _HistoryCard(
                item: item,
                onTap: () => _openDetail(
                  TitleDetailModel(
                    id: slug,
                    title: title,
                    author: '',
                    status: '',
                    rating: 0,
                    chapters: 0,
                    readsLabel: '',
                    synopsis: '',
                    genres: isNovel ? const ['Light Novel'] : const [],
                    chapterUpdates: const [],
                    reviewSummary: const ReviewSummaryModel(
                      average: 0,
                      ratingsCountLabel: '',
                      bars: {},
                    ),
                    reviews: const [],
                    relatedStories: const [],
                    coverColor: const Color(0xFF1C2333),
                    coverUrl: cover,
                    pdfUrl: isNovel ? 'placeholder' : null,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
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
            child: Dismissible(
              key: Key(item.title),
              direction: DismissDirection.endToStart,
              background: Container(
                decoration: BoxDecoration(
                  color: Colors.red.shade400,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: const Icon(Icons.delete_outline, color: Colors.white, size: 28),
              ),
              onDismissed: (_) {
                // Remove from actual local data source if we had one.
              },
              child: LibraryCompletedCard(
                item: item,
                onTap: () => _openDetail(item.detail),
              ),
            ),
          );
        }),
      ],
    );
  }

  List<ApiBookmarkItem> _sortedBookmarkItems(List<ApiBookmarkItem> items) {
    // Filter first
    final filtered = items.where((item) {
      if (_bookmarksStatusFilter == 'All') return true;
      // Since ApiBookmarkItem doesn't have status from backend right now,
      // we'll just return true for everything. If backend adds status later, we can filter here.
      return true;
    }).toList();

    final result = List<ApiBookmarkItem>.from(filtered);

    switch (_bookmarksSort) {
      case LibrarySortOption.az:
        result.sort((a, b) => (a.manga?.title ?? a.novel?.title ?? '').compareTo(b.manga?.title ?? b.novel?.title ?? ''));
        break;
      case LibrarySortOption.za:
        result.sort((a, b) => (b.manga?.title ?? b.novel?.title ?? '').compareTo(a.manga?.title ?? a.novel?.title ?? ''));
        break;
      case LibrarySortOption.newestToOldest:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case LibrarySortOption.oldestToNewest:
        result.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
        break;
    }

    return result;
  }

  List<ApiHistoryItem> _sortedContinueItems(List<ApiHistoryItem> items) {
    final result = List<ApiHistoryItem>.from(items);
    switch (_continueSort) {
      case LibrarySortOption.az:
        result.sort((a, b) => (a.manga?.title ?? a.novel?.title ?? '').compareTo(b.manga?.title ?? b.novel?.title ?? ''));
        break;
      case LibrarySortOption.za:
        result.sort((a, b) => (b.manga?.title ?? b.novel?.title ?? '').compareTo(a.manga?.title ?? a.novel?.title ?? ''));
        break;
      case LibrarySortOption.newestToOldest:
        result.sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
        break;
      case LibrarySortOption.oldestToNewest:
        result.sort((a, b) => a.updatedAt.compareTo(b.updatedAt));
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

// ── Private widget: one card in the bookmarks list ────────────────────────────────────────

class _BookmarkCard extends StatelessWidget {
  final ApiBookmarkItem item;
  final VoidCallback onTap;

  const _BookmarkCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = item.manga?.title ?? item.novel?.title ?? 'Unknown';
    final cover = item.manga?.cover ?? item.novel?.cover ?? '';
    final isNovel = item.novelSlug != null;

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
        clipBehavior: Clip.antiAlias,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 86,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                image: cover.isNotEmpty
                    ? DecorationImage(
                        image: NetworkImage(cover),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              child: cover.isEmpty
                  ? const Center(child: Icon(Icons.image_not_supported, color: Colors.grey))
                  : null,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1E293B),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.bookmark, size: 16, color: LibraryColors.primary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isNovel
                                ? 'Saved Novel'
                                : (item.chapterId != null
                                    ? 'Saved Chapter ${item.chapterId}'
                                    : 'Saved Manga'),
                            style: const TextStyle(
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: LibraryColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(
                          Icons.chevron_right,
                          size: 18,
                          color: Color(0xFF94A3B8),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Private widget: one card in the reading-history list ──────────────────────────────────

class _HistoryCard extends StatelessWidget {
  final ApiHistoryItem item;
  final VoidCallback onTap;

  const _HistoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = item.manga?.title ?? item.novel?.title ?? (item.mangaSlug ?? item.novelSlug ?? '');
    final cover = item.manga?.cover ?? item.novel?.cover ?? '';
    final isNovel = item.novelSlug != null;

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
              child: cover.isNotEmpty
                  ? Image.network(
                      cover,
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
                      title,
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
                            isNovel ? 'Novel Progress' : 'Chapter ${item.chapterId}',
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
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: const LinearProgressIndicator(
                        value: 0.5, // Mock value until backend provides total chapters
                        backgroundColor: Color(0xFFE9EDF1),
                        valueColor: AlwaysStoppedAnimation<Color>(LibraryColors.primary),
                        minHeight: 4,
                      ),
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
