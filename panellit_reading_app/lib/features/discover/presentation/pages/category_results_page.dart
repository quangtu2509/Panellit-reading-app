import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/network/manga_repository.dart';
import '../../../../core/network/models/manga_api_model.dart';
import '../../../../core/network/services/novel_api_service.dart';
import '../../../discover/data/models/title_detail_model.dart';
import '../../../discover/presentation/pages/title_detail_page.dart';

/// Screen that lists all titles belonging to a specific genre/category.
/// Reached from the home screen's genre dropdown.
/// Receives a [categorySlug] (API slug, e.g. 'action') and a [categoryName]
/// (human-readable display name, e.g. 'Action') separately.
class CategoryResultsPage extends StatefulWidget {
  final String categoryName;
  final String categorySlug;
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const CategoryResultsPage({
    super.key,
    required this.categoryName,
    required this.categorySlug,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  State<CategoryResultsPage> createState() => _CategoryResultsPageState();
}

class _CategoryResultsPageState extends State<CategoryResultsPage> {
  final MangaRepository _repo = MangaRepository();

  List<ApiCategoryItem> _items = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchCategory();
  }

  Future<void> _fetchCategory() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    if (widget.categorySlug == 'light-novel') {
      try {
        final novels = await NovelApiService().getNovels();
        if (mounted) {
          setState(() {
            _items = novels
                .map((n) => ApiCategoryItem(
                      title: n.title,
                      slug: n.slug,
                      cover: n.cover ?? '',
                      categories: const ['Light Novel'],
                      latestChapterName: '1',
                      status: 'Ongoing',
                    ))
                .toList();
            _isLoading = false;
            _hasError = _items.isEmpty;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
            _hasError = true;
          });
        }
      }
      return;
    }

    final result = await _repo.getCategoryManga(widget.categorySlug);

    if (mounted) {
      setState(() {
        _items = result.items;
        _isLoading = false;
        _hasError = result.items.isEmpty && result.totalItems == 0;
      });
    }
  }

  void _openDetail(ApiCategoryItem item) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: TitleDetailModel(
            id: item.slug,
            title: item.title,
            author: '',
            status: item.status,
            rating: 0,
            chapters: 0,
            readsLabel: '',
            synopsis: '',
            genres: item.categories,
            chapterUpdates: const [],
            reviewSummary: const ReviewSummaryModel(
              average: 0,
              ratingsCountLabel: '',
              bars: {},
            ),
            reviews: const [],
            relatedStories: const [],
            coverColor: const Color(0xFF1C2333),
            coverUrl: item.cover,
            pdfUrl: widget.categorySlug == 'light-novel' ? 'placeholder' : null,
          ),
          isGuest: widget.isGuest,
          onHomeTap: widget.onHomeTap,
          onLibraryTap: widget.onLibraryTap,
          onSearchTap: widget.onSearchTap,
          onProfileTap: widget.onProfileTap,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _CategoryTopBar(categoryName: widget.categoryName),
            Expanded(
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF0F6F9B)),
      );
    }

    if (_hasError || _items.isEmpty) {
      return _EmptyState(category: widget.categoryName);
    }

    return RefreshIndicator(
      onRefresh: _fetchCategory,
      color: const Color(0xFF0F6F9B),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 32),
        itemCount: _items.length + 1, // +1 for the header
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildHeader();
          }
          final item = _items[index - 1];
          return _CategoryMangaCard(
            item: item,
            onTap: () => _openDetail(item),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1C2333),
              ),
              children: [
                const TextSpan(text: 'Thể loại '),
                TextSpan(
                  text: '"${widget.categoryName}"',
                  style: const TextStyle(color: Color(0xFF0F6F9B)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_items.length} truyện',
            style: const TextStyle(fontSize: 14, color: Color(0xFF8A96A3)),
          ),
        ],
      ),
    );
  }
}

// ── Top bar ───────────────────────────────────────────────────────────────────

class _CategoryTopBar extends StatelessWidget {
  final String categoryName;

  const _CategoryTopBar({required this.categoryName});

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
                  'Thể loại',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF8A96A3),
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  categoryName,
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

// ── Manga card ────────────────────────────────────────────────────────────────

class _CategoryMangaCard extends StatelessWidget {
  final ApiCategoryItem item;
  final VoidCallback onTap;

  const _CategoryMangaCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
              borderRadius: const BorderRadius.horizontal(left: Radius.circular(14)),
              child: Image.network(
                item.cover,
                width: 72,
                height: 96,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  width: 72,
                  height: 96,
                  color: const Color(0xFF1C2333),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.white38, size: 28),
                ),
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return Container(
                    width: 72,
                    height: 96,
                    color: const Color(0xFFE9EDF1),
                    child: const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0F6F9B),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1C2333),
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Genres chips
                    if (item.categories.isNotEmpty)
                      Wrap(
                        spacing: 4,
                        runSpacing: 4,
                        children: item.categories.take(3).map((genre) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F4F8),
                              borderRadius: BorderRadius.circular(99),
                            ),
                            child: Text(
                              genre,
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF546E7A),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 6),
                    if (item.latestChapterName.isNotEmpty)
                      Text(
                        'Chapter ${item.latestChapterName}',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF0F6F9B),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                Icons.chevron_right_rounded,
                color: Color(0xFFB0BEC5),
              ),
            ),
          ],
        ),
      ),
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
              'Không có truyện trong "$category"',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C2333),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Thử lại sau hoặc chọn thể loại khác.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF8A96A3)),
            ),
          ],
        ),
      ),
    );
  }
}
