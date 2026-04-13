import 'package:flutter/material.dart';

import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';

class HomeUpdateCard extends StatelessWidget {
  final HomeUpdateItem item;

  const HomeUpdateCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final coverColor = switch (item.coverTone) {
      'dark' => const Color(0xFF111827),
      'neutral' => const Color(0xFFE7E7E7),
      _ => const Color(0xFFD7E9F1),
    };

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: HomeColors.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0C000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: coverColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: _MiniTag(label: item.episode),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              item.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Color(0xFF33363A),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${item.genre} · ${item.timeAgo}',
              style: const TextStyle(
                fontSize: 12,
                color: HomeColors.updateGenre,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniTag extends StatelessWidget {
  final String label;

  const _MiniTag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF0F7AA5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
