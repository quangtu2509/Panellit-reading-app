import 'package:flutter/material.dart';

import '../theme/library_colors.dart';

class LibraryTopBar extends StatelessWidget {
  const LibraryTopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded, size: 30),
            color: LibraryColors.primary,
          ),
          const SizedBox(width: 6),
          const Text(
            'My Library',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: LibraryColors.title,
            ),
          ),
          const Spacer(),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_rounded, size: 30),
                color: LibraryColors.mutedIcon,
              ),
              Positioned(
                right: 12,
                top: 11,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Color(0xFFB13B39),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
