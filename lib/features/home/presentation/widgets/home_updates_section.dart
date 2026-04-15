import 'package:flutter/material.dart';

import '../../data/home_mock_data.dart';
import 'home_section_header.dart';
import 'home_update_card.dart';

class HomeUpdatesSection extends StatelessWidget {
  const HomeUpdatesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const HomeSectionHeader(
          title: 'New Updates',
          subtitle: 'Fresh chapters from your favorite artists',
          actionLabel: 'See All',
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 250,
          child: GridView.count(
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.73,
            children: [
              HomeUpdateCard(item: kHomeUpdates[0]),
              HomeUpdateCard(item: kHomeUpdates[1]),
              HomeUpdateCard(item: kHomeUpdates[2]),
              const SizedBox.shrink(),
            ],
          ),
        ),
      ],
    );
  }
}
