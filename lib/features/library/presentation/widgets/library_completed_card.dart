import 'package:flutter/material.dart';

import '../../data/models/library_completed_item.dart';
import '../theme/library_colors.dart';

class LibraryCompletedCard extends StatelessWidget {
  final LibraryCompletedItem item;
  final VoidCallback? onTap;

  const LibraryCompletedCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 110,
              height: 154,
              decoration: BoxDecoration(
                color: item.coverColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.image_outlined,
                color: Colors.white24,
                size: 32,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1E9FA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: const Text(
                        'COMPLETED',
                        style: TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.3,
                          color: Color(0xFF2B688A),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.1,
                        fontWeight: FontWeight.w800,
                        color: LibraryColors.title,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.progressLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF6A7B92),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: Color(0xFFE0AC00),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A4F53),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.completionLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.2,
                            color: Color(0xFF0F6F9B),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
