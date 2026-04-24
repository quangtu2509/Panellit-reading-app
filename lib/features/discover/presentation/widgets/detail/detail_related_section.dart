import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailRelatedSection extends StatelessWidget {
  final List<RelatedStoryModel> stories;

  const DetailRelatedSection({super.key, required this.stories});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Related comics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: TitleDetailColors.textPrimary,
              ),
            ),
            Spacer(),
            Text(
              'See All',
              style: TextStyle(
                color: TitleDetailColors.brand,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 210,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 6),
            itemBuilder: (context, index) {
              final story = stories[index];
              return SizedBox(
                width: 128,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        width: 128,
                        decoration: BoxDecoration(
                          color: story.coverColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                            margin: const EdgeInsets.all(6),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              '${story.rating}☆',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      story.title,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: TitleDetailColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(width: 14),
            itemCount: stories.length,
          ),
        ),
      ],
    );
  }
}
