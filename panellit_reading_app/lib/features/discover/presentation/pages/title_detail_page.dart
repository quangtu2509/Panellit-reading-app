import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';

import '../../data/models/title_detail_model.dart';
import '../../../reading/presentation/pages/manga_reading_page.dart';
import '../../../reader_novel/presentation/pages/novel_reading_page.dart';
import '../../../reader_novel/data/novel_mock_data.dart';
import '../../../reading/data/reading_progress_store.dart';
import '../theme/title_detail_colors.dart';
import '../widgets/detail/detail_bottom_nav.dart';
import '../widgets/detail/detail_chapters_section.dart';
import '../widgets/detail/detail_header_hero.dart';
import '../widgets/detail/detail_related_section.dart';
import '../widgets/detail/detail_reviews_section.dart';
import '../widgets/detail/detail_stats_genres_actions.dart';
import '../widgets/detail/detail_synopsis_section.dart';
import '../../../../core/network/manga_repository.dart';

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
    _fetchApiData();
    if (!widget.isGuest) {
      _loadSavedChapter();
    }
  }

  Future<void> _fetchApiData() async {
    final repo = MangaRepository();
    // Map mockId to OTruyen slug
    final slug = _currentDetail.id == 'solo_leveling'
        ? 'toi-thang-cap-mot-minh'
        : _currentDetail.id.replaceAll('_', '-');

    final result = await repo.getMangaDetail(slug: slug, mockId: _currentDetail.id);

    if (mounted && result.isFromApi && result.apiData != null) {
      final api = result.apiData!;
      
      int idx = api.chapters.length;
      final mappedChapters = api.chapters.map((c) {
        final currentIdx = idx--;
        return ChapterUpdateModel(
          chapterNumber: currentIdx,
          title: c.chapterName.isNotEmpty ? c.chapterName : c.chapterTitle,
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
          genres: _currentDetail.genres,
          chapterUpdates: mappedChapters,
          reviewSummary: _currentDetail.reviewSummary,
          reviews: _currentDetail.reviews,
          relatedStories: _currentDetail.relatedStories,
          coverColor: _currentDetail.coverColor,
        );
      });
    }
  }

  Future<void> _loadSavedChapter() async {
    final saved = await ReadingProgressStore.loadSavedChapter(_detail.title);
    if (!mounted) {
      return;
    }
    setState(() {
      _savedChapterNumber = saved;
    });
    _scheduleResumePrompt();
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

  void _saveChapter(int? chapterNumber) {
    if (widget.isGuest) {
      return;
    }
    setState(() {
      _savedChapterNumber = chapterNumber;
    });
    ReadingProgressStore.saveChapter(_detail.title, chapterNumber);
  }

  void _openReading(int chapterNumber) {
    if (_detail.genres.contains('Novel') || _detail.genres.contains('NOVEL')) {
      Navigator.of(context).push(
        buildSmoothPageRoute(
          NovelReadingPage(
            novel: getNovelModelForTitle(_detail.title),
            initialChapterIndex: chapterNumber > 0 ? chapterNumber - 1 : 0,
            isGuest: widget.isGuest,
            isSaved: _savedChapterNumber == chapterNumber,
            onSaveChapter: _saveChapter,
          ),
        ),
      );
    } else {
      // Find the specific ChapterUpdateModel
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
            isGuest: widget.isGuest,
            isSaved: _savedChapterNumber == chapterNumber,
            onSaveChapter: _saveChapter,
          ),
        ),
      );
    }
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
