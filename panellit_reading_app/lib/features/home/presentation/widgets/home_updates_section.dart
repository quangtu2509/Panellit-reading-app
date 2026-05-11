import 'package:flutter/material.dart';

import '../../data/models/home_content_models.dart';
import 'home_section_header.dart';
import 'home_update_card.dart';

class HomeUpdatesSection extends StatelessWidget {
  final List<HomeUpdateItem> items;
  final ValueChanged<HomeUpdateItem> onItemTap;
  final VoidCallback? onSeeAllTap;

  const HomeUpdatesSection({
    super.key,
    required this.items,
    required this.onItemTap,
    this.onSeeAllTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final displayItems = items.take(4).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'New Updates',
          subtitle: 'Fresh chapters from your favorite artists',
          actionLabel: 'See All',
          onActionTap: onSeeAllTap,
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.73,
          ),
          itemCount: displayItems.length,
          itemBuilder: (context, index) {
            final item = displayItems[index];
            return HomeUpdateCard(
              item: item,
              onTap: () => onItemTap(item),
            );
          },
        ),
      ],
    );
  }
}
