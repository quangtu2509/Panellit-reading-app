import 'package:flutter/material.dart';

import '../../data/models/home_content_models.dart';
import 'home_rank_card.dart';
import 'home_section_header.dart';

class HomePopularMangaSection extends StatelessWidget {
  final List<HomeRankItem> items;
  final ValueChanged<HomeRankItem> onItemTap;

  const HomePopularMangaSection({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(
          title: 'Popular Manga',
          subtitle: '',
          actionLabel: '',
        ),
        const SizedBox(height: 14),
        ...items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : 12,
            ),
            child: HomeRankCard(item: item, onTap: () => onItemTap(item)),
          );
        }),
      ],
    );
  }
}
