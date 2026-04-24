import 'package:flutter/material.dart';

import '../../../data/search_mock_data.dart';
import '../../theme/search_colors.dart';

class SearchDefaultSection extends StatelessWidget {
  final VoidCallback onClearRecent;
  final ValueChanged<String> onRecentTap;

  const SearchDefaultSection({
    super.key,
    required this.onClearRecent,
    required this.onRecentTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent Searches',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: SearchColors.title,
                ),
              ),
            ),
            TextButton(
              onPressed: onClearRecent,
              style: TextButton.styleFrom(
                foregroundColor: SearchColors.primary,
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'Clear All',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: kSearchRecentKeywords.asMap().entries.map((entry) {
              final index = entry.key;
              final keyword = entry.value;
              return Padding(
                padding: EdgeInsets.only(
                  right: index == kSearchRecentKeywords.length - 1 ? 0 : 10,
                ),
                child: GestureDetector(
                  onTap: () => onRecentTap(keyword),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: SearchColors.chipBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      keyword,
                      style: const TextStyle(
                        color: SearchColors.chipText,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
