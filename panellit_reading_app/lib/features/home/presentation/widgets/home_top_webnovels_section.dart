import 'package:flutter/material.dart';

import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';
import 'home_section_header.dart';

class HomeTopWebnovelsSection extends StatelessWidget {
  final List<HomeNovelItem> items;
  final ValueChanged<HomeNovelItem> onItemTap;

  const HomeTopWebnovelsSection({
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
          title: 'Top Light Novels',
          subtitle: '',
          actionLabel: '',
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
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
            children: items.map((item) {
              return InkWell(
                onTap: () => onItemTap(item),
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      // Number
                      SizedBox(
                        width: 30,
                        child: Text(
                          item.number,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: HomeColors.primary,
                          ),
                        ),
                      ),
                      // Cover
                      Container(
                        width: 48,
                        height: 64,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: HomeColors.chipBackground,
                          image: item.detail.coverUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(item.detail.coverUrl!),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                      ),
                      const SizedBox(width: 14),
                      // Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: HomeColors.title,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${item.tag} • ${item.reads}',
                              style: const TextStyle(
                                fontSize: 13,
                                color: HomeColors.muted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
