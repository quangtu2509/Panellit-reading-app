import 'package:flutter/material.dart';

import '../../theme/search_colors.dart';

class SearchSuggestionPanel extends StatelessWidget {
  final String query;
  final List<String> suggestions;
  final List<String> genreHints;
  final ValueChanged<String> onSuggestionTap;

  const SearchSuggestionPanel({
    super.key,
    required this.query,
    required this.suggestions,
    required this.genreHints,
    required this.onSuggestionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (suggestions.isEmpty && genreHints.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: SearchColors.card,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(18, 16, 18, 8),
            child: Text(
              'SUGGESTIONS',
              style: TextStyle(
                fontSize: 14,
                letterSpacing: 1.0,
                fontWeight: FontWeight.w800,
                color: Color(0xFF3E5787),
              ),
            ),
          ),
          ...suggestions.take(6).map((keyword) {
            return InkWell(
              onTap: () => onSuggestionTap(keyword),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      color: SearchColors.muted,
                      size: 30,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _HighlightedSuggestion(
                        text: keyword,
                        query: query,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          if (genreHints.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 16),
              decoration: const BoxDecoration(
                border: Border(top: BorderSide(color: SearchColors.border)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'GENRES',
                    style: TextStyle(
                      fontSize: 14,
                      letterSpacing: 1.0,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF3E5787),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: genreHints.map((genre) {
                      return GestureDetector(
                        onTap: () => onSuggestionTap(genre),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: SearchColors.chipBackground,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            genre,
                            style: const TextStyle(
                              color: SearchColors.chipText,
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _HighlightedSuggestion extends StatelessWidget {
  final String text;
  final String query;

  const _HighlightedSuggestion({required this.text, required this.query});

  @override
  Widget build(BuildContext context) {
    if (query.trim().isEmpty) {
      return Text(
        text,
        style: const TextStyle(fontSize: 20, color: SearchColors.title),
      );
    }

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final index = lowerText.indexOf(lowerQuery);

    if (index < 0) {
      return Text(
        text,
        style: const TextStyle(fontSize: 20, color: SearchColors.title),
      );
    }

    final before = text.substring(0, index);
    final match = text.substring(index, index + query.length);
    final after = text.substring(index + query.length);

    return RichText(
      text: TextSpan(
        style: const TextStyle(fontSize: 20, color: SearchColors.title),
        children: [
          TextSpan(text: before),
          const TextSpan(text: ''),
          TextSpan(
            text: match,
            style: const TextStyle(
              color: SearchColors.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(text: after),
        ],
      ),
    );
  }
}
