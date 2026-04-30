import 'package:flutter/material.dart';

import '../../data/home_mock_data.dart';
import '../../data/models/home_content_models.dart';
import 'home_rank_card.dart';
import 'home_section_header.dart';

class HomePopularMangaSection extends StatelessWidget {
  final ValueChanged<HomeRankItem> onItemTap;

  const HomePopularMangaSection({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(
          title: 'Popular Manga',
          subtitle: '',
          actionLabel: '',
        ),
        const SizedBox(height: 14),
        ...kHomePopularManga.map((item) {
          final index = kHomePopularManga.indexOf(item);
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == kHomePopularManga.length - 1 ? 0 : 12,
            ),
            child: HomeRankCard(item: item, onTap: () => onItemTap(item)),
          );
        }),
      ],
    );
  }
}
