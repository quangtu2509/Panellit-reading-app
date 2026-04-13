import 'package:flutter/material.dart';

import '../../data/models/home_content_models.dart';
import '../theme/home_colors.dart';

class HomeNovelRow extends StatelessWidget {
  final HomeNovelItem item;
  final bool isLast;

  const HomeNovelRow({super.key, required this.item, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
              width: 38,
              child: Text(
                item.number,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFE0E0E0),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: HomeColors.title,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _Pill(text: item.tag),
                      const SizedBox(width: 8),
                      Text(
                        item.reads,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A929A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        if (!isLast)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1),
          ),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: HomeColors.chipBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 10,
          color: HomeColors.chipText,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
