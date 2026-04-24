import 'package:flutter/material.dart';

import '../../../data/models/search_models.dart';
import '../../theme/search_colors.dart';

class SearchResultsSection extends StatelessWidget {
  final List<SearchResultModel> results;
  final VoidCallback onClearSearch;
  final ValueChanged<SearchResultModel> onResultTap;

  const SearchResultsSection({
    super.key,
    required this.results,
    required this.onClearSearch,
    required this.onResultTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Results',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: SearchColors.title,
                ),
              ),
            ),
            Text(
              '${results.length} matches',
              style: const TextStyle(
                fontSize: 18,
                color: SearchColors.subtitle,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (results.isEmpty)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: SearchColors.card,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                const Text(
                  'No matching titles found',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: SearchColors.title,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Try another keyword or clear search.',
                  style: TextStyle(color: SearchColors.subtitle),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onClearSearch,
                  child: const Text('Clear search'),
                ),
              ],
            ),
          )
        else
          ...results.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _SearchResultCard(
                item: item,
                onTap: () => onResultTap(item),
              ),
            );
          }),
      ],
    );
  }
}

class _SearchResultCard extends StatelessWidget {
  final SearchResultModel item;
  final VoidCallback onTap;

  const _SearchResultCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: SearchColors.card,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFEBEEF2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 104,
                height: 140,
                decoration: BoxDecoration(
                  color: item.coverColor,
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            item.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              color: SearchColors.title,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(
                          Icons.bookmark_border_rounded,
                          color: SearchColors.subtitle,
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item.author,
                      style: const TextStyle(
                        fontSize: 16,
                        color: SearchColors.subtitle,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: item.genres.take(3).map((genre) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: SearchColors.chipBackground,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            genre.toUpperCase(),
                            style: const TextStyle(
                              color: SearchColors.chipText,
                              fontWeight: FontWeight.w700,
                              fontSize: 12,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFF1B400),
                          size: 24,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: SearchColors.title,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${item.ratingsCountLabel})',
                          style: const TextStyle(
                            fontSize: 16,
                            color: SearchColors.subtitle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
