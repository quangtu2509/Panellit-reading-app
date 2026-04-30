import 'package:flutter/material.dart';

import '../../data/home_mock_data.dart';
import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';
import 'home_novel_row.dart';
import 'home_section_header.dart';

class HomeTopWebnovelsSection extends StatelessWidget {
  final ValueChanged<HomeNovelItem> onItemTap;

  const HomeTopWebnovelsSection({super.key, required this.onItemTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(
          title: 'Top Webnovels',
          subtitle: '',
          actionLabel: '',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: HomeColors.surface,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0F000000),
                blurRadius: 24,
                offset: Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            children: kHomeTopWebnovels.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              return HomeNovelRow(
                item: item,
                isLast: index == kHomeTopWebnovels.length - 1,
                onTap: () => onItemTap(item),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
