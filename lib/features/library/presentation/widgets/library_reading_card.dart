import 'package:flutter/material.dart';

import '../../data/models/library_reading_item.dart';
import '../theme/library_colors.dart';

class LibraryReadingCard extends StatelessWidget {
  final LibraryReadingItem item;
  final VoidCallback? onTap;

  const LibraryReadingCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: 112,
                    height: 164,
                    decoration: BoxDecoration(
                      color: item.coverColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.image_outlined,
                      color: Colors.white24,
                      size: 34,
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1E9FA),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        item.typeLabel,
                        style: const TextStyle(
                          fontSize: 11,
                          letterSpacing: 0.2,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF2B688A),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 22,
                        height: 1.08,
                        fontWeight: FontWeight.w800,
                        color: LibraryColors.title,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item.progressLabel,
                      style: const TextStyle(
                        fontSize: 17,
                        color: Color(0xFF57698B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 14),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        minHeight: 6,
                        value: item.progressValue,
                        backgroundColor: const Color(0xFF9ED6F0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFF0E789F),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${item.progressPercent}% COMPLETE',
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.4,
                            color: Color(0xFFA1A7AD),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item.lastReadLabel,
                          style: const TextStyle(
                            fontSize: 12,
                            letterSpacing: 0.2,
                            color: Color(0xFF0F6F9B),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          'CONTINUE READING',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF0F6F9B),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 24,
                          color: Color(0xFF0F6F9B),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
