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
              'Related Stories',
              style: TextStyle(
                fontSize: 33,
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
                fontSize: 18,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final story = stories[index];
              return SizedBox(
                width: 110,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: story.coverColor,
                          borderRadius: BorderRadius.circular(14),
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
                    const SizedBox(height: 6),
                    Text(
                      story.title,
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
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemCount: stories.length,
          ),
        ),
      ],
    );
  }
}
