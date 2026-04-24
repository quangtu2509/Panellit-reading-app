import 'package:flutter/material.dart';

import '../../../../app/router/smooth_page_route.dart';
import '../../data/models/search_models.dart';
import '../../data/search_mock_data.dart';
import '../theme/search_colors.dart';
import '../widgets/search/search_bottom_nav.dart';
import '../widgets/search/search_default_section.dart';
import '../widgets/search/search_input_bar.dart';
import '../widgets/search/search_results_section.dart';
import '../widgets/search/search_suggestion_panel.dart';
import '../widgets/search/search_top_bar.dart';
import 'title_detail_page.dart';

class SearchPage extends StatefulWidget {
  final VoidCallback onHomeTap;
  final VoidCallback onLibraryTap;

  const SearchPage({
    super.key,
    required this.onHomeTap,
    required this.onLibraryTap,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _activeQuery = '';

  @override
  void initState() {
    super.initState();
    _searchFocusNode.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  String get _typedQuery => _searchController.text.trim();

  bool get _showSuggestionPanel {
    return _typedQuery.isNotEmpty && _searchFocusNode.hasFocus;
  }

  List<String> get _matchedSuggestions {
    if (_typedQuery.isEmpty) {
      return const [];
    }

    final query = _typedQuery.toLowerCase();
    final matched = kSearchSuggestionSeeds
        .map((item) => item.keyword)
        .where((keyword) => keyword.toLowerCase().contains(query))
        .toSet()
        .toList();

    matched.sort((a, b) {
      final aStarts = a.toLowerCase().startsWith(query) ? 0 : 1;
      final bStarts = b.toLowerCase().startsWith(query) ? 0 : 1;
      if (aStarts != bStarts) {
        return aStarts.compareTo(bStarts);
      }
      return a.compareTo(b);
    });

    return matched;
  }

  List<String> get _matchedGenreHints {
    if (_typedQuery.isEmpty) {
      return const [];
    }

    final query = _typedQuery.toLowerCase();
    final genres = kSearchResultsCatalog
        .expand((item) => item.genres)
        .where((genre) => genre.toLowerCase().contains(query))
        .toSet()
        .toList();

    genres.sort();
    return genres.take(4).toList();
  }

  List<SearchResultModel> get _searchResults {
    if (_activeQuery.isEmpty) {
      return const [];
    }

    final query = _activeQuery.toLowerCase();
    return kSearchResultsCatalog.where((item) {
      final inTitle = item.title.toLowerCase().contains(query);
      final inAuthor = item.author.toLowerCase().contains(query);
      final inGenres = item.genres.any(
        (genre) => genre.toLowerCase().contains(query),
      );
      return inTitle || inAuthor || inGenres;
    }).toList();
  }

  void _submitQuery(String rawValue) {
    final query = rawValue.trim();
    if (query.isEmpty) {
      return;
    }

    setState(() {
      _searchController.text = query;
      _searchController.selection = TextSelection.collapsed(
        offset: query.length,
      );
      _activeQuery = query;
    });
    _searchFocusNode.unfocus();
  }

  void _clearSearch() {
    setState(() {
      _searchController.clear();
      _activeQuery = '';
    });
  }

  void _onResultTap(SearchResultModel result) {
    Navigator.of(context).push(
      buildSmoothPageRoute(
        TitleDetailPage(
          isGuest: result.openAsGuest,
          onHomeTap: widget.onHomeTap,
          onLibraryTap: widget.onLibraryTap,
          onSearchTap: () {
            Navigator.of(context).pushReplacement(
              buildSmoothPageRoute(
                SearchPage(
                  onHomeTap: widget.onHomeTap,
                  onLibraryTap: widget.onLibraryTap,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final results = _searchResults;

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
                    onChanged: (_) => setState(() {}),
                    onSubmitted: _submitQuery,
                    onClear: _clearSearch,
                  ),
                  const SizedBox(height: 20),
                  if (_showSuggestionPanel)
                    SearchSuggestionPanel(
                      query: _typedQuery,
                      suggestions: _matchedSuggestions,
                      genreHints: _matchedGenreHints,
                      onSuggestionTap: _submitQuery,
                    )
                  else if (_activeQuery.isNotEmpty)
                    SearchResultsSection(
                      results: results,
                      onClearSearch: _clearSearch,
                      onResultTap: _onResultTap,
                    )
                  else
                    SearchDefaultSection(
                      onClearRecent: () {},
                      onRecentTap: _submitQuery,
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
      ),
    );
  }
}
