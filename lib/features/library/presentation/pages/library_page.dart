import 'package:flutter/material.dart';

import '../../../home/presentation/pages/home_page.dart';
import '../../data/library_mock_data.dart';
import '../../data/models/library_item.dart';
import '../theme/library_colors.dart';
import '../widgets/library_bottom_nav.dart';
import '../widgets/library_card.dart';
import '../widgets/library_recommend_banner.dart';
import '../widgets/library_sort_button.dart';
import '../widgets/library_top_bar.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage> {
  LibrarySortOption _selectedSort = LibrarySortOption.newestToOldest;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: LibraryColors.pageBackground,
        body: SafeArea(
          child: Column(
            children: [
              const LibraryTopBar(),
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
                    _buildPlaceholderTab('Reading list will appear here.'),
                    _buildPlaceholderTab('Completed books will appear here.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: LibraryBottomNav(
          onHomeTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
    );
  }

  Widget _buildFollowingTab() {
    final sortedItems = _sortedItems(kFollowingLibraryItems);

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 96),
      children: [
        Row(
          children: [
            Text(
              '$kLibraryTotalTitles Titles',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: LibraryColors.title,
              ),
            ),
            const Spacer(),
            LibrarySortButton(
              selectedSort: _selectedSort,
              onSelected: (value) {
                setState(() {
                  _selectedSort = value;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        ...sortedItems.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 28),
            child: LibraryCard(item: item),
          );
        }),
        const LibraryRecommendBanner(),
      ],
    );
  }

  Widget _buildPlaceholderTab(String text) {
    return Center(
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          color: LibraryColors.subtitle,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  List<LibraryItem> _sortedItems(List<LibraryItem> items) {
    final result = List<LibraryItem>.from(items);

    switch (_selectedSort) {
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
}
