import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailChaptersSection extends StatelessWidget {
  final List<ChapterUpdateModel> chapters;

  const DetailChaptersSection({super.key, required this.chapters});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Center(
          child: Text(
            'Chapters',
            style: TextStyle(
              color: TitleDetailColors.brand,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Divider(height: 1, color: TitleDetailColors.brand, thickness: 2),
        const SizedBox(height: 14),
        Row(
          children: const [
            Text(
              'Latest Updates',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w800,
                color: TitleDetailColors.textPrimary,
              ),
            ),
            Spacer(),
            Text(
              'SORT: NEWEST',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: TitleDetailColors.brand,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...chapters.map((item) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ChapterTile(item: item),
          );
        }),
        const SizedBox(height: 4),
        Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFEAEAF7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD7D9E7)),
          ),
          child: const Text(
            'See All Chapters',
            style: TextStyle(
              color: TitleDetailColors.brand,
              fontSize: 21,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final ChapterUpdateModel item;

  const _ChapterTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TitleDetailColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TitleDetailColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFFF0F2F6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.chapterNumber}',
              style: const TextStyle(
                color: Color(0xFF67758C),
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: TitleDetailColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.timeLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: TitleDetailColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          if (item.isNew)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: TitleDetailColors.brand,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                ),
              ),
            )
          else if (item.isRead)
            const Icon(
              Icons.check_circle_outline_rounded,
              color: TitleDetailColors.brand,
            )
          else
            const Icon(
              Icons.chevron_right_rounded,
              color: TitleDetailColors.muted,
            ),
        ],
      ),
    );
  }
}
