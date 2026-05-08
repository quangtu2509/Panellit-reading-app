import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../../../core/network/models/search_api_model.dart';
import '../../../../core/network/services/search_api_service.dart';
import '../../data/models/search_models.dart';
import '../../data/models/title_detail_model.dart';
import '../theme/search_colors.dart';
import '../widgets/search/search_bottom_nav.dart';
import '../widgets/search/search_default_section.dart';
import '../widgets/search/search_input_bar.dart';
import '../widgets/search/search_results_section.dart';
import '../widgets/search/search_suggestion_panel.dart';
import '../widgets/search/search_top_bar.dart';
import 'title_detail_page.dart';

class SearchPage extends StatefulWidget {
  final bool isGuest;
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;
  final VoidCallback onProfileTap;

  const SearchPage({
    super.key,
    required this.isGuest,
    required this.onHomeTap,
    required this.onLibraryTap,
    required this.onProfileTap,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final SearchApiService _searchService = SearchApiService();

  String _activeQuery = '';
  List<SearchResultModel> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String get _typedQuery => _searchController.text.trim();

  bool get _showSuggestionPanel =>
      _typedQuery.isNotEmpty && _searchFocusNode.hasFocus;

  /// Gợi ý từ khóa từ seed list
  List<String> get _matchedSuggestions {
    return const [];
  }

  /// Thực hiện tìm kiếm thật qua API với debounce 500ms
  void _onSearchChanged(String value) {
    setState(() {});
    _debounce?.cancel();
    final trimmed = value.trim();
    if (trimmed.isEmpty) return;

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _submitQuery(trimmed, fromDebounce: true);
    });
  }

  Future<void> _submitQuery(String rawValue, {bool fromDebounce = false}) async {
    final query = rawValue.trim();
    if (query.isEmpty) return;

    setState(() {
      _searchController.text = query;
      _searchController.selection =
          TextSelection.collapsed(offset: query.length);
      _activeQuery = query;
      _isSearching = true;
    });

    if (!fromDebounce) _searchFocusNode.unfocus();

    try {
      final response = await _searchService.searchManga(keyword: query);
      if (!mounted) return;

      final results = response.items.map(_apiResultToModel).toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _searchResults = const [];
        _isSearching = false;
      });
    }
  }

  /// Map API result → SearchResultModel
  SearchResultModel _apiResultToModel(ApiSearchResult api) {
    return SearchResultModel(
      title: api.title,
      slug: api.slug,
      typeLabel: 'Manga',
      author: '',
      genres: api.categories,
      rating: 0,
      ratingsCountLabel: '',
      coverColor: const Color(0xFF0D2742),
      coverUrl: api.cover,
    );
  }



  void _clearSearch() {
    _debounce?.cancel();
    setState(() {
      _searchController.clear();
      _activeQuery = '';
      _searchResults = [];
    });
  }

  void _onResultTap(SearchResultModel result) {
    final detail = _buildDetailFromResult(result);
    final detailIsGuest = widget.isGuest || result.openAsGuest;

    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          detail: detail,
          isGuest: detailIsGuest,
          onHomeTap: widget.onHomeTap,
          onLibraryTap: widget.onLibraryTap,
          onSearchTap: () {
            Navigator.of(context).pushReplacement(
              buildSmoothPageRoute(
                SearchPage(
                  isGuest: widget.isGuest,
                  onHomeTap: widget.onHomeTap,
                  onLibraryTap: widget.onLibraryTap,
                  onProfileTap: widget.onProfileTap,
                ),
              ),
            );
          },
          onProfileTap: widget.onProfileTap,
        ),
      ),
    );
  }

  /// Tạo TitleDetailModel từ search result (Skeleton)
  TitleDetailModel _buildDetailFromResult(SearchResultModel result) {
    return TitleDetailModel(
      id: result.slug,
      title: result.title,
      author: result.author,
      status: '',
      rating: result.rating,
      chapters: 0,
      readsLabel: '',
      synopsis: '',
      genres: result.genres,
      chapterUpdates: const [],
      reviewSummary: const ReviewSummaryModel(
        average: 0,
        ratingsCountLabel: '',
        bars: {},
      ),
      reviews: const [],
      relatedStories: const [],
      coverColor: result.coverColor,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SearchColors.pageBackground,
      body: SafeArea(
        child: Column(
          children: [
            SearchTopBar(onBackTap: () => Navigator.of(context).maybePop()),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(18, 10, 18, 96),
                children: [
                  SearchInputBar(
                    controller: _searchController,
                    focusNode: _searchFocusNode,
                    onChanged: _onSearchChanged,
                    onSubmitted: (v) => _submitQuery(v),
                    onClear: _clearSearch,
                  ),
                  const SizedBox(height: 20),
                  if (_showSuggestionPanel)
                    SearchSuggestionPanel(
                      query: _typedQuery,
                      suggestions: _matchedSuggestions,
                      genreHints: const [],
                      onSuggestionTap: (v) => _submitQuery(v),
                    )
                  else if (_isSearching)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (_activeQuery.isNotEmpty)
                    SearchResultsSection(
                      results: _searchResults,
                      onClearSearch: _clearSearch,
                      onResultTap: _onResultTap,
                    )
                  else
                    SearchDefaultSection(
                      onClearRecent: () {},
                      onRecentTap: (v) => _submitQuery(v),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SearchBottomNav(
        onHomeTap: widget.onHomeTap,
        onLibraryTap: widget.onLibraryTap,
        onProfileTap: widget.onProfileTap,
      ),
    );
  }
}
