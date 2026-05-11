import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';

import '../../data/models/title_detail_model.dart';
import '../../../reading/presentation/pages/manga_reading_page.dart';
import '../../../reader_novel/presentation/pages/novel_reading_page.dart';
import '../../../reader_novel/presentation/pages/pdf_reading_page.dart';
import '../../../reader_novel/data/models/novel_reading_model.dart';
import '../../../../core/network/models/novel_api_model.dart';
import '../../../../core/network/models/manga_api_model.dart';
import '../theme/title_detail_colors.dart';
import '../widgets/detail/detail_bottom_nav.dart';
import '../widgets/detail/detail_chapters_section.dart';
import '../widgets/detail/detail_header_hero.dart';
import '../widgets/detail/detail_related_section.dart';
import '../widgets/detail/detail_reviews_section.dart';
import '../widgets/detail/detail_stats_genres_actions.dart';
import '../widgets/detail/detail_synopsis_section.dart';
import '../../../../core/network/manga_repository.dart';
import '../../../../core/network/services/bookmark_api_service.dart';
import '../../../../core/network/models/bookmark_api_model.dart';

class TitleDetailPage extends StatefulWidget {
  final TitleDetailModel detail;
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onSearchTap;
  final VoidCallback onProfileTap;

  const TitleDetailPage({
    super.key,
    required this.detail,
    this.isGuest = false,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onSearchTap,
    required this.onProfileTap,
  });

  @override
  State<TitleDetailPage> createState() => _TitleDetailPageState();
}

class _TitleDetailPageState extends State<TitleDetailPage> {
  int? _savedChapterNumber;
  bool _resumePromptShown = false;
  late TitleDetailModel _currentDetail;

  TitleDetailModel get _detail => _currentDetail;

  @override
  void initState() {
    super.initState();
    _currentDetail = widget.detail;
    _initializeData();
  }

  Future<void> _initializeData() async {
    await _fetchApiData();
    if (!widget.isGuest && mounted) {
      await _loadSavedChapter();
    }
  }

  Future<void> _fetchApiData() async {
    final repo = MangaRepository();
    final slug = _currentDetail.id;
    final isNovel = _currentDetail.pdfUrl != null && _currentDetail.pdfUrl!.isNotEmpty;

    try {
      final ApiMangaDetail api;
      if (isNovel) {
        api = await repo.getNovelDetail(slug: slug);
      } else {
        api = await repo.getMangaDetail(slug: slug);
      }
      
      if (!mounted) return;

      // Map API chapters
      final mappedChapters = api.chapters.asMap().entries.map((entry) {
        final c = entry.value;
        final displayName = c.chapterName.isNotEmpty ? c.chapterName : c.chapterTitle;
        return ChapterUpdateModel(
          chapterNumber: entry.key + 1,
          title: displayName,
          timeLabel: 'Recently',
          chapterApiData: c.chapterApiData,
        );
      }).toList();

      setState(() {
        _currentDetail = TitleDetailModel(
          id: _currentDetail.id,
          title: api.title.isNotEmpty ? api.title : _currentDetail.title,
          author: api.author,
          status: api.status,
          rating: _currentDetail.rating,
          chapters: api.chapters.length,
          readsLabel: _currentDetail.readsLabel,
          synopsis: api.summary.isNotEmpty ? api.summary : _currentDetail.synopsis,
          genres: api.categories.isNotEmpty ? api.categories : _currentDetail.genres,
          chapterUpdates: mappedChapters,
          reviewSummary: _currentDetail.reviewSummary,
          reviews: const [],
          relatedStories: const [],
          coverColor: _currentDetail.coverColor,
          coverUrl: api.cover.isNotEmpty ? api.cover : _currentDetail.coverUrl,
          pdfUrl: api.pdfUrl?.isNotEmpty == true ? api.pdfUrl : _currentDetail.pdfUrl,
        );
      });
    } catch (e) {
      // API call failed, keep skeleton/existing details
    }
  }

  Future<void> _loadSavedChapter() async {
    try {
      final bookmarks = await BookmarkApiService().getMyBookmarks();
      final bookmark = bookmarks.cast<ApiBookmarkItem?>().firstWhere(
            (b) => b?.mangaSlug == _detail.id,
            orElse: () => null,
          );
      
      if (!mounted) return;
      
      if (bookmark != null) {
        setState(() {
          _savedChapterNumber = bookmark.chapterId ?? 1; // Default to 1 if just bookmarked manga
        });
        _scheduleResumePrompt();
      } else {
        setState(() {
          _savedChapterNumber = null;
        });
      }
    } catch (_) {}
  }

