import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../discover/presentation/pages/search_page.dart';
import '../../../discover/presentation/pages/notifications_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../data/models/library_completed_item.dart';
import '../../data/models/library_item.dart';
import '../../data/models/library_reading_item.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../theme/library_colors.dart';
import '../widgets/library_bottom_nav.dart';
import '../widgets/library_card.dart';
import '../widgets/library_completed_card.dart';
import '../widgets/library_recommend_banner.dart';
import '../widgets/library_reading_card.dart';
import '../widgets/library_tab_section.dart';
import '../widgets/library_top_bar.dart';

class LibraryPage extends StatefulWidget {
  final bool isGuest;

  const LibraryPage({super.key, this.isGuest = false});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibrarySortOption _followingSort = LibrarySortOption.newestToOldest;
  LibrarySortOption _readingSort = LibrarySortOption.newestToOldest;
  LibrarySortOption _completedSort = LibrarySortOption.newestToOldest;

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
    final sortedItems = _sortedReadingItems(const []);

    return LibraryTabSection(
      topPadding: 16,
      selectedSort: _readingSort,
      onSortSelected: (value) {
        setState(() {
          _readingSort = value;
        });
      },
      children: [
        ...sortedItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 22),
            child: LibraryReadingCard(
              item: item,
              onTap: () => _openDetail(item.detail),
            ),
          );
        }),
      ],
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

  List<LibraryReadingItem> _sortedReadingItems(List<LibraryReadingItem> items) {
    final result = List<LibraryReadingItem>.from(items);

    switch (_readingSort) {
      case LibrarySortOption.az:
        result.sort((a, b) => a.title.compareTo(b.title));
        break;
      case LibrarySortOption.za:
        result.sort((a, b) => b.title.compareTo(a.title));
        break;
      case LibrarySortOption.newestToOldest:
        result.sort((a, b) => a.lastReadHoursAgo.compareTo(b.lastReadHoursAgo));
        break;
      case LibrarySortOption.oldestToNewest:
        result.sort((a, b) => b.lastReadHoursAgo.compareTo(a.lastReadHoursAgo));
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
