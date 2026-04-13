import 'package:flutter/material.dart';

import '../../data/models/library_item.dart';
import '../theme/library_colors.dart';

class LibraryCard extends StatelessWidget {
  final LibraryItem item;

  const LibraryCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 145,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 145,
                height: 190,
                decoration: BoxDecoration(
                  color: item.coverColor,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x22000000),
                      blurRadius: 14,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.image_outlined,
                  color: Colors.white24,
                  size: 38,
                ),
              ),
              if (item.badge != null)
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: LibraryColors.badge,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      item.badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
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
                  height: 1.05,
                  fontWeight: FontWeight.w800,
                  color: LibraryColors.title,
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    item.genre,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5C7499),
                    ),
                  ),
                  const Text(
                    ' • ',
                    style: TextStyle(fontSize: 14, color: Color(0xFF9AA3AE)),
                  ),
                  Text(
                    item.updatedLabel,
                    style: const TextStyle(
                      fontSize: 14,
                      color: LibraryColors.subtitle,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: LibraryColors.pillBackground,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.chapter,
                      style: const TextStyle(
                        fontSize: 15,
                        color: LibraryColors.pillText,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Text(
                    item.actionLabel,
                    style: const TextStyle(
                      fontSize: 15,
                      color: LibraryColors.badge,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