  void _scheduleResumePrompt() {
    if (widget.isGuest || _savedChapterNumber == null || _resumePromptShown) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _resumePromptShown) {
        return;
      }
      _resumePromptShown = true;
      _showResumeDialog(_savedChapterNumber!);
    });
  }

  Future<void> _showResumeDialog(int chapterNumber) async {
    final chapterLabel = 'Chapter $chapterNumber';
    final shouldResume = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Resume reading?'),
          content: Text(
            'You saved $chapterLabel. Do you want to continue at $chapterLabel?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );

    if (shouldResume == true && mounted) {
      _openReading(chapterNumber);
    }
  }

  Future<void> _saveChapter(int? chapterNumber) async {
    if (widget.isGuest) {
      return;
    }
    
    // Optimistic UI update
    setState(() {
      _savedChapterNumber = chapterNumber;
    });

    final isNovel = _detail.pdfUrl != null && _detail.pdfUrl!.isNotEmpty;

    final result = await BookmarkApiService().toggleBookmark(
      mangaSlug: !isNovel ? _detail.id : null,
      novelSlug: isNovel ? _detail.id : null,
      mangaTitle: !isNovel ? _detail.title : null,
      novelTitle: isNovel ? _detail.title : null,
      coverUrl: _detail.coverUrl ?? '',
      chapterId: chapterNumber,
    );

    // Sync state with backend response if needed
    if (mounted && result['isSaved'] == false && chapterNumber != null) {
      // Revert if failed
      setState(() {
        _savedChapterNumber = null;
      });
    }
  }

  void _openReading(int chapterNumber) {
    // ── 1. PDF Novel ────────────────────────────────────────────────────────
    if (_detail.pdfUrl != null && _detail.pdfUrl!.isNotEmpty) {
      Navigator.of(context).push(
        buildSmoothPageRoute(
          PdfReadingPage(
            novel: ApiNovelModel(
              id:        _detail.id,
              slug:      _detail.id,
              title:     _detail.title,
              author:    _detail.author,
              cover:     _detail.coverUrl,
              pdfUrl:    _detail.pdfUrl!,
              description: _detail.synopsis,
              createdAt: DateTime.now(),
            ),
            isGuest: widget.isGuest,
          ),
        ),
      );
      return;
    }

    // ── 2. Text Novel (legacy) ───────────────────────────────────────────────
    if (_detail.genres.contains('Novel') || _detail.genres.contains('NOVEL')) {
      Navigator.of(context).push(
        buildSmoothPageRoute(
          NovelReadingPage(
            novel: NovelReadingModel(
              title: _detail.title,
              author: _detail.author,
              chapters: const [],
            ),
            initialChapterIndex: chapterNumber > 0 ? chapterNumber - 1 : 0,
            isGuest: widget.isGuest,
            isSaved: _savedChapterNumber == chapterNumber,
            onSaveChapter: _saveChapter,
          ),
        ),
      );
      return;
    }

    // ── 3. Manga ─────────────────────────────────────────────────────────────
    final chapter = _detail.chapterUpdates.firstWhere(
      (c) => c.chapterNumber == chapterNumber,
      orElse: () => ChapterUpdateModel(
        chapterNumber: chapterNumber,
        title: 'Chapter $chapterNumber',
        timeLabel: 'Unknown',
      ),
    );

    Navigator.of(context).push(
      buildSmoothPageRoute(
        MangaReadingPage(
          title: _detail.title,
          chapterLabel: chapter.title,
          chapterNumber: chapterNumber,
          chapterApiData: chapter.chapterApiData,
          allChapters: _detail.chapterUpdates,
          isGuest: widget.isGuest,
          savedChapterNumber: _savedChapterNumber,
          onSaveChapter: _saveChapter,
          mangaSlug: _detail.id,
          coverUrl:  _detail.coverUrl ?? '',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TitleDetailColors.pageBackground,
      body: Column(
        children: [
          DetailHeaderHero(
            detail: _detail,
            onBackTap: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 96),
              children: [
                DetailStatsGenresActions(
                  detail: _detail,
                  onReadTap: () {
                    final chapterNumber = _detail.chapterUpdates.isNotEmpty
                        ? _detail.chapterUpdates.first.chapterNumber
                        : 1;
                    _openReading(chapterNumber);
                  },
                ),
                const SizedBox(height: 24),
                DetailSynopsisSection(detail: _detail),
                const SizedBox(height: 24),
                DetailChaptersSection(
                  chapters: _detail.chapterUpdates,
                  savedChapterNumber: _savedChapterNumber,
                  onChapterTap: _openReading,
                ),
                const SizedBox(height: 24),
                DetailReviewsSection(
                  isGuest: widget.isGuest,
                  summary: _detail.reviewSummary,
                  reviews: _detail.reviews,
                ),
                const SizedBox(height: 24),
                DetailRelatedSection(stories: _detail.relatedStories),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: DetailBottomNav(
        onHomeTap: widget.onHomeTap,
        onLibraryTap: widget.onLibraryTap,
        onSearchTap: widget.onSearchTap,
        onProfileTap: widget.onProfileTap,
      ),
    );
  }
}
