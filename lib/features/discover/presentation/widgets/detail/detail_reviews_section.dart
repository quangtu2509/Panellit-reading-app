import 'package:flutter/material.dart';

import '../../../data/models/title_detail_model.dart';
import '../../theme/title_detail_colors.dart';

class DetailReviewsSection extends StatelessWidget {
  final bool isGuest;
  final ReviewSummaryModel summary;
  final List<CommunityReviewModel> reviews;

  const DetailReviewsSection({
    super.key,
    required this.isGuest,
    required this.summary,
    required this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Text(
              'Community Reviews',
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
        _ReviewSummaryCard(summary: summary),
        const SizedBox(height: 12),
        isGuest ? const _GuestReviewPrompt() : const _ReviewComposer(),
        const SizedBox(height: 12),
        ...reviews.map((review) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _ReviewCard(review: review),
          );
        }),
      ],
    );
  }
}

class _ReviewSummaryCard extends StatelessWidget {
  final ReviewSummaryModel summary;

  const _ReviewSummaryCard({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TitleDetailColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TitleDetailColors.divider),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Column(
              children: [
                Text(
                  '${summary.average}',
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w800,
                    color: TitleDetailColors.textPrimary,
                  ),
                ),
                const Text('☆☆☆☆☆', style: TextStyle(color: Color(0xFFF0B511))),
                Text(
                  summary.ratingsCountLabel,
                  style: const TextStyle(
                    fontSize: 13,
                    color: TitleDetailColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((score) {
                final value = summary.bars[score] ?? 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                        child: Text(
                          '$score',
                          style: const TextStyle(
                            fontSize: 12,
                            color: TitleDetailColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: value,
                            minHeight: 5,
                            backgroundColor: const Color(0xFFECF0F4),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFFF1C40F),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _GuestReviewPrompt extends StatelessWidget {
  const _GuestReviewPrompt();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFDADEE6),
          style: BorderStyle.solid,
        ),
      ),
      child: Column(
        children: [
          const Text(
            'Want to share your thoughts?',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: TitleDetailColors.chipText,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
            decoration: BoxDecoration(
              color: TitleDetailColors.brand,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x334F46E5),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              'Login to Review',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewComposer extends StatelessWidget {
  const _ReviewComposer();

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 14,
            backgroundColor: Color(0xFFE5D4B2),
            child: Icon(Icons.person_outline, size: 16, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              children: [
                Container(
                  height: 64,
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.topLeft,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F7),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFDCE2EA)),
                  ),
                  child: const Text(
                    'Write a review...',
                    style: TextStyle(color: TitleDetailColors.muted),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        '☆☆☆☆☆',
                        style: TextStyle(color: Color(0xFFBAC2CF)),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: TitleDetailColors.brand,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Post',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final CommunityReviewModel review;

  const _ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: TitleDetailColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: TitleDetailColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 14,
                backgroundColor: Color(0xFFE5D4B2),
                child: Icon(
                  Icons.person_outline,
                  size: 16,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  review.author,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: TitleDetailColors.textPrimary,
                  ),
                ),
              ),
              Text(
                review.timeLabel,
                style: const TextStyle(
                  color: TitleDetailColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            '☆☆☆☆☆',
            style: TextStyle(
              color: review.rating >= 4
                  ? const Color(0xFFF1C40F)
                  : const Color(0xFFCAD2DE),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            review.content,
            style: const TextStyle(
              height: 1.4,
              color: TitleDetailColors.chipText,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.thumb_up_alt_outlined,
                size: 14,
                color: TitleDetailColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${review.likes}',
                style: const TextStyle(
                  color: TitleDetailColors.textSecondary,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 14),
              const Icon(
                Icons.forum_outlined,
                size: 14,
                color: TitleDetailColors.textSecondary,
              ),
              const SizedBox(width: 4),
              Text(
                '${review.comments}',
                style: const TextStyle(
                  color: TitleDetailColors.textSecondary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
